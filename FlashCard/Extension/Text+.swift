//
//  Text+.swift
//  FlashCard
//
//  Created by tientm on 21/12/2023.
//

import SwiftUI

extension Text {
    
    init(_ localizedString: AppString,_ normalString: String = "") {
        self.init("\(localizedString.rawValue.localized())\(normalString)")
    }
    
    init(_ localizedString: AppString,_ normalString: String = "",_ secondLocalizedString: AppString) {
        self.init("\(localizedString.rawValue.localized())\(normalString)\(secondLocalizedString.rawValue.localized())")
    }
}
