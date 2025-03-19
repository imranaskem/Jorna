import Foundation
import SwiftUI
import SwiftData

struct SidebarView: View {
    @Environment(\.modelContext) var modelContext
    @Query(sort: \RequestCollection.createdAt) var collections:
        [RequestCollection]
    
    var body: some View {
        List {
            ForEach(collections) { collection in
                SidebarCollectionView(collection: collection)
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
}
