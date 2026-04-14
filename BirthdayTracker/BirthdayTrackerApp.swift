//
//  BirthdayTrackerApp.swift
//  BirthdayTracker
//
//  Created by Mason Carstens on 3/18/26.
//

import SwiftUI
import SwiftData

@main
struct BirthdayTrackerApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Birthday.self,
            AppSettings.self,
            GiftItem.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            MainTabView()
        }
        .modelContainer(sharedModelContainer)
    }
}
