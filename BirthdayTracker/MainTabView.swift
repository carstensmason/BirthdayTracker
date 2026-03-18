//
//  MainTabView.swift
//  BirthdayTracker
//
//  Created by Mason Carstens on 3/18/26.
//

import SwiftUI
import SwiftData

struct MainTabView: View {
    @Query private var settingsArray: [AppSettings]
    
    var isDarkThemeEnabled: Bool {
        settingsArray.first?.isDarkThemeEnabled ?? false
    }
    
    var body: some View {
        TabView {
            ContentView()
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
            
            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gearshape.fill")
                }
        }
        // Force overall app to use dark mode if slate gray theme is enabled
        .preferredColorScheme(isDarkThemeEnabled ? .dark : nil)
    }
}

#Preview {
    MainTabView()
        .modelContainer(for: [Birthday.self, AppSettings.self], inMemory: true)
}
