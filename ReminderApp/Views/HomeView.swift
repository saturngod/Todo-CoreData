//
//  ContentView.swift
//  RemindersApp
//
//

import SwiftUI

struct HomeView: View {
    
    @FetchRequest(sortDescriptors: [])
    private var myListResults: FetchedResults<MyList>
    
    @FetchRequest(sortDescriptors: [])
    private var searchResults: FetchedResults<Reminder>
    
    
    @FetchRequest(fetchRequest: ReminderService.remindersByStatType(statType: .today))
    private var todayResults: FetchedResults<Reminder>
    
    @FetchRequest(fetchRequest: ReminderService.remindersByStatType(statType: .scheduled))
    private var scheduleResults: FetchedResults<Reminder>
    
    @FetchRequest(fetchRequest: ReminderService.remindersByStatType(statType: .all))
    private var allResults: FetchedResults<Reminder>
    
    @FetchRequest(fetchRequest: ReminderService.remindersByStatType(statType: .completed))
    private var completeResults: FetchedResults<Reminder>
    
    
    @State private var isPresented: Bool = false
    @State private var search: String = ""
    @State private var searching: Bool = false
    
    private var remindersStatsBuilder = ReminderStatsBuilder()
    @State private var reminderStatsValue = ReminderStatsValues()
    
    var body: some View {
        NavigationStack {
            VStack {
                ScrollView {
                 
                    
                    HStack {
                        
                        NavigationLink {
                            ReminderListView(reminders: todayResults)
                        } label: {
                            ReminderStatsView(icon: "calendar", title: "Today",count:reminderStatsValue.todayCount)
                        }
                        
                        NavigationLink {
                            ReminderListView(reminders: allResults)
                        } label: {
                            ReminderStatsView(icon: "tray.circle.fill", title: "All",count:reminderStatsValue.allCount, iconColor: .red)
                        }
                        
                        
                    }
                    
                    HStack {
                        
                        NavigationLink {
                            ReminderListView(reminders: scheduleResults)
                        } label: {
                            ReminderStatsView(icon: "calendar.circle.fill", title: "Schedule",count:reminderStatsValue.scheduleCount, iconColor: .secondary)
                        }
                        
                        NavigationLink {
                            ReminderListView(reminders: completeResults)
                        } label: {
                            ReminderStatsView(icon: "checkmark.circle.fill", title: "Completed",count:reminderStatsValue.completedCount,iconColor: .primary)
                        }
                        
                        
                      
                    }

                    
                    
                    Text("My Lists")
                        .frame(maxWidth: .infinity,alignment: .leading)
                        .font(.largeTitle)
                        .bold()
                        .padding()
                    MyListsView(myLists: myListResults)
                    
                
                    
                    Button {
                        isPresented = true
                    } label: {
                        Text("Add List")
                            .frame(maxWidth: .infinity, alignment: .trailing)
                            .font(.headline)
                    }.padding()
                }
            }
            .onChange(of: search){ oldValue, searchTerm in
                searching = !searchTerm.isEmpty ? true : false
                searchResults.nsPredicate = ReminderService.getRemindersBySearchTerm(search).predicate
            }
            .overlay(alignment: .center, content: {
                ReminderListView(reminders: searchResults)
                    .opacity(searching ? 1.0 : 0.0)
                    .frame(maxWidth: .infinity,maxHeight: .infinity)
            })
            .onAppear {
                reminderStatsValue = remindersStatsBuilder.build(myListResults: myListResults)
            }
            .sheet(isPresented: $isPresented) {
                NavigationView {
                    AddNewListView { name, color in
                        do {
                            try ReminderService.saveMyList(name, color)
                        } catch {
                            print(error)
                        }
                    }
                }
            }
            .padding()
            .navigationTitle("Reminders")
        }
        .searchable(text: $search)
        
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environment(\.managedObjectContext, CoreDataProvider.shared.persistentContainer.viewContext)
    }
}
