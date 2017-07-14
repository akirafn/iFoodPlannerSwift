//
//  Item+CoreDataProperties.swift
//  iFoodPlannerSwift
//
//  Created by Flavio Akira Nakahara on 7/14/17.
//  Copyright © 2017 Flavio Akira Nakahara. All rights reserved.
//

import Foundation
import CoreData


extension Item {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Item> {
        return NSFetchRequest<Item>(entityName: "Item")
    }

    @NSManaged public var itemId: Int32
    @NSManaged public var nome: String?
    @NSManaged public var receita: NSSet?

}

// MARK: Generated accessors for receita
extension Item {

    @objc(addReceitaObject:)
    @NSManaged public func addToReceita(_ value: ItemReceita)

    @objc(removeReceitaObject:)
    @NSManaged public func removeFromReceita(_ value: ItemReceita)

    @objc(addReceita:)
    @NSManaged public func addToReceita(_ values: NSSet)

    @objc(removeReceita:)
    @NSManaged public func removeFromReceita(_ values: NSSet)

}
