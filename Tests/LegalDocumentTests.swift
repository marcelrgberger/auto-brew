import XCTest
@testable import AutoBrew

final class LegalDocumentTests: XCTestCase {
    func testUniqueFilenames() {
        let filenames = LegalDocument.allCases.map(\.filename)
        XCTAssertEqual(Set(filenames).count, filenames.count)
    }

    func testTitlesPresent() {
        for doc in LegalDocument.allCases {
            XCTAssertFalse(doc.titleKey.isEmpty)
        }
    }

    func testBundleContainsEveryDocument() {
        let bundle = Bundle(for: LegalBundleAnchor.self)
        for doc in LegalDocument.allCases {
            XCTAssertNotNil(
                bundle.url(forResource: doc.filename, withExtension: "md"),
                "Missing \(doc.filename).md in test bundle"
            )
        }
    }

    func testLoadProducesContent() {
        let bundle = Bundle(for: LegalBundleAnchor.self)
        let unavailable = String(localized: "Document not available.")
        for doc in LegalDocument.allCases {
            let content = doc.load(bundle: bundle)
            XCTAssertFalse(content.isEmpty, "\(doc.filename) returned empty content")
            XCTAssertNotEqual(content, unavailable, "\(doc.filename) returned fallback string")
        }
    }

    func testFallbackStringIsLocalized() {
        XCTAssertFalse(String(localized: "Document not available.").isEmpty)
    }

    func testLoadStripsMaintenanceComments() {
        let bundle = Bundle(for: LegalBundleAnchor.self)
        for doc in LegalDocument.allCases {
            XCTAssertFalse(doc.load(bundle: bundle).contains("<!--"), "\(doc.filename) shows an HTML comment")
        }
    }
    func testUnterminatedCommentIsRemovedToEnd() throws {
        let directory = FileManager.default.temporaryDirectory
            .appendingPathComponent("LegalDocuments-\(UUID().uuidString).bundle")
        defer { try? FileManager.default.removeItem(at: directory) }
        let lproj = directory.appendingPathComponent("en.lproj", isDirectory: true)
        try FileManager.default.createDirectory(at: lproj, withIntermediateDirectories: true)
        let info: [String: Any] = [
            "CFBundleIdentifier": "test.legal.documents",
            "CFBundlePackageType": "BNDL",
            "CFBundleDevelopmentRegion": "en"
        ]
        try PropertyListSerialization.data(fromPropertyList: info, format: .xml, options: 0)
            .write(to: directory.appendingPathComponent("Info.plist"))
        try "<!-- header -->\n# Title\n\nBody.\n<!-- unterminated\nhidden text"
            .write(to: lproj.appendingPathComponent("PrivacyPolicy.md"), atomically: true, encoding: .utf8)
        let bundle = try XCTUnwrap(Bundle(url: directory))
        XCTAssertEqual(LegalDocument.privacy.load(bundle: bundle), "# Title\n\nBody.")
    }

    func testHubListsEveryRequiredDocument() {
        XCTAssertEqual(Set(LegalDocument.allCases.map(\.filename)), [
            "PrivacyPolicy", "CaliforniaNoticeAtCollection", "TermsOfUse", "EULA",
            "LegalFrameworkOverview", "SupportAndUpdatePolicy", "SecurityInformation",
            "VulnerabilityDisclosure", "Impressum", "Trademark", "OpenSourceLicenses"
        ])
        for doc in LegalDocument.allCases {
            XCTAssertFalse(doc.systemImage.isEmpty, "\(doc.filename) has no icon")
        }
    }

    func testDocumentsHaveNoPlaceholdersOrFileLinks() {
        let bundle = Bundle(for: LegalBundleAnchor.self)
        for doc in LegalDocument.allCases {
            let content = doc.load(bundle: bundle)
            XCTAssertFalse(content.contains("{{"), "\(doc.filename) contains a template placeholder")
            XCTAssertNil(content.range(of: #"\]\([^)]*\.md\)"#, options: .regularExpression),
                         "\(doc.filename) links a sibling .md file")
        }
    }
}
