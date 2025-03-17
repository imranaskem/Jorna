import Foundation
import SwiftData

@Model
final class RequestCollection {
    var name: String
    
    @Relationship(deleteRule: .cascade)
    var requests: [APIRequest]
    
    var createdAt: Date
    
    init(name: String, requests: [APIRequest] = [], createdAt: Date = Date.now) {
        self.name = name
        self.requests = requests
        self.createdAt = createdAt
    }
}
