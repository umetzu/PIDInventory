//
//  PIDInventory.swift
//  PIDInventory
//
//  Created by Baker on 1/30/15.
//  Copyright (c) 2015 Umetzu. All rights reserved.
//

import Foundation
import CoreData

class PIDInsert: NSManagedObject {

    @NSManaged var id: Int32
    @NSManaged var name: String
    @NSManaged var barcode: String

}
