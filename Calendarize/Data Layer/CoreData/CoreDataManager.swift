//
//  CoreDataManager.swift
//  Calendarize
//
//  Created by David Wang on 2025/5/14.
//

import Foundation
import CoreData

class CoreDataManager {
    static let shared = CoreDataManager()
    let persistentContainer: NSPersistentContainer

    private init() {
        persistentContainer = NSPersistentContainer(name: "Calendarize") // Replace with your data model file name
        persistentContainer.loadPersistentStores { (description, error) in
            if let error = error as NSError? {
                fatalError("Failed to load persistent stores: \(error), \(error.userInfo)")
            }
        }
    }

    var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }

    func saveContext() {
        if viewContext.hasChanges {
            do {
                try viewContext.save()
            } catch {
                let nserror = error as NSError
                print("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

    // MARK: - ScheduledTaskMapping Operations

    func saveMapping(reminderIdentifier: String, calendarEventIdentifier: String) {
        let mapping = ScheduledTaskMapping(context: viewContext)
        mapping.reminderIdentifier = reminderIdentifier
        mapping.calendarEventIdentifier = calendarEventIdentifier
        mapping.creationDate = Date()
        saveContext()
    }

    func fetchMappings(forReminderIdentifier reminderIdentifier: String) throws -> [ScheduledTaskMapping] {
        let fetchRequest = ScheduledTaskMapping.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "reminderIdentifier == %@", reminderIdentifier)
        return try viewContext.fetch(fetchRequest)
    }

    func fetchMapping(forCalendarEventIdentifier calendarEventIdentifier: String) throws -> ScheduledTaskMapping? {
        let fetchRequest = ScheduledTaskMapping.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "calendarEventIdentifier == %@", calendarEventIdentifier)
        let results = try viewContext.fetch(fetchRequest)
        return results.first
    }

    func deleteMapping(withCalendarEventIdentifier calendarEventIdentifier: String) throws {
        let fetchRequest = ScheduledTaskMapping.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "calendarEventIdentifier == %@", calendarEventIdentifier)
        let results = try viewContext.fetch(fetchRequest)
        if let mappingToDelete = results.first {
            viewContext.delete(mappingToDelete)
            saveContext()
        }
    }

    // You might need other fetch requests as needed
}
