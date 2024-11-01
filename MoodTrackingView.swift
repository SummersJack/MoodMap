import SwiftUI

// Enum representing different moods
enum Mood: String, CaseIterable {
    case happy
    case sad
    case neutral
    case anxious
    case excited

    var description: String {
        return self.rawValue.capitalized
    }
}

// ViewModel for Mood Tracking
class MoodTracker: ObservableObject {
    @Published var entries: [MoodEntry] = []

    func addMood(mood: String, activity: String) {
        let newEntry = MoodEntry(mood: mood, activity: activity, date: Date())
        entries.append(newEntry)
    }
}

// Model representing a mood entry
struct MoodEntry: Identifiable {
    let id = UUID()
    var mood: String?
    var activity: String?
    var date: Date
}

// Custom date formatter
extension DateFormatter {
    static var shortDate: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        return formatter
    }
}

struct MoodTrackingView: View {
    @ObservedObject var moodTracker: MoodTracker
    @Binding var selectedMood: String
    @Binding var activity: String

    @State private var showAlert = false
    @State private var alertMessage = ""

    var body: some View {
        VStack {
            Picker("Select your mood", selection: $selectedMood) {
                ForEach(Mood.allCases, id: \.self) { mood in
                    Text(mood.description).tag(mood.rawValue)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()

            TextField("Activity", text: $activity)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                .autocapitalization(.words)
                .disableAutocorrection(true)

            Button("Log Mood") {
                logMood()
            }
            .padding()
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }

            List(moodTracker.entries) { entry in
                VStack(alignment: .leading) {
                    Text("\(entry.mood ?? "Neutral") - \(entry.date, formatter: DateFormatter.shortDate)")
                    Text("Activity: \(entry.activity ?? "")")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                .padding(.vertical, 4)
            }
        }
        .padding()
    }

    private func logMood() {
        // Validate input before logging
        guard !selectedMood.isEmpty, !activity.isEmpty else {
            alertMessage = "Please select a mood and enter an activity."
            showAlert = true
            return
        }
        moodTracker.addMood(mood: selectedMood, activity: activity)
        activity = "" // Clear the activity input after logging
    }
}
