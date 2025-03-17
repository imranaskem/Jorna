import SwiftData
import SwiftUI

struct NavigationManagerView: View {
    @Environment(\.modelContext) var modelContext
    @Query(sort: \RequestCollection.createdAt) var collections: [RequestCollection]

    var body: some View {
        NavigationSplitView {
            List {
                ForEach(collections) { collection in
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
                    } header: {
                        Text(collection.name).font(.title3).contextMenu {
                            Button("Delete collection") {
                                deleteCollection(collection)
                            }
                        }
                        Button(action: addRequest) {
                            Label("Add", systemImage: "plus")
                        }
                    }
                }
            }.toolbar {
                ToolbarItem {
                    Menu {
                        Button(action: addCollection) {
                            Label("Add collection", systemImage: "plus")
                        }
                        Button(action: addRequest) {
                            Label("Add Item", systemImage: "plus")
                        }
                    } label: {
                        Label("Add", systemImage: "plus")
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
    func addCollection() {
        modelContext.insert(RequestCollection(name: "New collection"))
    }
    func deleteCollection(_ collection: RequestCollection) {
        modelContext.delete(collection)
        try? modelContext.save()
    }
}
