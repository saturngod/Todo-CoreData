//
//  ReminderAppApp.swift
//  ReminderApp
//
//

import SwiftUI
import CoreData
import UserNotifications

@main
struct ReminderAppApp: App {
    
    init() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert,.sound,.badge]) { granted, error in
            if granted {
                
            }
            else {
                
            }
        }
    }
    var body: some Scene {
        WindowGroup {
            HomeView()
                .environment(\.managedObjectContext,CoreDataProvider.shared.persistentContainer.viewContext)
        }
    }
}
