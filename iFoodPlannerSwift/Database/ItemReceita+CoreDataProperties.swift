//
//  ItemReceita+CoreDataProperties.swift
//  iFoodPlannerSwift
//
//  Created by Flavio Akira Nakahara on 7/14/17.
//  Copyright © 2017 Flavio Akira Nakahara. All rights reserved.
//

import Foundation
import CoreData


extension ItemReceita {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ItemReceita> {
        return NSFetchRequest<ItemReceita>(entityName: "ItemReceita")
    }

    @NSManaged public var itemId: Int32
    @NSManaged public var medida: String?
    @NSManaged public var quatidade: Int32
    @NSManaged public var receitaId: Int32
    @NSManaged public var receita: Receita?
    @NSManaged public var ingrediente: Item?

}
