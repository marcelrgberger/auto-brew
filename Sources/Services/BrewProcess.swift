import Foundation

/// Lock-protected wrapper around `Process` so concurrent tasks (execution +
/// timeout watcher) can coordinate without racing on `isRunning`/`terminate()`.
/// `Process` is not `Sendable`, so we encapsulate every access behind an
/// `NSLock` and mark the holder `@unchecked Sendable`.
private final class ProcessHolder: @unchecked Sendable {
    private let lock = NSLock()
    private var process: Process?
    private var terminated = false

    /// Attach a freshly-created Process. Returns `false` if the holder was
    /// already terminated (timeout/cancel fired before attach); the caller
    /// must abort and NOT start the process in that case.
    func attach(_ p: Process) -> Bool {
        lock.withLock {
            if terminated { return false }
            self.process = p
            return true
        }
    }

    /// True if the holder has been marked terminated (caller should not start
    /// or should immediately terminate the process).
    var isTerminated: Bool {
        lock.withLock { terminated }
    }

    func terminateIfRunning() {
        lock.withLock {
            guard !terminated else { return }
            if let p = process, p.isRunning {
                p.terminate()
            }
            terminated = true
        }
    }
}

enum BrewProcess: Sendable {
    private static let timeout: TimeInterval = 600

    /// Execute brew binary directly with argument array — no shell interpolation.
    static func run(executable: String, arguments: [String], brewPath: String) async throws -> ProcessResult {
        let holder = ProcessHolder()

        return try await withTaskCancellationHandler {
            try await withThrowingTaskGroup(of: ProcessResult?.self) { group in
                group.addTask {
                    try await execute(holder: holder, executable: executable, arguments: arguments, brewPath: brewPath)
                }
                group.addTask {
                    do {
                        try await Task.sleep(for: .seconds(timeout))
                    } catch is CancellationError {
                        return nil // Normal: process finished before timeout
                    }
                    holder.terminateIfRunning()
                    throw BrewProcessError.timeout
                }

                while let next = try await group.next() {
                    if let result = next {
                        group.cancelAll()
                        holder.terminateIfRunning()
                        return result
                    }
                }
                throw BrewProcessError.timeout
            }
        } onCancel: {
            // Parent task cancelled — kill the child process so it doesn't leak.
            holder.terminateIfRunning()
        }
    }

    private static func execute(
        holder: ProcessHolder,
        executable: String,
        arguments: [String],
        brewPath: String
    ) async throws -> ProcessResult {
        final class PipeBuffer: @unchecked Sendable {
            private let lock = NSLock()
            private var data = Data()
            func append(_ chunk: Data) { lock.withLock { data.append(chunk) } }
            func finalize() -> Data { lock.withLock { data } }
        }

        return try await withCheckedThrowingContinuation { continuation in
            let process = Process()
            guard holder.attach(process) else {
                continuation.resume(throwing: CancellationError())
                return
            }
            let stdoutPipe = Pipe()
            let stderrPipe = Pipe()

            process.executableURL = URL(fileURLWithPath: executable)
            process.arguments = arguments
            var env = ProcessInfo.processInfo.environment
            env["HOMEBREW_NO_AUTO_UPDATE"] = "1"
            env["PATH"] = "\(brewPath):/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin"
            process.environment = env
            process.standardOutput = stdoutPipe
            process.standardError = stderrPipe

            let stdoutBuffer = PipeBuffer()
            let stderrBuffer = PipeBuffer()

            stdoutPipe.fileHandleForReading.readabilityHandler = { handle in
                let chunk = handle.availableData
                if !chunk.isEmpty { stdoutBuffer.append(chunk) }
            }
            stderrPipe.fileHandleForReading.readabilityHandler = { handle in
                let chunk = handle.availableData
                if !chunk.isEmpty { stderrBuffer.append(chunk) }
            }

            process.terminationHandler = { proc in
                stdoutPipe.fileHandleForReading.readabilityHandler = nil
                stderrPipe.fileHandleForReading.readabilityHandler = nil
                stdoutBuffer.append(stdoutPipe.fileHandleForReading.readDataToEndOfFile())
                stderrBuffer.append(stderrPipe.fileHandleForReading.readDataToEndOfFile())

                let result = ProcessResult(
                    exitCode: proc.terminationStatus,
                    stdout: String(data: stdoutBuffer.finalize(), encoding: .utf8) ?? "",
                    stderr: String(data: stderrBuffer.finalize(), encoding: .utf8) ?? ""
                )
                continuation.resume(returning: result)
            }

            do {
                try process.run()
                // Cancellation/timeout could have fired between attach and run —
                // terminate immediately if so.
                if holder.isTerminated, process.isRunning {
                    process.terminate()
                }
            } catch {
                continuation.resume(throwing: error)
            }
        }
    }
}

enum BrewProcessError: LocalizedError, Sendable {
    case timeout

    var errorDescription: String? {
        switch self {
        case .timeout: "Process timed out after 10 minutes"
        }
    }
}
