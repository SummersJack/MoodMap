import SwiftUI

struct ContentView: View {
    @ObservedObject var moodTracker = MoodTracker()
    @ObservedObject var authViewModel = AuthViewModel()
    
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var selectedMood: String = "neutral"
    @State private var activity: String = ""

    var body: some View {
        NavigationView {
            VStack {
                if authViewModel.user == nil {
                    AuthenticationView(authViewModel: authViewModel, email: $email, password: $password)
                } else {
                    MoodTrackingView(moodTracker: moodTracker, selectedMood: $selectedMood, activity: $activity)
                }
            }
            .navigationTitle("MoodMap")
            .onAppear {
                moodTracker.fetchEntries()
            }
        }
    }
}
