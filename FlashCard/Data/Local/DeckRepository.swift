//
//  DeckRepository.swift
//  FlashCard
//
//  Created by tientm on 22/12/2023.
//

import Combine
import CoreData

protocol DeckRepositoryProtocol {
    
    func list() -> AnyPublisher<[Deck], CoreDataError>
    func get(by id: String) -> AnyPublisher<Deck, CoreDataError>
    func add(deck: Deck) -> AnyPublisher<Void, CoreDataError>
    func delete(byID id: String) -> AnyPublisher<Deck?, CoreDataError>
    func update(_ deck: Deck) -> AnyPublisher<Void, CoreDataError>
}

struct DeckRepository: DeckRepositoryProtocol {
    
    private let viewContext = PersistenceController.shared.container.viewContext
    static let shared = DeckRepository()
    
    private init() {}
    
    func list() -> AnyPublisher<[Deck], CoreDataError> {
        let fetchRequest: NSFetchRequest<CDDeck> = CDDeck.fetchRequest()
        return Future<[Deck], CoreDataError> { promise in
            do {
                let cdDecks = try self.viewContext.fetch(fetchRequest)
                let decks = cdDecks.compactMap { Deck(entity: $0) }
                promise(.success(decks))
            } catch {
                promise(.failure(CoreDataError.saveError(error)))
            }
        }
        .eraseToAnyPublisher()
    }
    
    func get(by id: String) -> AnyPublisher<Deck, CoreDataError> {
        let fetchRequest: NSFetchRequest<CDDeck> = CDDeck.fetchRequest()
        return Future<Deck, CoreDataError> { promise in
            do {
                let cdDecks = try self.viewContext.fetch(fetchRequest)
                let decks = cdDecks.compactMap { Deck(entity: $0) }
                let deck = decks.first {
                    $0.id == id
                }
                guard let nonOptionalDeck = deck else {
                    promise(.failure(CoreDataError.userNotFound))
                    return
                }
                promise(.success(nonOptionalDeck))
            } catch {
                promise(.failure(CoreDataError.saveError(error)))
            }
        }
        .eraseToAnyPublisher()
    }
    
    func add(deck: Deck) -> AnyPublisher<Void, CoreDataError> {
        return Future<Void, CoreDataError> { promise in
            let newCdDeck = CDDeck(context: viewContext)
            deck.map(to: newCdDeck)
            do {
                try viewContext.save()
                promise(.success(()))
            } catch {
                promise(.failure(CoreDataError.saveError(error)))
            }
        }
        .eraseToAnyPublisher()
    }
    
    func delete(byID id: String) -> AnyPublisher<Deck?, CoreDataError> {
        let fetchRequest: NSFetchRequest<CDDeck> = CDDeck.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", id)
        return Future<Deck?, CoreDataError> { promise in
            do {
                let cdDecks = try self.viewContext.fetch(fetchRequest)
                guard let cdDeck = cdDecks.first else {
                    promise(.success(nil)) // User not found
                    return
                }
                let deletedDeck = Deck(entity: cdDeck) // Keep a reference to the deleted user
                self.viewContext.delete(cdDeck)
                try self.viewContext.save()
                promise(.success(deletedDeck))
            } catch {
                promise(.failure(CoreDataError.saveError(error)))
            }
        }
        .eraseToAnyPublisher()
    }
    
    func update(_ deck: Deck) -> AnyPublisher<Void, CoreDataError> {
        return Future<Void, CoreDataError> { promise in
            do {
                let fetchRequest: NSFetchRequest<CDDeck> = CDDeck.fetchRequest()
                fetchRequest.predicate = NSPredicate(format: "id == %@", deck.id)
                let cdDecks = try self.viewContext.fetch(fetchRequest)
                guard let cdDeck = cdDecks.first else {
                    // Handle the case where the user with the specified ID is not found.
                    promise(.failure(CoreDataError.userNotFound))
                    return
                }
                // Update the CDUser with values from the User model
                deck.map(to: cdDeck)
                try self.viewContext.save()
                promise(.success(()))
            } catch {
                promise(.failure(CoreDataError.saveError(error)))
            }
        }
        .eraseToAnyPublisher()
    }
}
