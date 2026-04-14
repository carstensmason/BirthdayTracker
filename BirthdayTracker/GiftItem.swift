//
//  GiftItem.swift
//  BirthdayTracker
//
//  Created by Mason Carstens on 4/14/26.
//

import Foundation
import SwiftData

@Model
final class GiftItem {
    var id: UUID = UUID()
    var title: String = ""
    var isPurchased: Bool = false
    var birthday: Birthday?
    
    init(id: UUID = UUID(), title: String = "", isPurchased: Bool = false) {
        self.id = id
        self.title = title
        self.isPurchased = isPurchased
    }
}
