import Foundation
import CoreData

extension MoodEntry {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<MoodEntry> {
        return NSFetchRequest<MoodEntry>(entityName: "MoodEntry")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var mood: String?
    @NSManaged public var date: Date?
    @NSManaged public var activity: String?
}
