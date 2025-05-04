//
//  Deck.swift
//  FlashCard
//
//  Created by tientm on 21/12/2023.
//

import SwiftUI

struct DeckItem: View {
    
    @EnvironmentObject private var localizationServices: LocalizationServices
    private var deck: Deck
    private var onDelete: (String) -> Void
    
    init(deck: Deck, onDelete: @escaping (String) -> Void) {
        self.deck = deck
        self.onDelete = onDelete
    }
    
    var body: some View {
        ZStack(alignment: .topLeading, content: {
            Rectangle()
                .frame(width: Constant.Screen.width * 0.9, height: 200)
                .foregroundStyle(.white)
                .clipShape(.rect(cornerRadius: 20))
                .shadow(color: .black.opacity(0.5), radius: 20, x: -10, y: 10)
            VStack(alignment: .leading, spacing: 0, content: {
                Text(deck.name)
                    .font(.custom(AppFont.mplusBold, size: 36))
                Text(.numberOfCards,": \(deck.cardCount)")
                    .font(.custom(AppFont.mplusBold, size: 14))
                Text(.createdDate,": \(deck.createdDate)")
                    .font(.custom(AppFont.mplusBold, size: 14))
                Text(.lastAccessDate,": \(deck.lastAccessDate)")
                    .font(.custom(AppFont.mplusBold, size: 14))
                Spacer()
                HStack(content: {
                    Spacer()
                    Button(action: {
                        onDelete(deck.id)
                    }, label: {
                        VStack(content: {
                            Image(systemName: "trash.fill")
                                .tint(.red)
                                .font(.title2)
                            Text(.delete)
                                .tint(.red)
                                .font(.custom(AppFont.mplusRegular, size: 12))
                        })
                    })
                })
            })
            .padding()
        })
    }
}

#Preview {
    DeckItem(deck: Deck()) { _ in
        
    }
}
