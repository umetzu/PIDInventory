//
//  PIDInventory.swift
//  PIDInventory
//
//  Created by Baker on 2/2/15.
//  Copyright (c) 2015 Umetzu. All rights reserved.
//

import Foundation
import CoreData

class PIDInsert: NSManagedObject {

    @NSManaged var barcode: String
    @NSManaged var id: Int32
    @NSManaged var name: String
    @NSManaged var date: NSTimeInterval
    @NSManaged var category: String

}
