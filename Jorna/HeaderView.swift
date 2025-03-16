import SwiftUI

struct HeaderView: View {
    @Environment(\.modelContext) var modelContext

    @Bindable var header: Header

    var showOptions: Bool

    var body: some View {
        HStack {
            if showOptions {
                Toggle("Enable", isOn: $header.enabled)
            }

            TextField("Key", text: $header.key)

            TextField("Value", text: $header.value)

            if showOptions {
                Button {
                    modelContext.delete(header)
                    try? modelContext.save()
                } label: {
                    Image(systemName: "trash")
                }
            }

        }
    }
}
