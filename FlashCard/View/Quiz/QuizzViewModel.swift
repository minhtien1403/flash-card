//
//  QuizViewModel.swift
//  FlashCard
//
//  Created by tientm on 02/01/2024.
//

import Combine

final class QuizzViewModel: ObservableObject {
    
    private var deckID: String
    private var numberOfQuestion: Int
    private var cardRepo: CardRepositoryProtocol = CardRepository.shared
    @Published var quizzList: [Quizz] = []
    private var cancellableSet: Set<AnyCancellable> = []
    
    
    init(deckID: String, numberOfQuestion: Int) {
        self.deckID = deckID
        self.numberOfQuestion = numberOfQuestion
    }
    
    private func handleFailure() -> ((Subscribers.Completion<CoreDataError>) -> Void) {
        return { completion in
            switch completion {
            case .finished:
                break
            case .failure(let error):
                Log.warning(error.localizedDescription)
            }
        }
    }
    
    func getListCard() {
        cardRepo.list(by: deckID)
            .sink(receiveCompletion: handleFailure()) { [weak self] cards in
                self?.genarateRandomQuizzList(cards: cards)
            }
            .store(in: &cancellableSet)
    }
    
    func calculateQuizzResult() -> (Int, Int) {
        var result = 0
        for quizz in quizzList {
            if quizz.listAnswer[safe: quizz.selectedAnswer] == quizz.rightAnswer {
                result += 1
            }
        }
        return (result, quizzList.count)
    }
    
    private func genarateRandomQuizzList(cards: [Card]) {
        var quizzList: [Quizz] = []
        var usedCardIndexes: Set<Int> = []
        for _ in 1...numberOfQuestion {
            // Get a random card that hasn't been used in a quiz
            let availableCards = cards.filter { !usedCardIndexes.contains(cards.firstIndex(of: $0) ?? 0) }
            guard let randomCard = availableCards.randomElement() else {
                break // Break if no more available cards
            }
            // Use the front of the card as the question (quizz)
            var quizz = Quizz(quizz: randomCard.front, rightAnswer: randomCard.back, listAnswer: [])
            // Get random cards (excluding the current card) for anotherAnswer
            var availableAnswer = cards.filter { $0.id != randomCard.id }
            availableAnswer.shuffle()
            // Take a random number of cards (e.g., 2)  for anotherAnswer
            var anotherAnswer = availableAnswer.prefix(3).map { $0.back }
            anotherAnswer.append(randomCard.back)
            anotherAnswer.shuffle()
            quizz.listAnswer = anotherAnswer
            if let indexOfRandomCard = cards.firstIndex(of: randomCard) {
                usedCardIndexes.insert(indexOfRandomCard)
            }
            quizzList.append(quizz)
        }
        self.quizzList = quizzList
        Log.info("Quizz List")
        Log.info("=============================")
        for quizz in quizzList {
            Log.info(quizz.quizz)
            Log.info(quizz.rightAnswer)
            Log.info(quizz.listAnswer.joined(separator: "-"))
            Log.info("=============================")
        }
    }
}

struct Quizz {
    
    var quizz: String
    var rightAnswer: String
    var listAnswer: [String]
    var selectedAnswer: Int = -1
}
