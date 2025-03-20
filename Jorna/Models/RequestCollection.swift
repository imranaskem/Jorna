import Foundation
import SwiftData

@Model
final class RequestCollection {
    var name: String
    var editMode: Bool = false
    
    @Relationship(deleteRule: .cascade)
    var requests: [APIRequest]
    
    var createdAt: Date
    
    init(name: String, requests: [APIRequest] = [], createdAt: Date = Date.now, editMode: Bool = false) {
        self.name = name
        self.requests = requests
        self.createdAt = createdAt
    }
}
