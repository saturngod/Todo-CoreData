//
//  ReminderService.swift
//  RemindersApp
//
//

import Foundation
import CoreData
import UIKit

class ReminderService {
    
    static var viewContext: NSManagedObjectContext {
        CoreDataProvider.shared.persistentContainer.viewContext
    }
    
    static func save() throws {
        try viewContext.save()
    }
    
    static func saveMyList(_ name: String, _ color: UIColor) throws {
        let myList = MyList(context: viewContext)
        myList.name = name
        myList.color = color
        try save()
    }
    
    static func saveReminderToMyList(myList: MyList, reminderTitle: String) throws {
        let reminder = Reminder(context: viewContext)
        reminder.title = reminderTitle
        myList.addToReminders(reminder)
        try save()
    }
    
    static func updateReminder(reminder: Reminder, editConfig: ReminderEditConfig) throws -> Bool {
        let reminderToUpdate = reminder
        reminderToUpdate.isCompleted = editConfig.isCompleted
        reminderToUpdate.title = editConfig.title
        reminderToUpdate.notes = editConfig.notes
        reminderToUpdate.reminderDate = editConfig.hasDate ? editConfig.reminderDate : nil
        reminderToUpdate.reminderTime = editConfig.hasTime ? editConfig.reminderTime : nil
        
        try save()
        return true
    }
    
    static func getRemindersByList(myList: MyList) -> NSFetchRequest<Reminder> {
        let request = Reminder.fetchRequest()
        request.sortDescriptors = []
        request.predicate = NSPredicate(format: "list = %@ AND isCompleted = false", myList)
        return request
    }
    
    static func deleteReminder(reminder: Reminder) throws {
        viewContext.delete(reminder)
        try save()
    }
    
    static func remindersByStatType(statType: ReminderStatType) -> NSFetchRequest<Reminder> {
        
        let request = Reminder.fetchRequest()
        request.sortDescriptors = []
        
        switch statType {
        case .all:
            request.predicate = NSPredicate(format: "isCompleted = false")
        case .today: // THIS PART HAS BEEN UPDATED
            let today = Date()
            if let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: today) as? NSDate {
                request.predicate = NSPredicate(format: "(reminderDate BETWEEN {%@, %@}) OR (reminderTime BETWEEN {%@, %@})", today as NSDate, tomorrow)
            }
        case .scheduled:
            request.predicate = NSPredicate(format: "(reminderDate != nil OR reminderTime != nil) AND isCompleted = false")
        case .completed:
            request.predicate = NSPredicate(format: "isCompleted = true")
        }
        
        return request
        
    }
    
    
    static func getRemindersBySearchTerm(_ searchTerm: String) -> NSFetchRequest<Reminder> {
        let request = Reminder.fetchRequest()
        request.sortDescriptors = []
        request.predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchTerm)
        return request
    }
    
}
