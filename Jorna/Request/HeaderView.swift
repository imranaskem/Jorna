import SwiftUI

struct HeaderView: View {
    @Environment(\.modelContext) var modelContext
    @Bindable var header: Header
    
    var body: some View {
        HStack {
            Toggle("Enable", isOn: $header.enabled)
            TextField("Key", text: $header.key)
            TextField("Value", text: $header.value)
            Button {
                modelContext.delete(header)
            } label: {
                Image(systemName: "trash")
            }
        }
    }
}
