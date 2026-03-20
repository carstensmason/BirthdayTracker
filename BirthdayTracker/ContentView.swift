//
//  ContentView.swift
//  BirthdayTracker
//
//  Created by Mason Carstens on 3/18/26.
//

import SwiftUI
import SwiftData

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Birthday.date, order: .forward) private var birthdays: [Birthday]
    @Query private var settingsArray: [AppSettings]

    @State private var showingAddView = false
    @State private var birthdayToEdit: Birthday?
    
    var isDarkThemeEnabled: Bool {
        settingsArray.first?.isDarkThemeEnabled ?? false
    }

    var body: some View {
        NavigationStack {
            List {
                ForEach(sortedBirthdays) { birthday in
                    Button {
                        // Set the selected birthday to edit
                        birthdayToEdit = birthday
                    } label: {
                        VStack(alignment: .leading) {
                            Text(birthday.name)
                                .font(.headline)
                                .foregroundColor(.primary)
                            
                            HStack {
                                Text(birthday.date, format: Date.FormatStyle(date: .abbreviated, time: .omitted))
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                
                                if birthday.isImportant {
                                    Image(systemName: "star.fill")
                                        .foregroundColor(.yellow)
                                        .font(.caption)
                                }
                            }
                        }
                    }
                    .swipeActions {
                        Button(role: .destructive) {
                            deleteBirthday(birthday)
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }
                    }
                }
                .onDelete(perform: deleteBirthdays)
            }
            .navigationTitle("Birthdays")
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    EditButton()
                    Button {
                        showingAddView = true
                    } label: {
                        Label("Add", systemImage: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddView) {
                AddBirthdayView()
            }
            .sheet(item: $birthdayToEdit) { birthday in
                AddBirthdayView(birthdayToEdit: birthday)
            }
            .onAppear {
                NotificationManager.shared.requestAuthorization()
            }
            .scrollContentBackground(isDarkThemeEnabled ? .hidden : .automatic)
            .background(isDarkThemeEnabled ? Color(red: 0.18, green: 0.20, blue: 0.22) : Color(UIColor.systemGroupedBackground))
        }
    }
    
    private var sortedBirthdays: [Birthday] {
        let order = settingsArray.first?.sortOrder ?? .upcoming
        
        return birthdays.sorted { b1, b2 in
            switch order {
            case .alphabetical:
                return b1.name.localizedCaseInsensitiveCompare(b2.name) == .orderedAscending
            case .dateAdded:
                return b1.dateAdded < b2.dateAdded
            case .upcoming:
                return daysUntil(b1.date) < daysUntil(b2.date)
            }
        }
    }
    
    private func daysUntil(_ date: Date) -> Int {
        let calendar = Calendar.current
        let now = Date()
        
        var dateComponents = calendar.dateComponents([.month, .day], from: date)
        dateComponents.year = calendar.component(.year, from: now)
        
        var nextBirthday = calendar.date(from: dateComponents) ?? now
        if nextBirthday < calendar.startOfDay(for: now) {
            dateComponents.year! += 1
            nextBirthday = calendar.date(from: dateComponents) ?? now
        }
        
        let days = calendar.dateComponents([.day], from: calendar.startOfDay(for: now), to: calendar.startOfDay(for: nextBirthday)).day ?? 0
        return days
    }

    private func deleteBirthdays(offsets: IndexSet) {
        for index in offsets {
            deleteBirthday(sortedBirthdays[index])
        }
    }
    
    private func deleteBirthday(_ birthday: Birthday) {
        // Cancel notifications first
        NotificationManager.shared.cancelNotifications(for: birthday)
        
        // Remove from SwiftData
        modelContext.delete(birthday)
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Birthday.self, inMemory: true)
}
