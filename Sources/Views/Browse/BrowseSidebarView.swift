import SwiftUI

struct BrowseSidebarView: View {
    @Binding var selection: BrowseCategory

    var body: some View {
        List(selection: $selection) {
            Section(String(localized: "Categories")) {
                ForEach(BrowseCategory.allCases) { cat in
                    Label(cat.displayName, systemImage: cat.systemImage).tag(cat)
                }
            }
        }
        .listStyle(.sidebar)
    }
}
