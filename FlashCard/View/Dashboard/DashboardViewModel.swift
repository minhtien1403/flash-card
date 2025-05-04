//
//  DashboardViewModel.swift
//  FlashCard
//
//  Created by tientm on 22/12/2023.
//

import Combine
import CoreData
final class DashboardViewModel: ObservableObject {
    
    enum DashboardViewState {
        
        case isLoading ,errorLoaded, loaded
    }
    
    @Published var decks: [Deck] = []
    @Published var state: DashboardViewState = .isLoading
    private let deckRepo: DeckRepositoryProtocol
    private var cardRepo: CardRepositoryProtocol
    private var cancellableSet: Set<AnyCancellable> = []
    
    init(deckRepo: DeckRepositoryProtocol = DeckRepository.shared, cardRepo: CardRepositoryProtocol = CardRepository.shared) {
        self.deckRepo = deckRepo
        self.cardRepo = cardRepo
        setupNotification()
    }
    
    var hasUnlockedPro: Bool {
        return !PurchaseManager.shared.hasUnlockedPro
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
    
    private func setupNotification() {
        NotificationCenter.default.publisher(for: NSPersistentCloudKitContainer.eventChangedNotification)
            .sink(receiveValue: { [weak self] notification in
                if let cloudEvent = notification.userInfo?[NSPersistentCloudKitContainer.eventNotificationUserInfoKey]
                    as? NSPersistentCloudKitContainer.Event {
                    // NSPersistentCloudKitContainer sends a notification when an event starts, and another when it
                    // ends. If it has an endDate, it means the event finished.
                    if cloudEvent.endDate == nil {
                        Log.info("Starting an event...") // You could check the type, but I'm trying to keep this brief.
                    } else {
                        switch cloudEvent.type {
                        case .setup:
                            Log.info("Setup finished!")
                        case .import:
                            Log.info("An import finished!")
                        case .export:
                            Log.info("An export finished!")
                        @unknown default:
                            assertionFailure("NSPersistentCloudKitContainer added a new event type.")
                        }

                        if cloudEvent.succeeded {
                            Log.info("And it succeeded!")
                            self?.getAllDecks()
                        } else {
                            Log.info("But it failed!")
                        }

                        if let error = cloudEvent.error {
                            Log.info("Error: \(error.localizedDescription)")
                        }
                    }
                }
            })
            .store(in: &cancellableSet)
    }
    
    func addDeck(deck: Deck) {
        deckRepo.add(deck: deck)
            .sink(receiveCompletion: handleFailure()) { [weak self] _ in
                self?.decks.append(deck)
            }
            .store(in: &cancellableSet)
    }
    
    func getAllDecks() {
        deckRepo.list()
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: handleFailure()) { [weak self] decks in
                Log.info("get decks success")
                self?.decks = decks
                self?.getDeckCount()
            }
            .store(in: &cancellableSet)
    }
    
    private func getDeckCount() {
        for index in 0..<decks.count {
            cardRepo.list(by: decks[index].id)
                .receive(on: RunLoop.main)
                .sink(receiveCompletion: handleFailure()) { [weak self] cards in
                    self?.decks[index].cardCount = cards.count
                }
                .store(in: &cancellableSet)
        }
    }
    
    func deleteDeck(by id: String) {
        deckRepo.delete(byID: id)
            .sink(receiveCompletion: handleFailure()) { [weak self] deck in
                Log.info("Delete deck: \(deck?.id ?? "nil") success")
                self?.decks.removeAll { $0.id == deck?.id }
            }
            .store(in: &cancellableSet)
        cardRepo.delete(bydeckID: id)
            .sink(receiveCompletion: handleFailure()) { _ in
                Log.info("Delete all card of deck : \(id)")
            }
            .store(in: &cancellableSet)
    }
    
    func updateDeck(deck: Deck) {
        
    }
}
