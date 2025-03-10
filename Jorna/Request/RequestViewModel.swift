import Foundation
import SwiftJSONFormatter
import SwiftUI

enum HTTPMethod: String, CaseIterable, Identifiable {
    case GET, POST
    var id: Self { self }
}

extension RequestView {
    @Observable
    class ViewModel {
        var requestBody = "{\"title\":\"foo\"}"
        var responseBody = String()
        var statusCode = String()
        var method: HTTPMethod = .GET
        var headers: [Header] = [Header()]
        var headersExpanded: Bool = true
        var endpoint = "https://jsonplaceholder.typicode.com/posts"

        func makeRequest() async throws {
            guard let url = URL(string: self.endpoint)
            else {
                fatalError("Invalid endpoint string")
            }

            var request = URLRequest(url: url)
            request.httpMethod = self.method.rawValue

            for header in self.headers.filter({ $0.enabled }) {
                if header.key != "" {
                    request.setValue(
                        header.value,
                        forHTTPHeaderField: header.key)
                }
            }

            if self.method == .POST {
                prettifyRequestBody()
                guard
                    let jsonObj = try? JSONSerialization.jsonObject(
                        with: self.requestBody.data(using: .utf8)!)
                else {
                    self.responseBody = "Invalid JSON object"
                    return
                }

                guard
                    let jsonData = try? JSONSerialization.data(
                        withJSONObject: jsonObj)
                else {
                    self.responseBody = "Invalid JSON data"
                    return
                }
                request.httpBody = jsonData
            }

            let (data, response) = try await URLSession.shared.data(
                for: request)

            let resp = response as! HTTPURLResponse

            self.statusCode = resp.statusCode.description
            self.responseBody = String(decoding: data, as: UTF8.self)
        }

        func prettifyRequestBody() {
            self.requestBody = self.requestBody.replacingOccurrences(
                of: "“", with: "\"")
            self.requestBody = self.requestBody.replacingOccurrences(
                of: "”", with: "\"")
            self.requestBody = SwiftJSONFormatter.beautify(self.requestBody)
        }

        func prettifyResponseBody() {
            self.responseBody = SwiftJSONFormatter.beautify(self.responseBody)
        }

        func responseColour() -> Color {
            if self.statusCode.starts(with: "2") {
                return .green
            } else {
                return .red
            }
        }
    }
}
