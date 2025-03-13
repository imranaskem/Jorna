import SwiftData
import SwiftUI

struct NavigationManagerView: View {
    @Environment(\.modelContext) var modelContext
    @Query var requests: [APIRequest]

    var body: some View {
        NavigationSplitView {
            List {
                ForEach(requests) { request in
                    NavigationLink(
                        request.name,
                        destination: RequestView(apiRequest: request)
                    ).contextMenu {
                        Button("Delete request") {
                            deleteRequest(request)
                        }
                    }
                }
                Button("Add Request") {
                    addRequest()
                }

            }
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

#Preview {
    NavigationManagerView()
}
