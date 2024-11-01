import SwiftUI

struct MoodTrackingView: View {
    @ObservedObject var moodTracker: MoodTracker
    @Binding var selectedMood: String
    @Binding var activity: String

    var body: some View {
        VStack {
            Picker("Select your mood", selection: $selectedMood) {
                ForEach(Mood.allCases, id: \.self) { mood in
                    Text(mood.rawValue.capitalized).tag(mood.rawValue)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()
            
            TextField("Activity", text: $activity)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            Button("Log Mood") {
                moodTracker.addMood(mood: selectedMood, activity: activity)
            }
            .padding()
            
            List(moodTracker.entries, id: \.id) { entry in
                Text("\(entry.mood ?? "Neutral") - \(entry.date!, formatter: DateFormatter.shortDate) \nActivity: \(entry.activity ?? "")")
            }
        }
    }
}
