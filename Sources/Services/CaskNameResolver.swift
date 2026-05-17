import Foundation

struct CaskNameResolver: Sendable {
    private let appNameToToken: [String: String]

    init(catalog: [CaskCatalogEntry]) {
        var map: [String: String] = [:]
        for entry in catalog {
            for appName in entry.appNames {
                map[appName.lowercased()] = entry.token
            }
        }
        self.appNameToToken = map
    }

    func token(forAppName name: String) -> String? {
        appNameToToken[name.lowercased()]
    }
}
