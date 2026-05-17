import SwiftUI

struct BrowseSidebarView: View {
    @Binding var selection: BrowseCategory

    private let quick: [BrowseCategory] = [.all, .popular, .recent]
    private let content: [BrowseCategory] = [.browsers, .developerTools, .communication, .productivity, .media, .graphics, .utilities, .security, .games, .storage]

    var body: some View {
        List(selection: $selection) {
            Section(String(localized: "Quick")) {
                ForEach(quick) { cat in
                    Label(cat.displayName, systemImage: cat.systemImage).tag(cat)
                }
            }
            Section(String(localized: "Categories")) {
                ForEach(content) { cat in
                    Label(cat.displayName, systemImage: cat.systemImage).tag(cat)
                }
            }
        }
        .listStyle(.sidebar)
    }
}
