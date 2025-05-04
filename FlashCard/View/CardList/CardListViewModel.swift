//
//  CardListViewModel.swift
//  FlashCard
//
//  Created by tientm on 24/12/2023.
//

import Combine
import Foundation

final class CardListViewModel: ObservableObject {
    
    enum CardListViewState {
        
        case isLoading ,errorLoaded, loaded, updating
    }
    
    @Published var cards: [Card] = []
    @Published var state: CardListViewState = .isLoading
    private var cardRepo: CardRepositoryProtocol
    private var deckRepo: DeckRepositoryProtocol
    private var cancellableSet: Set<AnyCancellable> = []
    private var deckID: String
    private var previoursCard: [Card] = []
    
    var hasUnlockedPro: Bool {
        return !PurchaseManager.shared.hasUnlockedPro
    }
    
    init(cardRepo: CardRepositoryProtocol = CardRepository.shared,
         deckRepo: DeckRepositoryProtocol = DeckRepository.shared,
         deckID: String) {
        self.cardRepo = cardRepo
        self.deckRepo = deckRepo
        self.deckID = deckID
        Log.info("init view model")
    }
    
    private func handleFailure() -> ((Subscribers.Completion<CoreDataError>) -> Void) {
        return { [weak self] completion in
            switch completion {
            case .finished:
                break
            case .failure(let error):
                Log.warning(error.localizedDescription)
                self?.state = .errorLoaded
            }
        }
    }
    
    func getDeckID() -> String {
        deckID
    }
    
    func getAllCard() {
        Log.info("deckID: \(deckID)")
        cardRepo.list(by: deckID)
            .sink(receiveCompletion: handleFailure()) { [weak self] cards in
                Log.info("Get all card success")
                self?.cards = cards
                self?.previoursCard = cards
                self?.state = .loaded
                self?.updateDeck()
            }
            .store(in: &cancellableSet)
    }
    
    func addCard(_ front: String,_ back: String) {
        let card = Card(deckID: deckID, front: front, back: back)
        cardRepo.add(card: card)
            .sink(receiveCompletion: handleFailure()) { [weak self] _ in
                self?.cards.append(card)
                self?.previoursCard.append(card)
            }
            .store(in: &cancellableSet)
    }
    
    func updateCard(card: Card) {
        state = .updating
        cardRepo.update(card)
            .sink(receiveCompletion: handleFailure()) { [weak self] _ in
                for index in 0..<(self?.cards.count ?? 0) {
                    if card.id == self?.cards[index].id {
                        self?.cards[index] = card
                        self?.cards[index] = card
                        self?.state = .loaded
                    }
                }
            }
            .store(in: &cancellableSet)
    }
    
    func deleteCard(card: Card, onSuccess: @escaping () -> Void) {
        cardRepo.delete(byID: card.id)
            .sink(receiveCompletion: handleFailure()) { [weak self] card in
                self?.cards.removeAll(where: { $0 == card })
                self?.previoursCard.removeAll(where: { $0 == card })
                onSuccess()
            }
            .store(in: &cancellableSet)
    }
    
    func updateDeck() {
        deckRepo.get(by: deckID)
            .sink(receiveCompletion: handleFailure()) { [weak self] deck in
                var newDeck = deck
                newDeck.lastAccessDate = Date().toString()
                self?.updateLastAccessDate(deck: newDeck)
            }
            .store(in: &cancellableSet)
    }
    
    private func updateLastAccessDate(deck: Deck) {
        deckRepo.update(deck)
            .sink(receiveCompletion: handleFailure()) { _ in
                Log.info("Update deck last access date success")
            }
            .store(in: &cancellableSet)
    }
    
    func restoreCardState(card: Card) {
        state = .updating
        for index in 0..<cards.count {
            if card.id == previoursCard[index].id {
                cards[index] = previoursCard[index]
                state = .loaded
            }
        }
    }
}
