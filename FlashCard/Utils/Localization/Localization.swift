//
//  Localization.swift
//  FlashCard
//
//  Created by tientm on 21/12/2023.
//

import SwiftUI

class LocalizationServices: ObservableObject {
    
    static let shared = LocalizationServices()
    private var appUserDefault = AppUserDefaults.shared
    
    @Published private var language: Language

    
    private init() {
        language = appUserDefault.language
        Log.info("Current language: \(appUserDefault.language.rawValue)")
    }
    
    func getCurrentLanguage() -> Language {
        language
    }
    
    func setNewLanguage(_ newLanguage: Language) {
        if newLanguage != language {
            language = newLanguage
            appUserDefault.language = newLanguage
        }
    }
}
