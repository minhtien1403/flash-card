//
//  Destination.swift
//  FlashCard
//
//  Created by tientm on 19/12/2023.
//

import SwiftUI

enum Destination: Hashable, Equatable {
    
    case tabbar
    case dashboard
    case setting
    case languageSetting
    case cardList(deckID: String)
    case quizz(deckID: String, numberOfQuizz: Int)
    case syncData
    case purchase
    
    var view: AnyView {
        switch self {
        case .tabbar:
            return TabbarView().toAnyView()
        case .dashboard:
            return DashboardView().toAnyView()
        case .setting:
            return SettingView().toAnyView()
        case .languageSetting:
            return LanguageSettingView().toAnyView()
        case .cardList(deckID: let deckID):
            return CardListView(deckID: deckID).toAnyView()
        case .quizz(deckID: let deckID, numberOfQuizz: let numberOfQuizz):
            return QuizzView(viewModel: QuizzViewModel(deckID: deckID, numberOfQuestion: numberOfQuizz)).toAnyView()
        case .syncData:
            return SyncDataView().toAnyView()
        case .purchase:
            return PremiumPurchaseView().toAnyView()
        }
    }
}

extension Destination: Identifiable {
    
    var id: String { UUID().uuidString }
    
    func hash(into hasher: inout Hasher) {
        return hasher.combine(id)
    }
    
    static func == (lhs: Destination, rhs: Destination) -> Bool {
        lhs.hashValue == rhs.hashValue
    }
}
