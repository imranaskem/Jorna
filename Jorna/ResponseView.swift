import SwiftData
import SwiftUI

struct ResponseView: View {
    @State private var selectedTab = 1
    @Bindable var apiRequest: APIRequest

    var body: some View {
        VStack {
            Picker(String(), selection: $selectedTab) {
                Text("Body").tag(1)
                Text("Headers").tag(2)
            }.pickerStyle(.segmented)

            if selectedTab == 1 {
                HStack {
                    Spacer()
                    Button("Clear") {
                        apiRequest.responseBody = ""
                    }.buttonStyle(.link)
                    Button("Prettify") {
                        apiRequest.prettifyResponseBody()
                    }
                    .buttonStyle(.link)
                }
                TextEditor(text: $apiRequest.responseBody)
                    .cornerRadius(8)
            } else if selectedTab == 2 {
                VStack {
                    ScrollView {
                        ForEach(apiRequest.responseHeaders.sorted(by: <)) {
                            header in
                            HeaderView(header: header, showOptions: false)
                        }
                    }

                }
            }
            Spacer()
        }
        .padding(.horizontal, 5)
    }
}
