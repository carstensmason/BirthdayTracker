//
//  NotificationManager.swift
//  BirthdayTracker
//
//  Created by Mason Carstens on 3/18/26.
//

import Foundation
import UserNotifications

class NotificationManager {
    static let shared = NotificationManager()
    
    private init() {}
    
    func requestAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if let error = error {
                print("Error requesting authorization for notifications: \(error.localizedDescription)")
            } else {
                print("Notification permission granted: \(granted)")
            }
        }
    }
    
    func scheduleNotifications(for birthday: Birthday) {
        // First, cancel any existing notifications for this birthday
        cancelNotifications(for: birthday)
        
        let center = UNUserNotificationCenter.current()
        let calendar = Calendar.current
        
        // Ensure date components have a fixed time (e.g., 9 AM)
        var dateComponents = calendar.dateComponents([.month, .day], from: birthday.date)
        dateComponents.hour = 9
        dateComponents.minute = 0
        
        // 1. Schedule Day-of Notification
        let dayOfContent = UNMutableNotificationContent()
        dayOfContent.title = "It's \(birthday.name)'s Birthday!"
        dayOfContent.body = "Don't forget to wish them a happy birthday today!"
        dayOfContent.sound = .default
        
        let dayOfTrigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let dayOfRequest = UNNotificationRequest(identifier: "\(birthday.id.uuidString)-dayOf", content: dayOfContent, trigger: dayOfTrigger)
        
        center.add(dayOfRequest) { error in
            if let error = error {
                print("Error scheduling day-of notification: \(error.localizedDescription)")
            }
        }
        
        // 2. Schedule 1-Week Before Notification (only if important)
        if birthday.isImportant {
            // Subtract 7 days from the birthday date to find the week before
            if let weekBeforeDate = calendar.date(byAdding: .day, value: -7, to: birthday.date) {
                var weekBeforeComponents = calendar.dateComponents([.month, .day], from: weekBeforeDate)
                weekBeforeComponents.hour = 9
                weekBeforeComponents.minute = 0
                
                let weekBeforeContent = UNMutableNotificationContent()
                weekBeforeContent.title = "\(birthday.name)'s Birthday is coming up!"
                weekBeforeContent.body = "\(birthday.name)'s birthday is in exactly one week!"
                weekBeforeContent.sound = .default
                
                let weekBeforeTrigger = UNCalendarNotificationTrigger(dateMatching: weekBeforeComponents, repeats: true)
                let weekBeforeRequest = UNNotificationRequest(identifier: "\(birthday.id.uuidString)-weekBefore", content: weekBeforeContent, trigger: weekBeforeTrigger)
                
                center.add(weekBeforeRequest) { error in
                    if let error = error {
                        print("Error scheduling week-before notification: \(error.localizedDescription)")
                    }
                }
            }
        }
    }
    
    func cancelNotifications(for birthday: Birthday) {
        let center = UNUserNotificationCenter.current()
        let identifiers = [
            "\(birthday.id.uuidString)-dayOf",
            "\(birthday.id.uuidString)-weekBefore"
        ]
        center.removePendingNotificationRequests(withIdentifiers: identifiers)
    }
}
