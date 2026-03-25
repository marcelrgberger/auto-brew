import Foundation

enum BrewProcess: Sendable {
    private static let timeout: TimeInterval = 600 // 10 minutes

    static func run(_ command: String, brewPath: String) async throws -> ProcessResult {
        try await withThrowingTaskGroup(of: ProcessResult.self) { group in
            group.addTask {
                try await execute(command, brewPath: brewPath)
            }
            group.addTask {
                try await Task.sleep(for: .seconds(timeout))
                throw BrewProcessError.timeout
            }

            let result = try await group.next()!
            group.cancelAll()
            return result
        }
    }

    private static func execute(_ command: String, brewPath: String) async throws -> ProcessResult {
        // Thread-safe accumulator for pipe data collected from concurrent handlers.
        final class PipeBuffer: @unchecked Sendable {
            private let lock = NSLock()
            private var data = Data()

            func append(_ chunk: Data) {
                lock.withLock { data.append(chunk) }
            }

            func finalize() -> Data {
                lock.withLock { data }
            }
        }

        return try await withCheckedThrowingContinuation { continuation in
            let process = Process()
            let stdoutPipe = Pipe()
            let stderrPipe = Pipe()

            process.executableURL = URL(fileURLWithPath: "/bin/zsh")
            process.arguments = ["-c", command]
            var env = ProcessInfo.processInfo.environment
            env["HOMEBREW_NO_AUTO_UPDATE"] = "1"
            env["PATH"] = "\(brewPath):/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin"
            process.environment = env
            process.standardOutput = stdoutPipe
            process.standardError = stderrPipe

            // Drain pipes asynchronously to prevent deadlock when buffer fills.
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
                // Stop handlers then drain any remaining bytes.
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
