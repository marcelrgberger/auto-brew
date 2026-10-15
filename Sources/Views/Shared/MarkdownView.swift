import SwiftUI

/// Block-level Markdown renderer built on top of `AttributedString` for inline
/// styling. Hand-rolled rather than pulled from SPM because the legal texts
/// only use a handful of constructs and we don't want a third-party dependency
/// for something this small.
struct MarkdownView: View {
    let blocks: [MarkdownBlock]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            ForEach(Array(blocks.enumerated()), id: \.offset) { _, block in
                render(block)
            }
        }
    }

    @ViewBuilder
    private func render(_ block: MarkdownBlock) -> some View {
        switch block {
        case .heading1(let text):
            Text(inline(text))
                .font(.title.bold())
                .padding(.top, 8)
        case .heading2(let text):
            Text(inline(text))
                .font(.title2.bold())
                .padding(.top, 6)
        case .heading3(let text):
            Text(inline(text))
                .font(.headline)
                .padding(.top, 4)
        case .heading4(let text):
            Text(inline(text))
                .font(.subheadline.weight(.semibold))
                .padding(.top, 2)
        case .paragraph(let text):
            Text(inline(text))
                .font(.body)
                .fixedSize(horizontal: false, vertical: true)
        case .bulletList(let items):
            VStack(alignment: .leading, spacing: 4) {
                ForEach(Array(items.enumerated()), id: \.offset) { _, item in
                    HStack(alignment: .top, spacing: 8) {
                        Text("•")
                            .font(.body)
                            .foregroundStyle(.secondary)
                            .accessibilityHidden(true)
                        Text(inline(item))
                            .font(.body)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    .accessibilityElement(children: .combine)
                }
            }
        case .numberedList(let items):
            VStack(alignment: .leading, spacing: 4) {
                ForEach(Array(items.enumerated()), id: \.offset) { index, item in
                    HStack(alignment: .top, spacing: 8) {
                        Text("\(index + 1).")
                            .font(.body)
                            .foregroundStyle(.secondary)
                            .frame(minWidth: 20, alignment: .trailing)
                            .accessibilityHidden(true)
                        Text(inline(item))
                            .font(.body)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    .accessibilityElement(children: .combine)
                }
            }
        case .codeBlock(let text):
            // Monospaced, slightly tinted background. Preserves whitespace so
            // license headers and component metadata blocks stay aligned.
            Text(text)
                .font(.system(.caption, design: .monospaced))
                .foregroundStyle(.primary)
                .padding(10)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.secondary.opacity(0.10), in: RoundedRectangle(cornerRadius: 6))
                .fixedSize(horizontal: false, vertical: true)
        case .table(let headers, let rows):
            // Simple equal-width grid. Legal docs use short narrative tables
            // (3-4 columns), so even-column allocation reads fine and avoids
            // the headache of measuring intrinsic content widths in SwiftUI.
            VStack(alignment: .leading, spacing: 0) {
                Grid(alignment: .leadingFirstTextBaseline, horizontalSpacing: 12, verticalSpacing: 6) {
                    if !headers.isEmpty {
                        GridRow {
                            ForEach(Array(headers.enumerated()), id: \.offset) { _, header in
                                Text(inline(header))
                                    .font(.caption.weight(.semibold))
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                        }
                        Divider()
                    }
                    ForEach(Array(rows.enumerated()), id: \.offset) { _, row in
                        GridRow {
                            ForEach(Array(row.enumerated()), id: \.offset) { _, cell in
                                Text(inline(cell))
                                    .font(.caption)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .fixedSize(horizontal: false, vertical: true)
                            }
                        }
                    }
                }
                .padding(8)
                .background(Color.secondary.opacity(0.05), in: RoundedRectangle(cornerRadius: 6))
            }
        case .horizontalRule:
            Divider()
                .padding(.vertical, 4)
        }
    }

    /// Inline parser handles `**bold**`, `*italic*`, `` `code` ``, `[link](url)`.
    /// Block-level constructs are pre-stripped by `MarkdownParser`; if Apple's
    /// parser still fails we render the raw text rather than dropping it.
    private func inline(_ text: String) -> AttributedString {
        (try? AttributedString(markdown: text, options: .init(interpretedSyntax: .inlineOnlyPreservingWhitespace)))
            ?? AttributedString(text)
    }
}

enum MarkdownBlock: Equatable, Sendable {
    case heading1(String)
    case heading2(String)
    case heading3(String)
    case heading4(String)
    case paragraph(String)
    case bulletList([String])
    case numberedList([String])
    case codeBlock(String)
    case table(headers: [String], rows: [[String]])
    case horizontalRule
}

enum MarkdownParser {
    /// Line-oriented parser. Greedy: collects consecutive paragraph / list
    /// lines into buffers and flushes them on blank lines, headings, or rules.
    static func parse(_ text: String) -> [MarkdownBlock] {
        // Some editors save legal docs with CRLF; strip the carriage return
        // up front so heading / bullet detection still works.
        let normalized = text.replacingOccurrences(of: "\r\n", with: "\n")

        var blocks: [MarkdownBlock] = []
        var paragraphBuffer: [String] = []
        var bulletBuffer: [String] = []
        var numberedBuffer: [String] = []
        var tableBuffer: [[String]] = []

        func flushParagraph() {
            guard !paragraphBuffer.isEmpty else { return }
            blocks.append(.paragraph(paragraphBuffer.joined(separator: " ")))
            paragraphBuffer.removeAll()
        }

        func flushBullets() {
            guard !bulletBuffer.isEmpty else { return }
            blocks.append(.bulletList(bulletBuffer))
            bulletBuffer.removeAll()
        }

        func flushNumbered() {
            guard !numberedBuffer.isEmpty else { return }
            blocks.append(.numberedList(numberedBuffer))
            numberedBuffer.removeAll()
        }

        func flushTable() {
            guard !tableBuffer.isEmpty else { return }
            // First row is headers; second is the separator (|---|---|); the
            // rest are body rows. If the second row is missing or non-separator
            // we still render — degraded but readable.
            let headers = tableBuffer.first ?? []
            let body: [[String]]
            if tableBuffer.count >= 2, isTableSeparator(tableBuffer[1]) {
                body = Array(tableBuffer.dropFirst(2))
            } else {
                body = Array(tableBuffer.dropFirst())
            }
            blocks.append(.table(headers: headers, rows: body))
            tableBuffer.removeAll()
        }

        func flushAll() {
            flushParagraph()
            flushBullets()
            flushNumbered()
            flushTable()
        }

        let rawLines = normalized.components(separatedBy: "\n")
        var index = 0

        while index < rawLines.count {
            let rawLine = rawLines[index]
            var line = rawLine.trimmingCharacters(in: .whitespacesAndNewlines)
            // Blockquote marker — the legal templates quote statutory text
            // (e.g. the Australian Consumer Law notice) as `> ...`. Unwrap it
            // so the quoted paragraphs and bullets render as normal blocks
            // instead of showing a literal `>`.
            let isQuoted = line.hasPrefix(">")
            if isQuoted {
                line = String(line.dropFirst()).trimmingCharacters(in: .whitespaces)
            }

            // Fenced code block — preserve interior whitespace verbatim, do
            // not trim. Opening fence may carry a language tag we discard.
            // A fence opened inside a quote is read with the quote marker
            // removed from every interior line, so its closing `> ```` is
            // recognised the same way the opening one was.
            if line.hasPrefix("```") {
                flushAll()
                var codeLines: [String] = []
                index += 1
                while index < rawLines.count {
                    let next = isQuoted ? unquote(rawLines[index]) : rawLines[index]
                    if next.trimmingCharacters(in: .whitespacesAndNewlines).hasPrefix("```") {
                        index += 1
                        break
                    }
                    codeLines.append(next)
                    index += 1
                }
                blocks.append(.codeBlock(codeLines.joined(separator: "\n")))
                continue
            }

            if line.isEmpty {
                flushAll()
                index += 1
                continue
            }

            if line == "---" || line == "***" {
                flushAll()
                blocks.append(.horizontalRule)
                index += 1
                continue
            }

            if line.hasPrefix("#### ") {
                flushAll()
                blocks.append(.heading4(String(line.dropFirst(5))))
                index += 1
                continue
            }
            if line.hasPrefix("### ") {
                flushAll()
                blocks.append(.heading3(String(line.dropFirst(4))))
                index += 1
                continue
            }
            if line.hasPrefix("## ") {
                flushAll()
                blocks.append(.heading2(String(line.dropFirst(3))))
                index += 1
                continue
            }
            if line.hasPrefix("# ") {
                flushAll()
                blocks.append(.heading1(String(line.dropFirst(2))))
                index += 1
                continue
            }

            // Markdown table row — starts with `|`. The separator row
            // (`|---|---|`) is captured so flushTable can detect headers.
            if line.hasPrefix("|") {
                flushParagraph()
                flushBullets()
                flushNumbered()
                tableBuffer.append(parseTableRow(line))
                index += 1
                continue
            }

            if line.hasPrefix("- ") || line.hasPrefix("* ") {
                flushParagraph()
                flushNumbered()
                flushTable()
                bulletBuffer.append(String(line.dropFirst(2)))
                index += 1
                continue
            }

            if let numberedItem = parseNumberedItem(line) {
                flushParagraph()
                flushBullets()
                flushTable()
                numberedBuffer.append(numberedItem)
                index += 1
                continue
            }

            // Paragraph line — soft-wrap by appending to the current buffer.
            flushBullets()
            flushNumbered()
            flushTable()
            paragraphBuffer.append(line)
            index += 1
        }

        flushAll()
        return blocks
    }

    /// Removes a leading blockquote marker (`>` plus one optional space)
    /// while keeping the remaining indentation, for lines inside a quoted
    /// code block. Lines without a marker are returned unchanged.
    private static func unquote(_ rawLine: String) -> String {
        let leading = rawLine.prefix(while: { $0 == " " || $0 == "\t" })
        let rest = rawLine.dropFirst(leading.count)
        guard rest.hasPrefix(">") else { return rawLine }
        let afterMarker = rest.dropFirst()
        return String(afterMarker.hasPrefix(" ") ? afterMarker.dropFirst() : afterMarker)
    }

    /// Recognises `1. text`, `42. text`, etc. Returns the trimmed text after
    /// the period; returns `nil` if the line does not look like a numbered item.
    private static func parseNumberedItem(_ line: String) -> String? {
        var index = line.startIndex
        while index < line.endIndex, line[index].isNumber {
            index = line.index(after: index)
        }
        guard index > line.startIndex,
              index < line.endIndex,
              line[index] == ".",
              line.index(after: index) < line.endIndex,
              line[line.index(after: index)] == " " else {
            return nil
        }
        return String(line[line.index(index, offsetBy: 2)...])
    }

    /// Splits `| a | b | c |` into `["a", "b", "c"]`. Tolerant of missing
    /// leading or trailing pipe and of extra whitespace around cells.
    private static func parseTableRow(_ line: String) -> [String] {
        var trimmed = line
        if trimmed.hasPrefix("|") { trimmed.removeFirst() }
        if trimmed.hasSuffix("|") { trimmed.removeLast() }
        return trimmed
            .components(separatedBy: "|")
            .map { $0.trimmingCharacters(in: .whitespaces) }
    }

    /// `|---|:---:|---|` style separator row. Cells contain only `-`, `:`
    /// and spaces — used to decide whether the first row is a header row.
    private static func isTableSeparator(_ cells: [String]) -> Bool {
        guard !cells.isEmpty else { return false }
        let allowed = CharacterSet(charactersIn: "-: ")
        return cells.allSatisfy { cell in
            !cell.isEmpty && cell.unicodeScalars.allSatisfy(allowed.contains)
        }
    }
}
