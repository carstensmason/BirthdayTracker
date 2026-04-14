//
//  GiftsView.swift
//  BirthdayTracker
//
//  Created by Mason Carstens on 4/14/26.
//

import SwiftUI
import SwiftData

struct GiftsView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Birthday.name, order: .forward) private var birthdays: [Birthday]
    @Query private var settingsArray: [AppSettings]
    
    var isDarkThemeEnabled: Bool {
        settingsArray.first?.isDarkThemeEnabled ?? false
    }

    var body: some View {
        NavigationStack {
            List {
                if birthdays.isEmpty {
                    Text("No birthdays added yet. Add someone to start making a gift list!")
                        .foregroundColor(.secondary)
                        .italic()
                        .listRowBackground(Color.clear)
                } else {
                    ForEach(birthdays) { birthday in
                        NavigationLink(destination: GiftListView(birthday: birthday)) {
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(birthday.name)
                                        .font(.headline)
                                        .foregroundColor(.primary)
                                    
                                    if let gifts = birthday.gifts, !gifts.isEmpty {
                                        Text("\(gifts.filter { !$0.isPurchased }.count) remaining to buy")
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                    } else {
                                        Text("No gifts added")
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                    }
                                }
                                
                                Spacer()
                                
                                if birthday.isImportant {
                                    Image(systemName: "star.fill")
                                        .foregroundColor(.yellow)
                                        .font(.caption)
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("Gift Lists")
            .scrollContentBackground(isDarkThemeEnabled ? .hidden : .automatic)
            .background(isDarkThemeEnabled ? Color(red: 0.18, green: 0.20, blue: 0.22) : Color(UIColor.systemGroupedBackground))
        }
    }
}

#Preview {
    GiftsView()
        .modelContainer(for: [Birthday.self, GiftItem.self], inMemory: true)
}
