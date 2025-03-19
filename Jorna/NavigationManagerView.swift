import SwiftData
import SwiftUI

struct NavigationManagerView: View {
    var body: some View {
        NavigationSplitView {
            SidebarView()
        } detail: {
            ContentUnavailableView(
                "Select a request", systemImage: "arrowshape.left.fill")
        }
    }
}
