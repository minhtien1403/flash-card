//
//  Constanst.swift
//  FlashCard
//
//  Created by tientm on 21/12/2023.
//

import SwiftUI

struct Constant {
    
    struct Screen {
        
        static let width: CGFloat = UIScreen.main.bounds.width
        static let height: CGFloat = UIScreen.main.bounds.height
    }
    
    struct Premium {
        
        static let productIds: [AppProduct] = [.monthly, .yearly, .lifeTime]
        static let benefits: [AppString] = [.unlimitedDeck, .unlimitedCard, .syncDataBenefit]
    }
    
}

enum AppProduct: String {
        
    case lifeTime = "com.tientm.flashcard.lifetime.1"
    case monthly = "com.tientm.flashcard.monthly"
    case yearly = "com.tientm.flashcard.dev.yearly"
    
    var text: AppString {
        switch self {
        case .lifeTime:
            return .lifeTimePlan
        case .monthly:
            return .monthlyPlan
        case .yearly:
            return .annualPlan
        }
    }
    
    var note: AppString {
        switch self {
        case .lifeTime:
            return .lifeTimePlanNote
        case .monthly:
            return .monthlyPlanNote
        case .yearly:
            return .annualPlanNote
        }
    }
}
