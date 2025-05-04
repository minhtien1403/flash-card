//
//  Deck.swift
//  FlashCard
//
//  Created by tientm on 22/12/2023.
//

import Foundation

struct Deck: Identifiable {
    
    var id: String
    var name: String
    var createdDate: String
    var lastAccessDate: String
    var cardCount = 0
    
    init(id: String = UUID().uuidString, name: String = "", createdDate: String = "", lastAccessDate: String = "") {
        self.id = id
        self.name = name
        self.createdDate = createdDate
        self.lastAccessDate = lastAccessDate
    }
}

extension Deck {
    
    init?(entity: CDDeck) {
        guard let id = entity.id else { return nil }
        self.id = id
        self.name = entity.name ?? ""
        self.createdDate = entity.createdDate ?? Date().toString()
        self.lastAccessDate = entity.lastAccessDate ?? Date().toString()
    }
    
    func map(to entity: CDDeck) {
        entity.id = self.id
        entity.name = self.name
        entity.createdDate = self.createdDate
        entity.lastAccessDate = self.lastAccessDate
    }
}
