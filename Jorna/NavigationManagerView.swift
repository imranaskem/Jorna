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
            }
        } detail: {
            ContentUnavailableView(
                "Select a request", systemImage: "arrowshape.left.fill")
        }.toolbar {
            ToolbarItem(placement: .automatic) {
                Button("Add Request") {
                    addRequest()
                }
            }
        }
    }

    func addRequest() {
        modelContext.insert(APIRequest())
    }
    func deleteRequest(_ request: APIRequest) {
        modelContext.delete(request)
        try? modelContext.save()
    }
}
