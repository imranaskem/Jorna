import SwiftUI

struct ContentView: View {

    @State private var json: String = ""
    @State private var endpoint: String =
        "https://jsonplaceholder.typicode.com/posts"

    var body: some View {
        VStack {
            HStack {
                Picker(selection: .constant(1), label: Text("")) {
                    Text("GET").tag(1)
                }.frame(width: 100)
                TextField("Request URI", text: $endpoint)
                    .autocorrectionDisabled(true)
                Button("Request") {
                    Task {
                        do {
                            json = try await getEndpoint(endpoint: endpoint)
                        }
                    }
                }.keyboardShortcut(.return)
            }
            TextEditor(text: $json)
        }
        .padding()
    }
}

func getEndpoint(
    endpoint: String
) async throws -> String {
    guard
        let url = URL(
            string: endpoint
        )
    else {
        fatalError()
    }

    let (
        data,
        response
    ) = try await URLSession.shared.data(
        from: url
    )

    guard let response = response as? HTTPURLResponse,
        response.statusCode == 200
    else {
        fatalError(
            "Failed to fetch data"
        )
    }

    return String(decoding: data, as: UTF8.self)
}

