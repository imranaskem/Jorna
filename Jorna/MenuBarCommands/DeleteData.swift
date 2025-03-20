import SwiftUI

struct DeleteData: View {
    @Environment(\.modelContext) var modelContext
    
    var body: some View {
            Button("Delete all data") {
                do {
                    try modelContext.delete(model: APIRequest.self)
                    try modelContext.delete(model: RequestCollection.self)
                    try modelContext.delete(model: RequestHeader.self)
                    try modelContext.delete(model: ResponseHeader.self)
                } catch {
                    print(error.localizedDescription)
                }
                
            }
        }
}
    
    
