import SwiftUI

struct RequestView: View {
    @State private var viewModel = ViewModel()

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Picker(String(), selection: $viewModel.method) {
                    ForEach(HTTPMethod.allCases) { method in
                        Text(method.rawValue).tag(method)
                    }
                }
                .frame(width: 90)
                .labelsHidden()
                .pickerStyle(.menu)

                TextField("Request URI", text: $viewModel.endpoint)
                    .autocorrectionDisabled(true)
                    .frame(minWidth: 300)

                Button("Send", systemImage: "paperplane.fill") {
                    Task {
                        do {
                            try await viewModel.makeRequest()
                        }
                    }
                }
                .keyboardShortcut(.return, modifiers: .command)
            }

            VStack {
                HStack {
                    Text("Headers").fontWeight(.bold)
                    Button("Add") { self.viewModel.headers.append(Header()) }
                    Spacer()
                }

                VStack {
                    ForEach(self.$viewModel.headers) { $header in
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
                            viewModel.prettifyRequestBody()
                        }
                        .buttonStyle(.link)
                    }

                    TextEditor(text: $viewModel.requestBody)
                        .cornerRadius(8)
                }
                .padding(.horizontal, 5)
                VStack {
                    HStack {
                        Text("Response")
                        Text(viewModel.statusCode).foregroundStyle(
                            self.viewModel.responseColour())
                        Spacer()
                        Button("Prettify") {
                            viewModel.prettifyResponseBody()
                        }
                        .buttonStyle(.link)
                    }
                    TextEditor(text: $viewModel.responseBody)
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
}

#Preview {
    RequestView()
}
