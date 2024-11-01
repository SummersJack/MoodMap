import Foundation
import CoreData
import SwiftUI

class MoodTracker: ObservableObject {
    @Published var entries: [MoodEntry] = []
    private let context: NSManagedObjectContext

    init(context: NSManagedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext) {
        self.context = context
        fetchEntries()
    }

    private let fetchRequest: NSFetchRequest<MoodEntry> = {
        let request = MoodEntry.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \MoodEntry.date, ascending: false)]
        return request
    }()
    
    func fetchEntries() {
        do {
            let fetchedEntries = try context.fetch(fetchRequest)
            DispatchQueue.main.async {
                self.entries = fetchedEntries
            }
        } catch {
            print("Failed to fetch entries: \(error.localizedDescription)")
        }
    }

    func addMood(mood: String, activity: String) {
        let newEntry = MoodEntry(context: context)
        newEntry.id = UUID()
        newEntry.mood = mood
        newEntry.date = Date()
        newEntry.activity = activity

        saveContext()
        fetchEntries()
    }

    func updateMood(entry: MoodEntry, newMood: String, newActivity: String) {
        entry.mood = newMood
        entry.activity = newActivity
        entry.date = Date()
        
        saveContext()
        fetchEntries()
    }
    
    func deleteMood(entry: MoodEntry) {
        context.delete(entry)
        saveContext()
        fetchEntries()
    }

    private func saveContext() {
        do {
            try context.save()
        } catch {
            print("Failed to save context: \(error.localizedDescription)")
        }
    }
}
