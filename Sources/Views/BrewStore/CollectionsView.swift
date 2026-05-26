import SwiftUI
import UniformTypeIdentifiers

/// Master/detail surface for cask collections. Left: list of
/// collections with add/import/export controls. Right: tokens in the
/// selected collection plus bulk install/uninstall buttons.
struct CollectionsView: View {
    @State private var store = CollectionsStore.shared
    @State private var selectedCollection: CaskCollection.ID?
    @State private var newCollectionName = ""
    @State private var showCreateSheet = false
    @State private var importingFile = false
    @State private var operationError: String?
    @State private var bulkInProgress = false
    @State private var bulkProgress: BulkProgress?

    fileprivate struct BulkProgress {
        var total: Int
        var done: Int
        var currentToken: String?
        var failures: [String]
    }

    var body: some View {
        // CollectionsView is rendered as the detail pane of the outer
        // BrewStore NavigationSplitView. A nested NavigationSplitView
        // here produced a second sidebar inside the detail column,
        // which on narrow widths squashed the inner list and clipped
        // the "No collection selected" placeholder. Use a flat
        // HStack split instead — same master/detail UX, no nested
        // navigation chrome.
        HStack(spacing: 0) {
            sidebar
                .frame(minWidth: 220, idealWidth: 260, maxWidth: 320)
            Divider()
            detail
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .alert(String(localized: "Collection error"),
               isPresented: Binding(get: { operationError != nil },
                                    set: { if !$0 { operationError = nil } }),
               presenting: operationError) { _ in
            Button("OK") { operationError = nil }
        } message: { msg in Text(msg) }
    }

    // MARK: - Sidebar

    private var sidebar: some View {
        VStack(spacing: 0) {
            List(selection: $selectedCollection) {
                ForEach(store.sortedCollections) { collection in
                    VStack(alignment: .leading, spacing: 2) {
                        Text(collection.name)
                            .font(.body.weight(.medium))
                        Text(String(localized: "\(collection.tokens.count) casks"))
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    .tag(collection.id)
                    .contextMenu {
                        Button(String(localized: "Export…")) { exportCollection(collection) }
                        Button(role: .destructive) {
                            store.delete(collection.id)
                            if selectedCollection == collection.id { selectedCollection = nil }
                        } label: {
                            Text(String(localized: "Delete"))
                        }
                    }
                }
            }
            .listStyle(.sidebar)

            Divider()
            HStack(spacing: 4) {
                Button {
                    newCollectionName = ""
                    showCreateSheet = true
                } label: {
                    Image(systemName: "plus")
                }
                .help(String(localized: "Create collection"))
                Button {
                    importingFile = true
                } label: {
                    Image(systemName: "tray.and.arrow.down")
                }
                .help(String(localized: "Import collection from file"))
                Spacer()
            }
            .padding(8)
        }
        .sheet(isPresented: $showCreateSheet) {
            createSheet
        }
        .fileImporter(isPresented: $importingFile,
                      allowedContentTypes: [autobrewCollectionType, .json],
                      allowsMultipleSelection: false) { result in
            handleImport(result)
        }
    }

    private var createSheet: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(String(localized: "New collection"))
                .font(.headline)
            TextField(String(localized: "Name (e.g. Dev Setup)"),
                      text: $newCollectionName)
            HStack {
                Button(String(localized: "Cancel"), role: .cancel) {
                    showCreateSheet = false
                }
                Spacer()
                Button(String(localized: "Create")) {
                    let trimmed = newCollectionName.trimmingCharacters(in: .whitespaces)
                    guard !trimmed.isEmpty else { return }
                    let created = store.create(name: trimmed)
                    selectedCollection = created.id
                    showCreateSheet = false
                }
                .keyboardShortcut(.defaultAction)
                .disabled(newCollectionName.trimmingCharacters(in: .whitespaces).isEmpty)
            }
        }
        .padding(20)
        .frame(width: 360)
    }

    // MARK: - Detail

    @ViewBuilder
    private var detail: some View {
        if let id = selectedCollection,
           let collection = store.collections.first(where: { $0.id == id }) {
            CollectionDetailView(
                collection: collection,
                bulkInProgress: $bulkInProgress,
                bulkProgress: $bulkProgress,
                operationError: $operationError
            )
        } else {
            ContentUnavailableView(
                String(localized: "No collection selected"),
                systemImage: "rectangle.stack",
                description: Text(String(localized: "Pick a collection from the sidebar — or create one with the + button."))
            )
        }
    }

    // MARK: - Import / Export

    private func exportCollection(_ collection: CaskCollection) {
        let panel = NSSavePanel()
        panel.nameFieldStringValue = "\(collection.name).autobrewcollection"
        panel.allowedContentTypes = [autobrewCollectionType, .json]
        NSApp.activate(ignoringOtherApps: true)
        guard panel.runModal() == .OK, let url = panel.url else { return }
        do {
            try store.export(collection.id, to: url)
        } catch {
            operationError = error.localizedDescription
        }
    }

    private func handleImport(_ result: Result<[URL], Error>) {
        switch result {
        case .success(let urls):
            guard let url = urls.first else { return }
            do {
                let imported = try store.import(from: url)
                selectedCollection = imported.id
            } catch {
                operationError = error.localizedDescription
            }
        case .failure(let error):
            operationError = error.localizedDescription
        }
    }

    // Treat .autobrewcollection as a JSON-based UTI for the file
    // pickers. Registration in the main app Info.plist is optional —
    // Save/Open panels filter by UTI conformance, and JSON is the
    // dynamic fallback.
    private var autobrewCollectionType: UTType {
        UTType(filenameExtension: "autobrewcollection") ?? .json
    }
}

/// Right pane: tokens in the selected collection + bulk actions.
private struct CollectionDetailView: View {
    let collection: CaskCollection
    @Binding var bulkInProgress: Bool
    @Binding var bulkProgress: CollectionsView.BulkProgress?
    @Binding var operationError: String?

    @State private var store = CollectionsStore.shared
    @State private var newTokenInput = ""

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading) {
                    Text(collection.name).font(.title2.bold())
                    Text(String(localized: "\(collection.tokens.count) casks"))
                        .font(.callout)
                        .foregroundStyle(.secondary)
                }
                Spacer()
                bulkActions
            }
            .padding(.horizontal, 16)
            .padding(.top, 16)

            Divider()

            if let progress = bulkProgress {
                progressBanner(progress)
                    .padding(.horizontal, 16)
            }

            tokenList
            addTokenRow
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    @ViewBuilder
    private var bulkActions: some View {
        HStack(spacing: 6) {
            Button {
                Task { await runInstall() }
            } label: {
                Label(String(localized: "Install All"), systemImage: "arrow.down.circle.fill")
            }
            .disabled(bulkInProgress || collection.tokens.isEmpty)
            .adaptiveProminentButtonStyle()

            Button {
                Task { await runUninstall() }
            } label: {
                Label(String(localized: "Uninstall All"), systemImage: "trash")
            }
            .disabled(bulkInProgress || collection.tokens.isEmpty)
            .adaptiveBorderedButtonStyle()
        }
    }

    private var tokenList: some View {
        List {
            if collection.tokens.isEmpty {
                Text(String(localized: "Add cask tokens below — for example `visual-studio-code`, `firefox`, `rectangle`."))
                    .font(.callout)
                    .foregroundStyle(.secondary)
            } else {
                ForEach(collection.tokens, id: \.self) { token in
                    HStack {
                        Image(systemName: "shippingbox")
                            .foregroundStyle(.secondary)
                        Text(token)
                            .font(.body.monospaced())
                        Spacer()
                        Button {
                            store.removeToken(token, from: collection.id)
                        } label: {
                            Image(systemName: "minus.circle")
                        }
                        .buttonStyle(.borderless)
                        .disabled(bulkInProgress)
                    }
                }
            }
        }
        .listStyle(.inset)
        .frame(maxHeight: .infinity)
    }

    private var addTokenRow: some View {
        HStack {
            TextField(String(localized: "Cask token to add"),
                      text: $newTokenInput)
                .textFieldStyle(.roundedBorder)
                .font(.body.monospaced())
                .disableAutocorrection(true)
                .onSubmit(addToken)
            Button(String(localized: "Add")) { addToken() }
                .disabled(newTokenInput.trimmingCharacters(in: .whitespaces).isEmpty || bulkInProgress)
        }
        .padding(16)
    }

    private func addToken() {
        let token = newTokenInput.trimmingCharacters(in: .whitespaces)
        guard !token.isEmpty else { return }
        // Same token grammar the URL handler uses — defence in depth
        // against weird inputs even though the user typed it.
        guard token.range(of: #"^[a-zA-Z0-9][a-zA-Z0-9._-]*$"#, options: .regularExpression) != nil else {
            operationError = String(localized: "“\(token)” is not a valid Homebrew cask token.")
            return
        }
        store.addToken(token, to: collection.id)
        newTokenInput = ""
    }

    private func progressBanner(_ progress: CollectionsView.BulkProgress) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                ProgressView(value: Double(progress.done), total: Double(progress.total))
                Text("\(progress.done) / \(progress.total)")
                    .font(.caption.monospacedDigit())
            }
            if let token = progress.currentToken {
                Text(String(localized: "Working on `\(token)`…"))
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            if !progress.failures.isEmpty {
                Text(String(localized: "Failed: \(progress.failures.joined(separator: ", "))"))
                    .font(.caption)
                    .foregroundStyle(.red)
            }
        }
        .padding(8)
        .adaptiveGlassCard(cornerRadius: 8)
    }

    // MARK: - Bulk runners

    private func runInstall() async {
        await runBulk(
            label: "install",
            action: { try await BrewInstaller().install(token: $0) }
        )
    }

    private func runUninstall() async {
        await runBulk(
            label: "uninstall",
            action: { try await BrewInstaller().uninstall(token: $0) }
        )
    }

    private func runBulk(label: String,
                         action: @escaping (String) async throws -> Void) async {
        bulkInProgress = true
        bulkProgress = .init(total: collection.tokens.count, done: 0, currentToken: nil, failures: [])
        defer { bulkInProgress = false }

        for token in collection.tokens {
            bulkProgress?.currentToken = token
            do {
                try await action(token)
            } catch {
                bulkProgress?.failures.append(token)
            }
            bulkProgress?.done += 1
        }

        bulkProgress?.currentToken = nil
        if let failures = bulkProgress?.failures, !failures.isEmpty {
            operationError = String(localized: "Bulk \(label) finished with \(failures.count) failure(s): \(failures.joined(separator: ", "))")
        }
        await InstalledAppsStore.shared.refresh()
    }
}
