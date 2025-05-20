//
//  HabitCompletion+CoreDataProperties.swift
//  HabitDaily
//
//  Created by ahmedkamal on 19/05/2025.
//
//

import Foundation
import CoreData


extension HabitCompletion {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<HabitCompletion> {
        return NSFetchRequest<HabitCompletion>(entityName: "HabitCompletion")
    }

    @NSManaged public var date: Date?
    @NSManaged public var habit: Habit?

}

extension HabitCompletion : Identifiable {

}
