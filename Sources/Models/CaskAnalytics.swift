import Foundation

struct CaskAnalytics: Decodable, Sendable {
    private let counts: [String: Int]

    init(counts: [String: Int]) { self.counts = counts }

    func installCount(for token: String) -> Int { counts[token] ?? 0 }

    enum CodingKeys: String, CodingKey { case items }
    private struct Item: Decodable { let cask: String; let count: String }

    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        let items = (try? c.decode([Item].self, forKey: .items)) ?? []
        var map: [String: Int] = [:]
        for item in items {
            let clean = item.count.replacingOccurrences(of: ",", with: "")
            map[item.cask] = Int(clean) ?? 0
        }
        counts = map
    }
}
