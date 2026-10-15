import SwiftUI

/// Standalone window that shows the legal documents. Deep-link entry points
/// (Settings buttons, About sheet, future onboarding) set
/// `LegalNavigation.shared.requestedDocument` and post `.openLegalWindow`;
/// this view picks up the change through the observed singleton.
@MainActor
struct LegalView: View {
    @State private var navigation = LegalNavigation.shared
    // Parsed markdown is cached per document so switching tabs doesn't
    // re-parse from disk. The cache lives as long as the window does.
    @State private var blocksCache: [LegalDocument: [MarkdownBlock]] = [:]

    var body: some View {
        // Sidebar list instead of a segmented picker: with eleven
        // documents a segmented control no longer fits the window, while a
        // list scales with any number of documents and keeps every title
        // readable in all languages.
        NavigationSplitView {
            List(LegalDocument.allCases, selection: Binding<LegalDocument?>(
                get: { navigation.requestedDocument },
                set: { if let doc = $0 { navigation.requestedDocument = doc } }
            )) { doc in
                Label(LocalizedStringKey(doc.titleKey), systemImage: doc.systemImage)
                    .tag(doc)
            }
            .listStyle(.sidebar)
            .accessibilityLabel(Text("Legal document"))
            .navigationSplitViewColumnWidth(min: 200, ideal: 230, max: 300)
        } detail: {
            // `.id(...)` on the ScrollView forces SwiftUI to rebuild the
            // scrollable container when the selected document changes, which
            // resets the scroll offset to the top — otherwise switching from
            // a long Privacy Policy to a short EULA would leave the user
            // scrolled into empty space at the bottom.
            ScrollView {
                MarkdownView(blocks: blocksCache[navigation.requestedDocument] ?? [])
                    .padding(24)
                    .textSelection(.enabled)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .id(navigation.requestedDocument)
        }
        .frame(minWidth: 640, idealWidth: 760, minHeight: 480, idealHeight: 640)
        .navigationTitle("Legal")
        .task(id: navigation.requestedDocument) {
            let doc = navigation.requestedDocument
            guard blocksCache[doc] == nil else { return }
            blocksCache[doc] = MarkdownParser.parse(doc.load())
        }
    }
}
