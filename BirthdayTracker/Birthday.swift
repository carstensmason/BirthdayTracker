//
//  Birthday.swift
//  BirthdayTracker
//
//  Created by Mason Carstens on 3/18/26.
//

import Foundation
import SwiftData

@Model
final class Birthday {
    var id: UUID = UUID()
    var name: String = ""
    var date: Date = Date()
    var isImportant: Bool = false
    
    init(id: UUID = UUID(), name: String = "", date: Date = Date(), isImportant: Bool = false) {
        self.id = id
        self.name = name
        self.date = date
        self.isImportant = isImportant
    }
}
