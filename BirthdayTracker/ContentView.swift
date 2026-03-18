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
                ForEach(birthdays) { birthday in
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
            }
            .navigationTitle("Birthdays")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
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
