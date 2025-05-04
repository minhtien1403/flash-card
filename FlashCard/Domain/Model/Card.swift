//
//  Card.swift
//  FlashCard
//
//  Created by tientm on 22/12/2023.
//

import Foundation

struct Card: Identifiable, Equatable {
    
    var id: String
    var front: String
    var back: String
    var deckId: String
    
    init(id: String = UUID().uuidString, deckID: String, front: String = "", back: String = "") {
        self.id = id
        self.front = front
        self.back = back
        self.deckId = deckID
    }
    
    static func == (lhs: Card, rhs: Card) -> Bool {
        lhs.id == rhs.id
    }
}

extension Card {
    
    init?(entity: CDCard) {
        guard let id = entity.id, let deckID = entity.deckID else { return nil }
        self.id = id
        self.front = entity.front ?? ""
        self.back = entity.back ?? ""
        self.deckId = deckID
    }
    
    func map(to entity: CDCard) {
        entity.id = self.id
        entity.front = self.front
        entity.back = self.back
        entity.deckID = self.deckId
    }
}
