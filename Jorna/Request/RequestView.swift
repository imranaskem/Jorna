import SwiftData
import SwiftUI

struct RequestView: View {
    @Environment(\.modelContext) var modelContext
    @Bindable var apiRequest: APIRequest

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Picker(String(), selection: $apiRequest.method) {
                    ForEach(HTTPMethod.allCases) { method in
                        Text(method.rawValue).tag(method)
                    }
                }
                .frame(width: 90)
                .labelsHidden()
                .pickerStyle(.menu)

                TextField("Request URI", text: $apiRequest.endpoint)
                    .autocorrectionDisabled(true)
                    .frame(minWidth: 300)

                Button("Send", systemImage: "paperplane.fill") {
                    Task {
                        do {
                            try await apiRequest.makeRequest()
                        }
                    }
                }
                .keyboardShortcut(.return, modifiers: .command)
            }

            VStack {
                HStack {
                    Text("Headers").fontWeight(.bold)
                    Button("Add") { addHeader() }
                    Spacer()
                }

                VStack {
                    ForEach($apiRequest.headers) { $header in
                        HStack {
                            Toggle("Enable", isOn: $header.enabled)
                            TextField("Key", text: $header.key)
                            TextField("Value", text: $header.value)
                        }
                    }
                }
            }

            HSplitView {
                VStack {
                    HStack {
                        Text("Request")
                        Spacer()
                        Button("Prettify") {
                            apiRequest.prettifyRequestBody()
                        }
                        .buttonStyle(.link)
                    }

                    TextEditor(text: $apiRequest.requestBody)
                        .cornerRadius(8)
                }
                .padding(.horizontal, 5)
                VStack {
                    HStack {
                        Text("Response")
                        Text(apiRequest.statusCode).foregroundStyle(
                            responseColour(statusCode: apiRequest.statusCode))
                        Spacer()
                        Button("Prettify") {
                            apiRequest.prettifyResponseBody()
                        }
                        .buttonStyle(.link)
                    }
                    TextEditor(text: $apiRequest.responseBody)
                        .cornerRadius(8)
                }
                .padding(.horizontal, 5)
            }
            .font(.system(size: 12, design: .monospaced))
            .frame(minHeight: 300)
            .cornerRadius(8)
        }
        .padding()
    }
    
    func addHeader() {
        apiRequest.headers.append(Header())
    }

    func responseColour(statusCode: String) -> Color {
        if statusCode.starts(with: "2") {
            return .green
        } else {
            return .red
        }
    }
}
