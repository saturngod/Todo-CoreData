//
//  ReminderCellView.swift
//  ReminderApp
//
//

import SwiftUI

enum ReminderCellEvents {
    case onInfo
    case onCheckedChange(Reminder,Bool)
    case onSelect(Reminder)
    
    
}
struct ReminderCellView: View {
    
    let reminder: Reminder
    let delay = Delay()
    let isSelected: Bool
    
    @State private var checked: Bool = false
    
    let onEvent: (ReminderCellEvents) -> Void
    
    private func formatDate(_ date: Date) -> String {
        if date.isToday {
            return "Today"
        } else if date.isTomorrow {
            return "Tomorrow"
        } else {
            return date.formatted(date: .numeric, time: .omitted)
        }
    }
    
    var body: some View {
        HStack {
            Image(systemName: checked ? "circle.inset.filled" : "circle")
                .font(.title2)
                .opacity(0.4)
                .onTapGesture {
                    checked.toggle()
                    
                    delay.cancel()
                    
                    delay.performWork {
                        onEvent(.onCheckedChange(reminder,checked))
                    }
                   
                }
            
            VStack(alignment: .leading) {
                Text(reminder.title ?? "")
                if let notes = reminder.notes, !notes.isEmpty {
                    Text(notes)
                        .opacity(0.4)
                        .font(.caption)
                }
                
                HStack {
                    if let reminderDate = reminder.reminderDate {
                        Text(formatDate(reminderDate))
                    }
                    
                    if let reminderTime = reminder.reminderTime {
                        Text(reminderTime.formatted(date: .omitted, time: .shortened))
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.caption)
                .opacity(0.4)
            }
                                         
            Spacer()
                                         
            Image(systemName: "info.circle.fill")
                .opacity(isSelected ? 1.0 : 0.0)
                .onTapGesture {
                    onEvent(.onInfo)
                }
        }
        .onAppear {
            checked = reminder.isCompleted
        }
        .contentShape(Rectangle())
        .onTapGesture {
            onEvent(.onSelect(reminder))
        }
    }
}

#Preview {
    ReminderCellView(reminder: PreviewData.reminder, isSelected: false) { _ in
        
    }
}
