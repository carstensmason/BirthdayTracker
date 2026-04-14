//
//  Birthday.swift
//  BirthdayTracker
//
//  Created by Mason Carstens on 3/18/26.
//

import Foundation
import SwiftData

// The following is a class for Birthday objects to conform to

@Model
final class Birthday {
    var id: UUID = UUID()
    var name: String = ""
    var date: Date = Date()
    var isImportant: Bool = false
    var dateAdded: Date = Date()
    
    @Relationship(deleteRule: .cascade, inverse: \GiftItem.birthday)
    var gifts: [GiftItem]? = []
    
    init(id: UUID = UUID(), name: String = "", date: Date = Date(), isImportant: Bool = false, dateAdded: Date = Date()) {
        self.id = id
        self.name = name
        self.date = date
        self.isImportant = isImportant
        self.dateAdded = dateAdded
    }
}
