import SwiftUI
import SwiftData

struct SidebarCollectionView: View {
    @Environment(\.modelContext) var modelContext
    @Bindable var collection: RequestCollection
    
    var body: some View {
        Section {
            ForEach(collection.requests) { request in
                NavigationLink(
                    request.name,
                    destination: DetailView(apiRequest: request)
                ).contextMenu {
                    Button("Delete request") {
                        deleteRequest(request)
                    }
                }
            }
            Button("Add") {
                collection.requests.append(APIRequest(collection: collection))
            }
        } header: {
            Text(collection.name).font(.title3)
                .contextMenu {
                    Button("Delete collection") {
                        deleteCollection(collection)
                    }
            }
            
        }
    }
    func deleteRequest(_ request: APIRequest) {
        modelContext.delete(request)
        try? modelContext.save()
    }
    func deleteCollection(_ collection: RequestCollection) {
        modelContext.delete(collection)
        try? modelContext.save()
    }
}
