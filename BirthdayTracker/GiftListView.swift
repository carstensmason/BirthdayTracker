//
//  GiftListView.swift
//  BirthdayTracker
//
//  Created by Mason Carstens on 4/14/26.
//

import SwiftUI
import SwiftData

struct GiftListView: View {
    @Environment(\.modelContext) private var modelContext
    @Bindable var birthday: Birthday
    @Query private var settingsArray: [AppSettings]
    
    @State private var newGiftTitle: String = ""
    @State private var showDeleteConfirmation = false
    @State private var giftToDelete: GiftItem?
    
    var isDarkThemeEnabled: Bool {
        settingsArray.first?.isDarkThemeEnabled ?? false
    }

    var sortedGifts: [GiftItem] {
        let items = birthday.gifts ?? []
        // Sort so unchecked items are at the top, then alphabetically
        return items.sorted {
            if $0.isPurchased == $1.isPurchased {
                return $0.title.localizedCaseInsensitiveCompare($1.title) == .orderedAscending
            }
            return !$0.isPurchased && $1.isPurchased
        }
    }

    var body: some View {
        List {
            Section(header: Text("Add Idea")) {
                HStack {
                    TextField("New gift idea...", text: $newGiftTitle)
                        .onSubmit {
                            addGift()
                        }
                    
                    Button(action: addGift) {
                        Image(systemName: "plus.circle.fill")
                            .foregroundColor($newGiftTitle.wrappedValue.isEmpty ? .gray : .blue)
                            .imageScale(.large)
                    }
                    .disabled(newGiftTitle.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                    .buttonStyle(PlainButtonStyle())
                }
            }
            
            Section(header: Text("Ideas")) {
                let giftsList = sortedGifts
                if giftsList.isEmpty {
                    Text("No ideas yet.")
                        .italic()
                        .foregroundColor(.secondary)
                        .listRowBackground(Color.clear)
                } else {
                    ForEach(giftsList) { gift in
                        HStack {
                            Button(action: {
                                gift.isPurchased.toggle()
                            }) {
                                Image(systemName: gift.isPurchased ? "checkmark.circle.fill" : "circle")
                                    .foregroundColor(gift.isPurchased ? .green : .gray)
                                    .imageScale(.large)
                            }
                            .buttonStyle(PlainButtonStyle())
                            
                            Text(gift.title)
                                .strikethrough(gift.isPurchased, color: .secondary)
                                .foregroundColor(gift.isPurchased ? .secondary : .primary)
                        }
                    }
                    .onDelete(perform: deleteGifts)
                }
            }
        }
        .navigationTitle(birthday.name)
        .scrollContentBackground(isDarkThemeEnabled ? .hidden : .automatic)
        .background(isDarkThemeEnabled ? Color(red: 0.18, green: 0.20, blue: 0.22) : Color(UIColor.systemGroupedBackground))
        .alert(
            "Are you sure you want to delete '\(giftToDelete?.title ?? "")'?",
            isPresented: $showDeleteConfirmation
        ) {
            Button("Cancel", role: .cancel) {
                giftToDelete = nil
            }
            Button("Delete", role: .destructive) {
                if let item = giftToDelete {
                    withAnimation {
                        deleteSingleGift(item)
                    }
                }
            }
        }
    }
    
    private func deleteSingleGift(_ gift: GiftItem) {
        birthday.gifts?.removeAll(where: { $0.id == gift.id })
        modelContext.delete(gift)
    }
    
    private func addGift() {
        let trimmedTitle = newGiftTitle.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedTitle.isEmpty else { return }
        
        let newGift = GiftItem(title: trimmedTitle, isPurchased: false)
        modelContext.insert(newGift)
        
        if birthday.gifts == nil {
            birthday.gifts = []
        }
        birthday.gifts?.append(newGift)
        
        newGiftTitle = ""
    }
    
    private func deleteGifts(offsets: IndexSet) {
        let itemsToDelete = offsets.map { sortedGifts[$0] }
        if let item = itemsToDelete.first {
            giftToDelete = item
            showDeleteConfirmation = true
        }
    }
}
