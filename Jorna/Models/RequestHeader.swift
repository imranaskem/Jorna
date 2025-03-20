import Foundation
import SwiftData

@Model
final class RequestHeader {
    var enabled: Bool
    var key: String
    var value: String
    
    var apiRequest: APIRequest?

    init(enabled: Bool, key: String, value: String, apiRequest: APIRequest? = nil) {
        self.enabled = enabled
        self.key = key
        self.value = value
        self.apiRequest = apiRequest
    }
}
