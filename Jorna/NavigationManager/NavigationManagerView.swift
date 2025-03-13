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
                        destination: RequestView(apiRequest: request))
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
}

#Preview {
    NavigationManagerView()
}
