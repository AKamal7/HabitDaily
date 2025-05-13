//
//  Habit+CoreDataProperties.swift
//  HabitDaily
//
//  Created by ahmedkamal on 11/05/2025.
//
//

import Foundation
import CoreData


extension Habit {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Habit> {
        return NSFetchRequest<Habit>(entityName: "Habit")
    }

    @NSManaged public var name: String?
    @NSManaged public var emoji: String?
    @NSManaged public var frequency: String?
    @NSManaged public var reminderTime: Date?
    @NSManaged public var createdAt: Date?
    @NSManaged public var isCompleted: Bool
    @NSManaged public var streakCount: Int32
    @NSManaged public var lastCompleted: Date?

}

extension Habit : Identifiable {

}
