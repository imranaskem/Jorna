import SwiftData
import SwiftUI

struct NavigationManagerView: View {
    @Environment(\.modelContext) var modelContext
    @Query(sort: \APIRequest.createdAt) var requests: [APIRequest]

    var body: some View {
        NavigationSplitView {
            List {
                ForEach(requests) { request in
                    NavigationLink(
                        request.name,
                        destination: DetailView(apiRequest: request)
                    ).contextMenu {
                        Button("Delete request") {
                            deleteRequest(request)
                        }
                    }
                }
            }.toolbar {
                ToolbarItem {
                    Button(action: addRequest) {
                        Label("Add Item", systemImage: "plus")
                    }
                }
            }.navigationSplitViewColumnWidth(min: 200, ideal: 250)
        } detail: {
            ContentUnavailableView(
                "Select a request", systemImage: "arrowshape.left.fill")
        }
    }

    func addRequest() {
        modelContext.insert(APIRequest())
    }
    func deleteRequest(_ request: APIRequest) {
        modelContext.delete(request)
    }
}
