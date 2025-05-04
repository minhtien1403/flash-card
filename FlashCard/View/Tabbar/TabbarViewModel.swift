//
//  TabbarViewModel.swift
//  FlashCard
//
//  Created by tientm on 07/01/2024.
//

import Foundation
import Combine

class TabbarViewModel: ObservableObject {
    
    private var purchaseManager = PurchaseManager.shared
    private var cancellableSet: Set<AnyCancellable> = []
    
    init() {
        NotificationCenter.default.publisher(for: NSUbiquitousKeyValueStore.didChangeExternallyNotification)
            .sink { noti in
                Log.info("Sync state change")
                PersistenceController.shared.updateContainer()
            }
            .store(in: &cancellableSet)
    }
}
