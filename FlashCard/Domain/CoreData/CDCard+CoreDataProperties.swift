//
//  CDCard+CoreDataProperties.swift
//  FlashCard
//
//  Created by tientm on 22/12/2023.
//
//

import Foundation
import CoreData


extension CDCard {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDCard> {
        return NSFetchRequest<CDCard>(entityName: "CDCard")
    }

    @NSManaged public var id: String?
    @NSManaged public var front: String?
    @NSManaged public var back: String?
    @NSManaged public var deckID: String?

}

extension CDCard : Identifiable {

}
