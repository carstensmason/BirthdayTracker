//
//  SettingsView.swift
//  BirthdayTracker
//
//  Created by Mason Carstens on 3/18/26.
//

import SwiftUI
import SwiftData

struct SettingsView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var settingsArray: [AppSettings]
    
    // We bind to the first settings object, or default to a new state if none exist yet.
    @State private var isDarkThemeEnabled: Bool = false
    @State private var sortOrder: BirthdaySortOrder = .upcoming
    
    var currentSettings: AppSettings? {
        settingsArray.first
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Appearance")) {
                    Toggle("Dark Theme", isOn: $isDarkThemeEnabled)
                        .onChange(of: isDarkThemeEnabled) { _, newValue in
                            if let settings = currentSettings {
                                settings.isDarkThemeEnabled = newValue
                            } else {
                                let newSettings = AppSettings(isDarkThemeEnabled: newValue, sortOrder: sortOrder)
                                modelContext.insert(newSettings)
                            }
                        }
                }
                
                Section(header: Text("Preferences")) {
                    Picker("Sort Birthdays By", selection: $sortOrder) {
                        ForEach(BirthdaySortOrder.allCases, id: \.self) { order in
                            Text(order.rawValue).tag(order)
                        }
                    }
                    .onChange(of: sortOrder) { _, newValue in
                        if let settings = currentSettings {
                            settings.sortOrder = newValue
                        } else {
                            let newSettings = AppSettings(isDarkThemeEnabled: isDarkThemeEnabled, sortOrder: newValue)
                            modelContext.insert(newSettings)
                        }
                    }
                }
                
                /*
                Section(footer: Text("Theme settings are stored securely in iCloud via SwiftData.")) {
                    // Explanatory footer
                }
                 */
            }
            .navigationTitle("Settings")
            .onAppear {
                if let settings = currentSettings {
                    isDarkThemeEnabled = settings.isDarkThemeEnabled
                    sortOrder = settings.sortOrder
                } else {
                    // Create one if it doesn't exist yet
                    let newSettings = AppSettings(isDarkThemeEnabled: false, sortOrder: .upcoming)
                    modelContext.insert(newSettings)
                    isDarkThemeEnabled = false
                    sortOrder = .upcoming
                }
            }
            // Apply Slate Gray background if dark theme is enabled
            .scrollContentBackground(isDarkThemeEnabled ? .hidden : .automatic)
            .background(isDarkThemeEnabled ? Color(red: 0.18, green: 0.20, blue: 0.22) : Color(UIColor.systemGroupedBackground))
        }
    }
}

#Preview {
    SettingsView()
        .modelContainer(for: AppSettings.self, inMemory: true)
}
