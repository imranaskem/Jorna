import SwiftData
import SwiftUI

struct RequestView: View {
    @Environment(\.modelContext) var modelContext

    @State private var selectedTab = 1

    @Bindable var apiRequest: APIRequest

    var body: some View {
        VStack {
            Picker(String(), selection: $selectedTab) {
                Text("Body").tag(1)
                Text("Headers").tag(2)
            }.pickerStyle(.segmented)

            if selectedTab == 1 {
                VStack {
                    HStack {
                        Spacer()
                        Button("Clear") {
                            apiRequest.requestBody = ""
                        }.buttonStyle(.link)
                        Button("Prettify") {
                            apiRequest.prettifyRequestBody()
                        }
                        .buttonStyle(.link)
                    }

                    TextEditor(text: $apiRequest.requestBody)
                        .cornerRadius(8)
                }
                .padding(.horizontal, 5)

            } else if selectedTab == 2 {
                HStack {
                    Button("Add") { apiRequest.requestHeaders.append(Header()) }
                    Spacer()
                }

                VStack {
                    ForEach(apiRequest.requestHeaders) { header in
                        HeaderView(header: header, showOptions: true)
                    }
                }
            }
            Spacer()
        }
    }
}
