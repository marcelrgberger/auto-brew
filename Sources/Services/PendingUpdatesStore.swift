import Foundation
import os
import Observation

private let pendingLogger = Logger(subsystem: "za.co.digitalfreedom.AutoBrew", category: "PendingUpdates")

/// Holds the list of major updates waiting for the user's decision. Lives in
/// Application Support, observed by the UI. Writes are debounced through
/// `save()` because every decision change triggers one.
@Observable
@MainActor
final class PendingUpdatesStore {
    static let shared = PendingUpdatesStore()

    private(set) var updates: [PendingUpdate] = []
    private let fileURL: URL

    init(fileURL: URL? = nil) {
        if let fileURL {
            self.fileURL = fileURL
        } else {
            let base = FileManager.default
                .urls(for: .applicationSupportDirectory, in: .userDomainMask)
                .first!
                .appendingPathComponent("AutoBrew", isDirectory: true)
            try? FileManager.default.createDirectory(at: base, withIntermediateDirectories: true)
            self.fileURL = base.appendingPathComponent("PendingUpdates.json")
        }
        load()
    }

    var pendingCount: Int {
        updates.filter { $0.decision.isPending }.count
    }

    /// Replaces the store with the fresh evaluator output. Keeps existing
    /// `approved`/`rejected` decisions when `(kind, token, version)` match —
    /// the evaluator already preserves those via `existingPending`, so this
    /// is the second line of defence in case the evaluator was constructed
    /// without prior decisions.
    func replace(with bundle: [PendingUpdate]) {
        // `reduce(into:)` instead of `Dictionary(uniqueKeysWithValues:)` —
        // duplicate keys (corrupt persisted state) shouldn't crash.
        let existing: [String: PendingUpdate] = updates.reduce(into: [:]) {
            $0[Self.key(for: $1)] = $1
        }

        var merged: [PendingUpdate] = []
        for incoming in bundle {
            if let prior = existing[Self.key(for: incoming)],
               prior.availableVersion == incoming.availableVersion,
               !incoming.decision.isPending {
                // Incoming already carries a settled decision — keep it.
                merged.append(incoming)
            } else if let prior = existing[Self.key(for: incoming)],
                      prior.availableVersion == incoming.availableVersion {
                // Same `(kind, token, version)`: keep the user's prior decision.
                var copy = incoming
                copy.decision = prior.decision
                merged.append(copy)
            } else {
                merged.append(incoming)
            }
        }
        updates = merged
        save()
    }

    private static func key(for update: PendingUpdate) -> String {
        key(kind: update.kind, token: update.token)
    }

    /// Identity of a pending entry: a cask and a formula may share a token.
    static func key(kind: PackageKind, token: String) -> String {
        "\(kind.rawValue)::\(token)"
    }

    func approve(_ id: PendingUpdate.ID, now: Date = Date()) {
        update(id) { $0.decision = .approved(at: now) }
    }

    func reject(_ id: PendingUpdate.ID, now: Date = Date()) {
        update(id) { $0.decision = .rejected(at: now) }
    }

    func resetDecision(_ id: PendingUpdate.ID) {
        update(id) { $0.decision = .pending }
    }

    /// Removes the entries whose `(kind, token)` key is in `keys`; see
    /// `key(kind:token:)`.
    func remove(keys: Set<String>) {
        guard !keys.isEmpty else { return }
        updates.removeAll { keys.contains(Self.key(for: $0)) }
        save()
    }

    /// `(kind, token)` keys of the entries currently approved.
    var approvedKeys: Set<String> {
        Set(updates.filter { $0.decision.isApproved }.map(Self.key(for:)))
    }

    // MARK: - Persistence

    private func update(_ id: PendingUpdate.ID, mutate: (inout PendingUpdate) -> Void) {
        guard let index = updates.firstIndex(where: { $0.id == id }) else { return }
        mutate(&updates[index])
        save()
    }

    private func load() {
        guard FileManager.default.fileExists(atPath: fileURL.path) else { return }
        do {
            let data = try Data(contentsOf: fileURL)
            updates = try JSONDecoder.iso8601.decode([PendingUpdate].self, from: data)
        } catch {
            pendingLogger.error("Failed to read pending updates, starting fresh: \(error.localizedDescription, privacy: .public)")
            updates = []
        }
    }

    private func save() {
        do {
            let data = try JSONEncoder.iso8601.encode(updates)
            try data.write(to: fileURL, options: .atomic)
        } catch {
            pendingLogger.error("Failed to write pending updates: \(error.localizedDescription, privacy: .public)")
        }
        // The widget's pending-count badge is bound to this store. A single
        // call here covers every mutating path (replace / approve / reject /
        // remove / resetDecision) without scattering refresh hooks through
        // each public method.
        WidgetStateWriter.refresh()
    }
}
