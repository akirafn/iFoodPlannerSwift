//
//  Receita+CoreDataProperties.swift
//  iFoodPlannerSwift
//
//  Created by Flavio Akira Nakahara on 7/14/17.
//  Copyright © 2017 Flavio Akira Nakahara. All rights reserved.
//

import Foundation
import CoreData


extension Receita {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Receita> {
        return NSFetchRequest<Receita>(entityName: "Receita")
    }

    @NSManaged public var procedimento: String?
    @NSManaged public var receitaId: Int32
    @NSManaged public var titulo: String?
    @NSManaged public var ingrediente: NSSet?

}

// MARK: Generated accessors for ingrediente
extension Receita {

    @objc(addIngredienteObject:)
    @NSManaged public func addToIngrediente(_ value: ItemReceita)

    @objc(removeIngredienteObject:)
    @NSManaged public func removeFromIngrediente(_ value: ItemReceita)

    @objc(addIngrediente:)
    @NSManaged public func addToIngrediente(_ values: NSSet)

    @objc(removeIngrediente:)
    @NSManaged public func removeFromIngrediente(_ values: NSSet)

}
