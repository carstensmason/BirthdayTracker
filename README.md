# BirthdayTracker by Mason Carstens

BirthdayTracker is an iOS application that helps users easily keep track of upcoming birthdays for friends, family, and loved ones. It supports categorized tracking (important vs. normal birthdays) and provides local notifications so you never forget to wish someone a happy birthday.

## Tech Stack
- **Language**: Swift
- **UI Framework**: SwiftUI
- **Database & Persistence**: SwiftData
- **Cloud Sync**: CloudKit (syncs birthdays across your iCloud-connected devices)
- **Local Notifications**: UserNotifications framework

## Setup Intructions
1. Clone the repository and open `BirthdayTracker.xcodeproj` in Xcode 15 or later.
2. Select your development team in the "Signing & Capabilities" tab.
3. If testing CloudKit functionality, ensure you are signed into an iCloud account on your iOS Simulator or physical device.
4. Build and run the project.