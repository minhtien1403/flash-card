//
//  Persistence.swift
//  FlashCard
//
//  Created by tientm on 19/12/2023.
//

import CoreData

class PersistenceController {
    
    static let shared = PersistenceController()
    private let appName = "FlashCard"
    private var model: NSManagedObjectModel?
    
    lazy var container: NSPersistentContainer = {
        setupContainer()
    }()

    private init() {}
    
    private func model(name: String) throws -> NSManagedObjectModel {
        if model == nil {
            model = try loadModel(name: name, bundle: Bundle.main)
        }
        return model!
    }
    
    private func loadModel(name: String, bundle: Bundle) throws -> NSManagedObjectModel {
        guard let modelURL = bundle.url(forResource: name, withExtension: "momd") else {
            throw CoreDataModelError.modelURLNotFound(forResourceName: name)
        }
        
        guard let model = NSManagedObjectModel(contentsOf: modelURL) else {
            throw CoreDataModelError.modelLoadingFailed(forURL: modelURL)
        }
        return model
    }
    
    func setupContainer() -> NSPersistentContainer {
        let icloudSync = NSUbiquitousKeyValueStore.default.bool(forKey: "icloud_sync")
        Log.info("Setup container with state = \(icloudSync)")
        let container = NSPersistentCloudKitContainer(name: "FlashCard")
        guard let description = container.persistentStoreDescriptions.first else {
            fatalError("###\(#function): Failed to retrieve a persistent store description.")
        }
        
        description.setOption(true as NSNumber, forKey: NSPersistentHistoryTrackingKey)
        if(!icloudSync){
              description.cloudKitContainerOptions = nil
          }
        
        let remoteChangeKey = "NSPersistentStoreRemoteChangeNotificationOptionKey"
        description.setOption(true as NSNumber,
                              forKey: remoteChangeKey)
        
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
        return container
    }
    
    func updateContainer() {
        self.container = setupContainer()
        fetchAllItem()
    }
    
    func fetchAllItem() {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "CDDeck")
        do {
            try container.viewContext.fetch(fetchRequest)
            try container.viewContext.save()
        } catch {
            Log.warning("fetch all item error")
        }
    }
}

enum CoreDataError: Error {
    
    case selfDeallocated
    case userNotFound
    case saveError(Error)
}

enum CoreDataModelError: Error {
    case modelURLNotFound(forResourceName: String)
    case modelLoadingFailed(forURL: URL)
}
