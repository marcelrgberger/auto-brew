import XCTest
@testable import AutoBrew

final class AppDiscoveryServiceTests: XCTestCase {
    func testReadsBundleIDFromTempApp() throws {
        let tmp = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString)
        let appPath = tmp.appendingPathComponent("Sample.app/Contents")
        try FileManager.default.createDirectory(at: appPath, withIntermediateDirectories: true)

        let plist: [String: Any] = [
            "CFBundleIdentifier": "com.example.Sample",
            "CFBundleName": "Sample",
            "CFBundleShortVersionString": "1.2.3"
        ]
        let data = try PropertyListSerialization.data(fromPropertyList: plist, format: .xml, options: 0)
        try data.write(to: appPath.appendingPathComponent("Info.plist"))
        defer { try? FileManager.default.removeItem(at: tmp) }

        let svc = AppDiscoveryService()
        let app = svc.readApp(at: appPath.deletingLastPathComponent())

        XCTAssertEqual(app?.bundleID, "com.example.Sample")
        XCTAssertEqual(app?.displayName, "Sample")
        XCTAssertEqual(app?.version, "1.2.3")
    }

    func testFiltersAppleApps() async throws {
        let svc = AppDiscoveryService()
        let apps = await svc.scan(directories: [URL(fileURLWithPath: "/System/Applications")],
                                  resolver: CaskNameResolver(catalog: []))
        XCTAssertTrue(apps.allSatisfy { !AppleAppFilter.isAppleSystemApp(bundleID: $0.bundleID) })
    }
}
