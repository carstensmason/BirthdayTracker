//
//  AppSettings.swift
//  BirthdayTracker
//
//  Created by Mason Carstens on 3/18/26.
//

import Foundation
import SwiftData

// The following is a class representing the settings for the application

enum BirthdaySortOrder: String, Codable, CaseIterable {
    case alphabetical = "Alphabetical"
    case dateAdded = "Date Added"
    case upcoming = "Upcoming"
}

@Model
final class AppSettings {
    var id: UUID = UUID()
    var isDarkThemeEnabled: Bool = true
    var sortOrder: BirthdaySortOrder = BirthdaySortOrder.upcoming
    
    init(isDarkThemeEnabled: Bool = true, sortOrder: BirthdaySortOrder = BirthdaySortOrder.upcoming) {
        self.id = UUID()
        self.isDarkThemeEnabled = isDarkThemeEnabled
        self.sortOrder = sortOrder
    }
}
