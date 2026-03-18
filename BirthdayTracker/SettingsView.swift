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
    
    var currentSettings: AppSettings? {
        settingsArray.first
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Appearance")) {
                    Toggle("Dark Theme (Slate Gray)", isOn: $isDarkThemeEnabled)
                        .onChange(of: isDarkThemeEnabled) { _, newValue in
                            if let settings = currentSettings {
                                settings.isDarkThemeEnabled = newValue
                            } else {
                                let newSettings = AppSettings(isDarkThemeEnabled: newValue)
                                modelContext.insert(newSettings)
                            }
                        }
                }
                
                Section(footer: Text("Theme settings are stored securely in iCloud via SwiftData.")) {
                    // Explanatory footer
                }
            }
            .navigationTitle("Settings")
            .onAppear {
                if let settings = currentSettings {
                    isDarkThemeEnabled = settings.isDarkThemeEnabled
                } else {
                    // Create one if it doesn't exist yet
                    let newSettings = AppSettings(isDarkThemeEnabled: false)
                    modelContext.insert(newSettings)
                    isDarkThemeEnabled = false
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
