import XCTest
@testable import AutoBrew

final class MarkdownParserTests: XCTestCase {
    func testHeadingLevels() {
        let blocks = MarkdownParser.parse("# H1\n\n## H2\n\n### H3")
        XCTAssertEqual(blocks, [
            .heading1("H1"),
            .heading2("H2"),
            .heading3("H3")
        ])
    }

    func testParagraphsJoinWrappedLines() {
        let blocks = MarkdownParser.parse("First line\nstill first.\n\nSecond paragraph.")
        XCTAssertEqual(blocks, [
            .paragraph("First line still first."),
            .paragraph("Second paragraph.")
        ])
    }

    func testBulletListsAcceptBothMarkers() {
        let blocks = MarkdownParser.parse("- one\n- two\n* three")
        XCTAssertEqual(blocks, [.bulletList(["one", "two", "three"])])
    }

    func testNumberedLists() {
        let blocks = MarkdownParser.parse("1. first\n2. second\n10. tenth")
        XCTAssertEqual(blocks, [.numberedList(["first", "second", "tenth"])])
    }

    func testHorizontalRule() {
        let blocks = MarkdownParser.parse("Above\n\n---\n\nBelow")
        XCTAssertEqual(blocks, [
            .paragraph("Above"),
            .horizontalRule,
            .paragraph("Below")
        ])
    }

    func testMixedStructureFlushesCorrectly() {
        let input = """
        # Title

        Intro paragraph.

        - item a
        - item b

        Closing paragraph.
        """
        let blocks = MarkdownParser.parse(input)
        XCTAssertEqual(blocks, [
            .heading1("Title"),
            .paragraph("Intro paragraph."),
            .bulletList(["item a", "item b"]),
            .paragraph("Closing paragraph.")
        ])
    }

    func testBlockquoteMarkersAreUnwrapped() {
        let blocks = MarkdownParser.parse("> Quoted text\n>\n> - first\n> - second")
        XCTAssertEqual(blocks, [
            .paragraph("Quoted text"),
            .bulletList(["first", "second"])
        ])
    }
    func testQuotedCodeFenceClosesInsideQuote() {
        let blocks = MarkdownParser.parse("> ```\n> line one\n>   indented\n> ```\n\nAfter the quote.")
        XCTAssertEqual(blocks, [
            .codeBlock("line one\n  indented"),
            .paragraph("After the quote.")
        ])
    }
}
