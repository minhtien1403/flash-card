//
//  FlashCardApp.swift
//  FlashCard
//
//  Created by tientm on 19/12/2023.
//

import SwiftUI
import Combine

@main
struct FlashCardApp: App {
    
    @StateObject var languageSetting = LocalizationServices.shared
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            TabbarView()
                .environmentObject(languageSetting)
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
