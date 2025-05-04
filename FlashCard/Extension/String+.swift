//
//  String+.swift
//  FlashCard
//
//  Created by tientm on 21/12/2023.
//

import Foundation

extension String {
    
    func localized() -> String {
        let path = Bundle.main.path(forResource: AppUserDefaults.shared.language.rawValue, ofType: "lproj")
        let bundle: Bundle
        if let path = path {
            bundle = Bundle(path: path) ?? .main
        } else {
            bundle = .main
        }
        return self.localized(bundle: bundle)
    }
    
    func localized(bundle: Bundle) -> String {
        return NSLocalizedString(self, tableName: nil, bundle: bundle, value: "", comment: "")
    }
}

enum Language: String, CaseIterable {
    
    case vietnamese = "vi"
    case english = "en"
}
