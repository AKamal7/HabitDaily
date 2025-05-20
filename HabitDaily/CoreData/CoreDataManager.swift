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

        if let description = persistentContainer.persistentStoreDescriptions.first {
            description.shouldMigrateStoreAutomatically = true
            description.shouldInferMappingModelAutomatically = true
        }

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
    
    func fetchHabitsCompleted() -> [HabitCompletion] {
        let request: NSFetchRequest<HabitCompletion> = HabitCompletion.fetchRequest()
        do {
            return try context.fetch(request)
        } catch {
            print("Error fetching habits: \(error)")
            return []
        }
    }
    
    func deleteHabit(_ habit: Habit) {
        let context = persistentContainer.viewContext
        context.delete(habit)
        do {
            try context.save()
        } catch {
            print("Failed to delete habit: \(error)")
        }
    }
    
    func markHabitAsDone(_ habit: Habit) {
        let context = persistentContainer.viewContext
        
        // Check if already marked done today to avoid duplicates
        let fetchRequest: NSFetchRequest<HabitCompletion> = HabitCompletion.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "habit == %@ AND date >= %@ AND date < %@", habit, startOfToday() as NSDate, startOfTomorrow() as NSDate)
        
        do {
            let results = try context.fetch(fetchRequest)
            if results.isEmpty {
                // No completion today, add one
                let completion = HabitCompletion(context: context)
                completion.habit = habit
                completion.date = Date()
                
                try context.save()
            } else {
                print("Already marked done today")
            }
        } catch {
            print("Failed to mark habit as done: \(error)")
        }
    }

    // Helper functions to get start of today and tomorrow
    func startOfToday() -> Date {
        return Calendar.current.startOfDay(for: Date())
    }

    func startOfTomorrow() -> Date {
        return Calendar.current.date(byAdding: .day, value: 1, to: startOfToday())!
    }
}
