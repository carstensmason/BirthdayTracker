//
//  AddBirthdayView.swift
//  BirthdayTracker
//
//  Created by Mason Carstens on 3/18/26.
//

import SwiftUI
import SwiftData

struct AddBirthdayView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    // Existing birthday passed for editing, or nil for adding a new one
    var birthdayToEdit: Birthday?

    @State private var name: String = ""
    @State private var date: Date = Date()
    @State private var isImportant: Bool = false
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Details")) {
                    TextField("Name", text: $name)
                        .autocorrectionDisabled(true)
                    DatePicker("Birthday", selection: $date, displayedComponents: [.date])
                    Toggle("Important Birthday", isOn: $isImportant)
                }
                
                if isImportant {
                    Section(footer: Text("You will receive a notification 1 week before the birthday in addition to the day of.")) {
                        // Just an explanatory footer
                    }
                }
            }
            .navigationTitle(birthdayToEdit == nil ? "Add Birthday" : "Edit Birthday")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        saveBirthday()
                    }
                    .disabled(name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
            .onAppear {
                if let birthday = birthdayToEdit {
                    name = birthday.name
                    date = birthday.date
                    isImportant = birthday.isImportant
                } else {
                    // Try to request notification permissions on the first time they open this sheet
                    NotificationManager.shared.requestAuthorization()
                }
            }
        }
    }
    
    private func saveBirthday() {
        if let birthday = birthdayToEdit {
            // Update existing
            birthday.name = name
            birthday.date = date
            birthday.isImportant = isImportant
            
            // Re-schedule notifications
            NotificationManager.shared.scheduleNotifications(for: birthday)
        } else {
            // Create new
            let newBirthday = Birthday(name: name, date: date, isImportant: isImportant)
            modelContext.insert(newBirthday)
            
            // Schedule notifications
            NotificationManager.shared.scheduleNotifications(for: newBirthday)
        }
        
        dismiss()
    }
}

#Preview {
    AddBirthdayView()
        .modelContainer(for: Birthday.self, inMemory: true)
}
