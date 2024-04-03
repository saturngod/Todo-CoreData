//
//  NotificationManager.swift
//  ReminderApp
//
//

import Foundation
import UserNotifications

struct UserData {
    let title: String?
    let body: String?
    let date: Date?
    let time: Date?
    
}

class NotificationManager {
    static func scheduleNotification(userData: UserData) {
        let content = UNMutableNotificationContent()
        content.title = userData.title ?? ""
        content.body = userData.body ?? ""
        
        var dateComponents = Calendar.current.dateComponents([.year,.month,.day,.hour,.minute], from: userData.date ?? Date())
        
        if let reminderTime = userData.time {
            let reminderTimeDateComponents = reminderTime.dateComponents
            dateComponents.hour = reminderTimeDateComponents.hour
            dateComponents.minute = reminderTimeDateComponents.minute
        }
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        
    }
}
