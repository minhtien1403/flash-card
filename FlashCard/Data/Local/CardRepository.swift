//
//  CardRepository.swift
//  FlashCard
//
//  Created by tientm on 24/12/2023.
//

import Combine
import CoreData

protocol CardRepositoryProtocol {
    
    func list(by deckID: String) -> AnyPublisher<[Card], CoreDataError>
    func add(card: Card) -> AnyPublisher<Void, CoreDataError>
    func delete(byID id: String) -> AnyPublisher<Card?, CoreDataError>
    func delete(bydeckID deckID: String) -> AnyPublisher<Void, CoreDataError>
    func update(_ card: Card) -> AnyPublisher<Void, CoreDataError>
}

struct CardRepository: CardRepositoryProtocol {
    
    private let viewContext = PersistenceController.shared.container.viewContext
    static let shared = CardRepository()
    
    private init() {}
    
    func list(by deckID: String) -> AnyPublisher<[Card], CoreDataError> {
        let fetchRequest: NSFetchRequest<CDCard> = CDCard.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "deckID = %@", deckID)
        return Future<[Card], CoreDataError> { promise in
            do {
                let cdCards = try self.viewContext.fetch(fetchRequest)
                let cards = cdCards.compactMap { Card(entity: $0) }
                promise(.success(cards))
            } catch {
                promise(.failure(CoreDataError.saveError(error)))
            }
        }
        .eraseToAnyPublisher()
    }
    
    func delete(bydeckID deckID: String) -> AnyPublisher<Void, CoreDataError> {
        let fetchRequest: NSFetchRequest<CDCard> = CDCard.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "deckID = %@", deckID)
        return Future<Void, CoreDataError> { promise in
            do {
                let cdCards = try self.viewContext.fetch(fetchRequest)
                for cdCard in cdCards {
                    viewContext.delete(cdCard)
                    try viewContext.save()
                }
                promise(.success(()))
            } catch {
                promise(.failure(CoreDataError.saveError(error)))
            }
        }
        .eraseToAnyPublisher()
    }
    
    func add(card: Card) -> AnyPublisher<Void, CoreDataError> {
        return Future<Void, CoreDataError> { promise in
            let newCdCard = CDCard(context: viewContext)
            do {
                card.map(to: newCdCard)
                Log.info("Add new card: \(newCdCard.id ?? "nil")")
                try viewContext.save()
                promise(.success(()))
            } catch {
                promise(.failure(CoreDataError.saveError(error)))
            }
        }
        .eraseToAnyPublisher()
    }
    
    func delete(byID id: String) -> AnyPublisher<Card?, CoreDataError> {
        let fetchRequest: NSFetchRequest<CDCard> = CDCard.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", id)
        return Future<Card?, CoreDataError> { promise in
            do {
                let cdCards = try self.viewContext.fetch(fetchRequest)
                guard let cdCard = cdCards.first else {
                    promise(.success(nil)) // User not found
                    return
                }
                let deleteCard = Card(entity: cdCard) // Keep a reference to the deleted user
                self.viewContext.delete(cdCard)
                try self.viewContext.save()
                promise(.success(deleteCard))
            } catch {
                promise(.failure(CoreDataError.saveError(error)))
            }
        }
        .eraseToAnyPublisher()
    }
    
    func update(_ card: Card) -> AnyPublisher<Void, CoreDataError> {
        return Future<Void, CoreDataError> { promise in
            do {
                let fetchRequest: NSFetchRequest<CDCard> = CDCard.fetchRequest()
                fetchRequest.predicate = NSPredicate(format: "id == %@", card.id)
                Log.info("Fetch card with id: \(card.id)")
                let cdCards = try self.viewContext.fetch(fetchRequest)
                guard let cdCard = cdCards.first else {
                    // Handle the case where the user with the specified ID is not found.
                    promise(.failure(CoreDataError.userNotFound))
                    return
                }
                // Update the CDUser with values from the User model
                card.map(to: cdCard)
                try self.viewContext.save()
                promise(.success(()))
            } catch {
                promise(.failure(CoreDataError.saveError(error)))
            }
        }
        .eraseToAnyPublisher()
    }
}
