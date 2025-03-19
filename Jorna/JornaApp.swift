import SwiftData
import SwiftUI
import SwiftData

@main
struct JornaApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            APIRequest.self,
            RequestHeader.self,
            ResponseHeader.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
    
    var body: some Scene {
        WindowGroup {
            NavigationManagerView()
        }.modelContainer(sharedModelContainer)
    }
}
