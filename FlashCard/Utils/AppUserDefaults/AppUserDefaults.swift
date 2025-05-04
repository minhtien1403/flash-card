//
//  AppUserDefaults.swift
//  FlashCard
//
//  Created by tientm on 21/12/2023.
//

import Foundation

protocol AppUserDefaultsProtocol {
    
    var language: Language { get set }
    var icloud: Bool { get set }
}

struct AppUserDefaults: AppUserDefaultsProtocol {
    
    static let shared = AppUserDefaults()
        
    private init() {}
    
    private let userDefaults: UserDefaults = .standard
    
    var language: Language {
        get {
            guard let languageString = userDefaults.string(forKey: .language) else {
                return .english
            }
            return Language(rawValue: languageString) ?? .english
        }
        set {
            userDefaults.setValue(newValue.rawValue, forKey: .language)
            Log.info("set language: \(newValue.rawValue)")

        }
    }
    
    var icloud: Bool {
        get {
            userDefaults.bool(forKey: .icloud)
        }
        set {
            userDefaults.setValue(newValue, forKey: .icloud)
        }
    }
}

enum AppUserDefaultsKey {
    
    case language
    case icloud
    
    var value: String {
        switch self {
        case .language:
            return "app_language"
        case .icloud:
            return "icloud"
        }
    }
}

extension UserDefaults {
    
    func string(forKey key: AppUserDefaultsKey) -> String? {
        self.string(forKey: key.value)
    }
    
    func bool(forKey key: AppUserDefaultsKey) -> Bool {
        self.bool(forKey: key.value)
    }
    
    func setValue(_ value: Any?, forKey key: AppUserDefaultsKey) {
        self.setValue(value, forKey: key.value)
    }
}
