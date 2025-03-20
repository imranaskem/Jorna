import Foundation
import SwiftData

@Model
final class ResponseHeader: Comparable {
    var key: String
    var value: String
    
    var apiRequest: APIRequest?
    
    init(key: String, value: String, apiRequest: APIRequest? = nil) {
        self.key = key
        self.value = value
        self.apiRequest = apiRequest
    }
    
    static func < (lhs: ResponseHeader, rhs: ResponseHeader) -> Bool {
        return lhs.key < rhs.key
    }
}
