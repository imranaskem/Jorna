import SwiftData
import SwiftUI

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
            if collection.editMode {
                TextField("Collection name", text: $collection.name)
                    .onExitCommand { collection.editMode = false }
            } else {
                Text(collection.name).font(.title3)
                    .contextMenu {
                        Button("Delete collection") {
                            deleteCollection(collection)
                        }
                        Button("Edit collection") {
                            collection.editMode = true
                        }
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
