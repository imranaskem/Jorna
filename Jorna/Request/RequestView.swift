import SwiftData
import SwiftUI
import Foundation

struct RequestView: View {
    @Environment(\.modelContext) var modelContext
    @Bindable var apiRequest: APIRequest
    
    @Query var headers: [Header]

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            TextField("Request Name", text: $apiRequest.name).frame(width: 300)
            
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
                            try await makeRequest()
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
                    ForEach(headers) { header in
                        HeaderView(header: header)
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
        modelContext.insert(Header())
    }

    func responseColour(statusCode: String) -> Color {
        if statusCode.starts(with: "2") {
            return .green
        } else {
            return .red
        }
    }
    
    func makeRequest() async throws {
        apiRequest.prettifyRequestBody()
        guard let url = URL(string: apiRequest.endpoint)
        else {
            fatalError("Invalid endpoint string")
        }

        var request = URLRequest(url: url)
        request.httpMethod = apiRequest.method.rawValue

        for header in headers.filter({ $0.enabled }) {
            if header.key != "" {
                request.setValue(
                    header.value,
                    forHTTPHeaderField: header.key)
            }
        }

        if !apiRequest.requestBody.isEmpty {
            guard
                let jsonObj = try? JSONSerialization.jsonObject(
                    with: apiRequest.requestBody.data(using: .utf8)!)
            else {
                apiRequest.responseBody = "Invalid request JSON"
                return
            }

            guard
                let jsonData = try? JSONSerialization.data(
                    withJSONObject: jsonObj)
            else {
                apiRequest.responseBody = "Invalid request JSON"
                return
            }
            request.httpBody = jsonData
        }

        let (data, response) = try await URLSession.shared.data(
            for: request)

        let resp = response as! HTTPURLResponse

        apiRequest.statusCode = resp.statusCode.description
        apiRequest.responseBody = String(decoding: data, as: UTF8.self)
        apiRequest.prettifyResponseBody()
    }
}
