import SwiftUI

@main
struct JornaApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationManagerView()
        }.modelContainer(for: APIRequest.self)
    }
}
