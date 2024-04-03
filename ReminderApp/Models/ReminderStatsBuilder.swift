//
//  ReminderStatsBuilder.swift
//  ReminderApp
//
//

import Foundation
import SwiftUI

enum ReminderStatType {
    case today
    case all
    case scheduled
    case completed
}

struct ReminderStatsValues {
    var todayCount: Int = 0
    var scheduleCount: Int = 0
    var allCount: Int = 0
    var completedCount: Int = 0
}

struct ReminderStatsBuilder {
    func build(myListResults: FetchedResults<MyList>) -> ReminderStatsValues {
        
        let reminderArray = myListResults.map {$0.remindersArray}.reduce([],+)
        let completedCount = calculateCompletedCount(reminders: reminderArray)
        let allCount = calculateAllcount(reminders: reminderArray)
        let todayCount = calculateTodaysCount(reminders: reminderArray)
        let scheduleCount = calculateScheduleCount(reminders: reminderArray)
        
        return ReminderStatsValues(todayCount: todayCount,scheduleCount: scheduleCount,allCount: allCount,completedCount: completedCount)
    }
    
    private func calculateScheduleCount(reminders: [Reminder]) -> Int {
        return reminders.reduce(0) { result , reminder in
           
            return ((reminder.reminderDate != nil || reminder.reminderTime != nil) && !reminder.isCompleted) ? result + 1 : result
        }
    }
    
    private func calculateTodaysCount(reminders: [Reminder]) -> Int {
        return reminders.reduce(0) { result , reminder in
            let isToday = reminder.reminderDate?.isToday ?? false
            return isToday ? result + 1 : result
        }
    }
    
    private func calculateCompletedCount(reminders: [Reminder]) -> Int {
        return reminders.reduce(0) { result, reminder in
            return reminder.isCompleted ? result + 1 : result
        }
    }
    
    private func calculateAllcount(reminders: [Reminder]) -> Int {
        return reminders.reduce(0) { result, reminder in
            return !reminder.isCompleted ? result + 1 : result
        }
    }
}
