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
    var createdAt: Date?
    
    @Relationship(deleteRule: .cascade)
    var headers: [Header]

    init(
        requestBody: String = "", responseBody: String = "",
        statusCode: String = "", method: HTTPMethod = .GET,
        name: String = "New Request", headers: [Header] = [],
        endpoint: String = "", createdAt: Date = Date.now
    ) {
        self.requestBody = requestBody
        self.responseBody = responseBody
        self.statusCode = statusCode
        self.method = method
        self.name = name
        self.headers = headers
        self.endpoint = endpoint
        self.createdAt = createdAt
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
