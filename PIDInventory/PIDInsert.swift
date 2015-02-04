//
//  PIDInventory.swift
//  PIDInventory
//
//  Created by Baker on 2/2/15.
//  Copyright (c) 2015 Umetzu. All rights reserved.
//

import Foundation
import CoreData

struct PIDInsertName {
    static let name = "PIDInsert"
    static let id = "id"
    static let insertName = "name"
    static let insertBarcode = "barcode"
    static let insertCategory = "category"
    static let insertDate = "date"
    
}

class PIDInsert: NSManagedObject {

    @NSManaged var barcode: String
    @NSManaged var id: Int32
    @NSManaged var name: String
    @NSManaged var date: String
    @NSManaged var category: String

}
