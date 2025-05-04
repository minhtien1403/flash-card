//
//  CDDeck+CoreDataProperties.swift
//  FlashCard
//
//  Created by tientm on 22/12/2023.
//
//

import Foundation
import CoreData


extension CDDeck {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDDeck> {
        return NSFetchRequest<CDDeck>(entityName: "CDDeck")
    }

    @NSManaged public var id: String?
    @NSManaged public var name: String?
    @NSManaged public var createdDate: String?
    @NSManaged public var lastAccessDate: String?

}

extension CDDeck : Identifiable {

    
}
