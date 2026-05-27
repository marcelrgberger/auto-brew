import Foundation

/// Parsed result of `brew doctor`. Brew's own output is a stream of
/// `Warning:` / `Error:` blocks separated by blank lines; the parser
/// chunks them into discrete `Finding`s so the UI can group by
/// severity and render each block with its own disclosure.
struct DoctorReport: Sendable, Equatable, Codable {
    enum Severity: String, Sendable, Codable, Equatable {
        case warning
        case error
    }

    struct Finding: Sendable, Identifiable, Codable, Equatable {
        let id: UUID
        let severity: Severity
        let title: String
        let body: String

        init(id: UUID = UUID(), severity: Severity, title: String, body: String) {
            self.id = id
            self.severity = severity
            self.title = title
            self.body = body
        }
    }

    let findings: [Finding]
    let ranAt: Date
    let raw: String

    var isHealthy: Bool { findings.isEmpty }
    var warningCount: Int { findings.filter { $0.severity == .warning }.count }
    var errorCount: Int { findings.filter { $0.severity == .error }.count }
}

extension DoctorReport {
    /// Parses `brew doctor` stdout into discrete findings. Brew emits
    /// blocks like:
    ///
    ///     Warning: Some installed formulae are missing dependencies.
    ///       You should run `brew missing` to see which ones.
    ///
    ///     Error: Something went wrong.
    ///       Detail line 1.
    ///       Detail line 2.
    ///
    /// We split on blank lines and treat any block whose first
    /// non-empty line begins with `Warning:` or `Error:` as a
    /// classified finding; the remainder of the title-line is the
    /// short title and any continuation lines become the body.
    static func parse(_ raw: String, ranAt: Date = Date()) -> DoctorReport {
        let blocks = raw
            .split(separator: "\n\n", omittingEmptySubsequences: true)
            .map { String($0) }

        var findings: [Finding] = []
        for block in blocks {
            let lines = block.split(separator: "\n", omittingEmptySubsequences: false).map(String.init)
            guard let firstLine = lines.first(where: { !$0.trimmingCharacters(in: .whitespaces).isEmpty }) else {
                continue
            }
            let trimmed = firstLine.trimmingCharacters(in: .whitespaces)
            let severity: Severity
            let title: String
            if trimmed.lowercased().hasPrefix("warning:") {
                severity = .warning
                title = String(trimmed.dropFirst("warning:".count)).trimmingCharacters(in: .whitespaces)
            } else if trimmed.lowercased().hasPrefix("error:") {
                severity = .error
                title = String(trimmed.dropFirst("error:".count)).trimmingCharacters(in: .whitespaces)
            } else {
                // Treat unclassified blocks (e.g. "Your system is
                // ready to brew.") as healthy-noise rather than
                // findings. Skip.
                continue
            }
            let body = lines
                .drop(while: { $0 != firstLine })
                .dropFirst()
                .joined(separator: "\n")
                .trimmingCharacters(in: .whitespacesAndNewlines)
            findings.append(Finding(severity: severity, title: title, body: body))
        }
        return DoctorReport(findings: findings, ranAt: ranAt, raw: raw)
    }
}
