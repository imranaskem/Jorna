//import SwiftData
//import SwiftUI
//
//struct SidebarCollectionView: View {
//    @Environment(\.modelContext) var modelContext
//    @State var collection: RequestCollection
//
//    var body: some View {
//        Section {
//            ForEach(collection.requests) { request in
//                NavigationLink(
//                    request.name,
//                    destination: DetailView(apiRequest: request)
//                ).contextMenu {
//                    Button("Delete request") {
//                        deleteRequest(request: request)
//                    }
//                }
//            }
//            Button("Add") {
//                addRequest()
//            }
//        } header: {
//            if collection.editMode {
//                TextField("Collection name", text: $collection.name)
//                    .onExitCommand { collection.editMode = false }
//            } else {
//                Text(collection.name).font(.title3)
//                    .contextMenu {
//                        Button("Delete collection") {
//                            deleteCollection(collection)
//                        }
//                        Button("Edit collection") {
//                            collection.editMode = true
//                        }
//                    }
//            }
//
//        }
//    }
//    func addRequest() {
//        collection.requests.append(APIRequest(collection: collection))
//    }
//    func deleteRequest(request: APIRequest) {
//        collection.requests.remove(
//            at: collection.requests.firstIndex(of: request)!)
//        modelContext.delete(request)
//    }
//    func deleteCollection(_ collection: RequestCollection) {
//        modelContext.delete(collection)
//    }
//}
