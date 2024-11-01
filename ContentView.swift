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
                        .padding()
                } else {
                    MoodTrackingView(moodTracker: moodTracker, selectedMood: $selectedMood, activity: $activity)
                        .padding()
                        .onAppear {
                            moodTracker.fetchEntries()
                        }
                    MoodSummaryView(moodTracker: moodTracker)
                        .padding(.top)
                }
            }
            .navigationTitle("MoodMap")
            .navigationBarItems(trailing: logoutButton)
            .alert(isPresented: $authViewModel.showAlert) {
                Alert(title: Text("Error"), message: Text(authViewModel.errorMessage), dismissButton: .default(Text("OK")))
            }
        }
    }
    
    private var logoutButton: some View {
        Button(action: {
            authViewModel.logout()
        }) {
            Text("Logout")
        }
    }
}
