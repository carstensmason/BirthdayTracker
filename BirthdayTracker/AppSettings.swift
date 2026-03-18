//
//  AppSettings.swift
//  BirthdayTracker
//
//  Created by Mason Carstens on 3/18/26.
//

import Foundation
import SwiftData

@Model
final class AppSettings {
    var id: UUID = UUID()
    var isDarkThemeEnabled: Bool = false
    
    init(isDarkThemeEnabled: Bool = false) {
        self.id = UUID()
        self.isDarkThemeEnabled = isDarkThemeEnabled
    }
}
