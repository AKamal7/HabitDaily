//
//  Habit+CoreDataProperties.swift
//  HabitDaily
//
//  Created by ahmedkamal on 19/05/2025.
//
//

import Foundation
import CoreData


extension Habit {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Habit> {
        return NSFetchRequest<Habit>(entityName: "Habit")
    }

    @NSManaged public var createdAt: Date?
    @NSManaged public var emoji: String?
    @NSManaged public var frequency: String?
    @NSManaged public var isCompleted: Bool
    @NSManaged public var lastCompleted: Date?
    @NSManaged public var name: String?
    @NSManaged public var reminderTime: Date?
    @NSManaged public var streakCount: Int32
    @NSManaged public var habitCompletion: NSSet?

}

// MARK: Generated accessors for habitCompletion
extension Habit {

    @objc(addHabitCompletionObject:)
    @NSManaged public func addToHabitCompletion(_ value: HabitCompletion)

    @objc(removeHabitCompletionObject:)
    @NSManaged public func removeFromHabitCompletion(_ value: HabitCompletion)

    @objc(addHabitCompletion:)
    @NSManaged public func addToHabitCompletion(_ values: NSSet)

    @objc(removeHabitCompletion:)
    @NSManaged public func removeFromHabitCompletion(_ values: NSSet)
    
    func isCompletedToday() -> Bool {
        guard let completions = habitCompletion as? Set<HabitCompletion> else {
            return false
        }
        
        let todayStart = Calendar.current.startOfDay(for: Date())
        let tomorrowStart = Calendar.current.date(byAdding: .day, value: 1, to: todayStart)!

        return completions.contains(where: { completion in
            if let date = completion.date {
                return date >= todayStart && date < tomorrowStart
            }
            return false
        })
    }
}

extension Habit : Identifiable {

}
