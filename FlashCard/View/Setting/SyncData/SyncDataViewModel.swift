//
//  SyncDataViewModel.swift
//  FlashCard
//
//  Created by tientm on 05/01/2024.
//

import Combine
import CloudKit
import CoreData

class SyncDataViewModel: ObservableObject {
    
    enum SyncDataViewState {
        case checkingIcouldAccountStatus
        case changeSyncState
        case loaded
    }
    
    @Published private(set) var accountStatus: CKAccountStatus = .couldNotDetermine
    @Published var viewState: SyncDataViewState = .checkingIcouldAccountStatus
    @Published var icloudSync: Bool = NSUbiquitousKeyValueStore.default.bool(forKey: "icloud_sync")
    private var cancellableSet: Set<AnyCancellable> = []
    
    init() {
        setupObserver()
    }
    
    @MainActor
    func fetchAccountStatus() async {
        do {
            viewState = .checkingIcouldAccountStatus
            accountStatus = try await CKContainer.default().accountStatus()
            viewState = .loaded
        } catch {
            viewState = .loaded
            Log.warning("Get Icloud account status error")
        }
    }
    
    func changeSyncStatus(sync: Bool) {
        viewState = .changeSyncState
        NSUbiquitousKeyValueStore.default.set(sync, forKey: "icloud_sync")
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.viewState = .loaded
            self.icloudSync = sync
            PersistenceController.shared.updateContainer()
        }
    }

    func setupObserver() {
        NotificationCenter.default.publisher(for: NSUbiquitousKeyValueStore.didChangeExternallyNotification)
            .sink { [weak self] noti in
                Log.info("Change switch state to: \(NSUbiquitousKeyValueStore.default.bool(forKey: "icloud_sync"))")
                DispatchQueue.main.async {
                    self?.icloudSync = NSUbiquitousKeyValueStore.default.bool(forKey: "icloud_sync")
                }
            }
            .store(in: &cancellableSet)
    }
}
