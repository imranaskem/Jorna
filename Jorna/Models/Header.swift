import Foundation

struct Header: Identifiable {
    var id: UUID = UUID()
    var enabled: Bool = true
    var key: String = ""
    var value: String = ""
}
