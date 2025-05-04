//
//  AppString.swift
//  FlashCard
//
//  Created by tientm on 21/12/2023.
//

import SwiftUI

enum AppString: String, Identifiable {
    
    var id: String { self.rawValue }
    
    case numberOfCards
    case createdDate
    case lastAccessDate
    case english
    case vietnamese
    case dashboardTabTitle
    case settingTabTitle
    case delete
    case quizz
    case language
    case feedback
    case emptyDeckMessage
    case addNewDeck
    case addNewCard
    case editCardContent
    case enterDeckName
    case cancelButton
    case createButton
    case confirmDeleteDeck
    case confirmDeleteCard
    case addCard
    case editCard
    case enterFrontCard
    case enterBackCard
    case notCreateAnyCardYet
    case done
    case syncData
    case purchasePro
    case restorePurchase
    case support
    case answerQuizzMessage
    case finish
    case great
    case practiceMore
    case welldone
    case resultMessage
    case finishQuizzesMessage
    case createQuizzMessage
    case checkIcloudStatus
    case syncViaIcloud
    case couldNotDetermine
    case available
    case restricted
    case noAccount
    case temporarilyUnavailable
    case speakButton
    case subcribePremium
    case continuePurchase
    case unlimitedDeck
    case unlimitedCard
    case syncDataBenefit
    case monthlyPlan
    case annualPlan
    case lifeTimePlan
    case monthlyPlanNote
    case annualPlanNote
    case lifeTimePlanNote
    case privacyPolicy
    case termOfServices
    case unlockPremiumMessage
    case unlockPremiumForMoreDeck
    case unlockPremiumForMoreCard
}
