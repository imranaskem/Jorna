import SwiftUI

struct DeleteData: View {
    @Environment(\.modelContext) var modelContext
    
    var body: some View {
            Button("Delete all data") {
                do {
                    try modelContext.delete(model: APIRequest.self)
                    try modelContext.delete(model: RequestCollection.self)
                    try modelContext.delete(model: Header.self)
                    
                } catch {
                    print(error.localizedDescription)
                }
                
            }
        }
}
    
    
