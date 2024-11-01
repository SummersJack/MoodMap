import Foundation
import CoreData
import SwiftUI

class MoodTracker: ObservableObject {
    @Published var entries: [MoodEntry] = []
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    func fetchEntries() {
        let request: NSFetchRequest<MoodEntry> = MoodEntry.fetchRequest()
        do {
            entries = try context.fetch(request)
        } catch {
            print("Error fetching data: \(error)")
        }
    }

    func addMood(mood: String, activity: String) {
        let newEntry = MoodEntry(context: context)
        newEntry.id = UUID()
        newEntry.mood = mood
        newEntry.date = Date()
        newEntry.activity = activity
        
        do {
            try context.save()
            fetchEntries()
        } catch {
            print("Error saving data: \(error)")
        }
    }
}
