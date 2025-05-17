//
//  CoreDataManager.swift
//  HabitDaily
//
//  Created by ahmedkamal on 11/05/2025.
//

import Foundation
import CoreData

class CoreDataManager {
    static let shared = CoreDataManager()
    let persistentContainer: NSPersistentContainer

    private init() {
        persistentContainer = NSPersistentContainer(name: "HabitDataModel")
        persistentContainer.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Unresolved error \(error)")
            }
        }
    }

    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }

    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("Error saving context: \(error)")
            }
        }
    }

    func fetchHabits() -> [Habit] {
        let request: NSFetchRequest<Habit> = Habit.fetchRequest()
        do {
            return try context.fetch(request)
        } catch {
            print("Error fetching habits: \(error)")
            return []
        }
    }
}
