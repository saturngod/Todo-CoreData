//
//  ReminderListView.swift
//  RemindersApp
//
//

import SwiftUI

struct ReminderListView: View {
    

    let reminders: FetchedResults<Reminder>
    
    @State private var selectedReminder: Reminder?
    @State private var showReminderDetail: Bool = false
    
    private func reminderCheckedChange(reminder: Reminder, isCompleted: Bool) {
        var editConfig = ReminderEditConfig(reminder: reminder)
        editConfig.isCompleted = !reminder.isCompleted
        do {
            let _ = try ReminderService.updateReminder(reminder: reminder, editConfig: editConfig)
        } catch {
            print(error)
        }
    }
    
    private func isReminderSelected(_ reminder: Reminder) -> Bool {
        selectedReminder?.objectID == reminder.objectID
    }
    
    
    private func deleteReminder(_ indexSet: IndexSet) {
        indexSet.forEach { index in
            let reminder = reminders[index]
            do {
                try ReminderService.deleteReminder(reminder: reminder)
            }
            catch {
                print(error)
            }
        }
    }
    
    var body: some View {
        VStack {
            List {
                ForEach(reminders) { reminder in
                    ReminderCellView(reminder: reminder,isSelected: isReminderSelected(reminder)) { event in
                        switch event {
                        case .onSelect(let reminder):
                            selectedReminder = reminder
                        case .onCheckedChange(let reminder, let isCompleted):
                            reminderCheckedChange(reminder: reminder,isCompleted: isCompleted)
                        case .onInfo:
                            showReminderDetail = true
                        }
                    }
                    
                }
                .onDelete(perform: deleteReminder)
            }
            
            .sheet(isPresented: $showReminderDetail, content: {
                if let binding = Binding($selectedReminder) {
                    ReminderDetailView(reminder: binding)
                }
            })
        }
    }
}


struct ReminderListView_Previews: PreviewProvider {
    
    struct ReminderListContainer: View  {
        
        @FetchRequest(sortDescriptors: [])
        private var reminderResults: FetchedResults<Reminder>
        
        var body: some View {
            ReminderListView(reminders: reminderResults)
        }
    }
    
    static var previews: some View {
        ReminderListContainer()
    }
}
