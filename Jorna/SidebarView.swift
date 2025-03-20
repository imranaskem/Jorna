import Foundation
import SwiftData
import SwiftUI

struct SidebarView: View {
    @Environment(\.modelContext) var modelContext
    @Query(sort: \RequestCollection.createdAt) var collections:
        [RequestCollection]

    var body: some View {
        List {
            ForEach(collections) { collection in
                Text(collection.name).font(.title3).contextMenu {
                    Button("Delete collection") {
                        deleteCollection(collection)
                    }
                }
                
                ForEach(collection.requests) { request in
                    NavigationLink(
                        request.name,
                        destination: DetailView(apiRequest: request)
                    ).contextMenu {
                        Button("Delete request") {
                            deleteRequest(
                                from: collection, request: request)
                        }
                    }
                }
                Button("Add") {
                    addRequest(to: collection)
                }
            }
        }.toolbar {
            ToolbarItem {
                Menu {
                    Button("Add collection") {
                        addCollection()
                    }
                } label: {
                    Label("Add", systemImage: "plus")
                }
            }
        }.navigationSplitViewColumnWidth(min: 200, ideal: 250)
    }

    func addCollection() {
        modelContext.insert(RequestCollection(name: "New collection"))
    }

    func addRequest(to collection: RequestCollection) {
        collection.requests.append(APIRequest(collection: collection))
    }

    func deleteRequest(from collection: RequestCollection, request: APIRequest)
    {
        collection.requests.remove(
            at: collection.requests.firstIndex(of: request)!)
        modelContext.delete(request)
    }

    func deleteCollection(_ collection: RequestCollection) {
        if !collection.requests.isEmpty {
            let tempRequests = collection.requests
            for request in tempRequests {
                modelContext.delete(request)
            }
            collection.requests.removeAll()
        }
        
        modelContext.delete(collection)
        try? modelContext.save()
    }
}
