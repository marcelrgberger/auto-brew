import Foundation

enum BrewProcess: Sendable {
    private static let timeout: TimeInterval = 600

    /// Execute brew binary directly with argument array — no shell interpolation.
    static func run(executable: String, arguments: [String], brewPath: String) async throws -> ProcessResult {
        let process = Process()

        return try await withThrowingTaskGroup(of: ProcessResult.self) { group in
            group.addTask {
                try await execute(process: process, executable: executable, arguments: arguments, brewPath: brewPath)
            }
            group.addTask {
                try await Task.sleep(for: .seconds(timeout))
                // Kill the process on timeout so it doesn't linger
                if process.isRunning {
                    process.terminate()
                }
                throw BrewProcessError.timeout
            }

            let result = try await group.next()!
            group.cancelAll()
            // Ensure process is stopped if the other task won
            if process.isRunning {
                process.terminate()
            }
            return result
        }
    }

    private static func execute(
        process: Process,
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
