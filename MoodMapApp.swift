import SwiftUI
import Firebase

@main
struct MoodMapApp: App {
    init() {
        FirebaseApp.configure() // Initialize Firebase
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
