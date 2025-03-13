import Foundation
import SwiftData
import SwiftJSONFormatter

enum HTTPMethod: String, CaseIterable, Identifiable, Codable {
    case GET, POST
    var id: Self { self }
}

@Model
final class APIRequest {
    var requestBody: String
    var responseBody: String
    var statusCode: String
    var method: HTTPMethod
    var name: String
    var endpoint: String
    
    @Relationship(deleteRule: .cascade)
    var headers: [Header]

    init(
        requestBody: String = "", responseBody: String = "",
        statusCode: String = "", method: HTTPMethod = .GET,
        name: String = "New Request", headers: [Header] = [],
        endpoint: String = ""
    ) {
        self.requestBody = requestBody
        self.responseBody = responseBody
        self.statusCode = statusCode
        self.method = method
        self.name = name
        self.headers = headers
        self.endpoint = endpoint
    }
    
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

        if !self.requestBody.isEmpty {
            prettifyRequestBody()
            guard
                let jsonObj = try? JSONSerialization.jsonObject(
                    with: self.requestBody.data(using: .utf8)!)
            else {
                self.responseBody = "Invalid request JSON"
                return
            }

            guard
                let jsonData = try? JSONSerialization.data(
                    withJSONObject: jsonObj)
            else {
                self.responseBody = "Invalid request JSON"
                return
            }
            request.httpBody = jsonData
        }

        let (data, response) = try await URLSession.shared.data(
            for: request)

        let resp = response as! HTTPURLResponse

        self.statusCode = resp.statusCode.description
        self.responseBody = String(decoding: data, as: UTF8.self)
        prettifyResponseBody()
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
}
