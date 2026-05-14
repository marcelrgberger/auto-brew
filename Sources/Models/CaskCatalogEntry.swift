import Foundation

struct CaskCatalogEntry: Decodable, Identifiable, Sendable, Hashable {
    let token: String
    let nameValues: [String]
    let description: String?
    let homepage: String
    let url: String
    let version: String
    let appNames: [String]

    var id: String { token }
    var displayName: String { nameValues.first ?? token }

    enum CodingKeys: String, CodingKey {
        case token, name, desc, homepage, url, version, artifacts
    }

    private struct Artifact: Decodable {
        let app: [String]?
    }

    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        token = try c.decode(String.self, forKey: .token)
        nameValues = (try? c.decode([String].self, forKey: .name)) ?? []
        description = try c.decodeIfPresent(String.self, forKey: .desc)
        homepage = (try? c.decode(String.self, forKey: .homepage)) ?? ""
        url = (try? c.decode(String.self, forKey: .url)) ?? ""
        version = (try? c.decode(String.self, forKey: .version)) ?? ""
        let artifacts = (try? c.decode([Artifact].self, forKey: .artifacts)) ?? []
        appNames = artifacts.flatMap { $0.app ?? [] }
    }
}
