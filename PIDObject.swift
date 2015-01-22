//
//  PIDObject.swift
//  PIDInventory
//
//  Created by Baker on 1/22/15.
//  Copyright (c) 2015 Umetzu. All rights reserved.
//

import Foundation
import CoreData

class PIDObject: NSManagedObject {
    
    @NSManaged var id: NSNumber
    @NSManaged var pid: String
    @NSManaged var barcode: String
    @NSManaged var gps: String
    @NSManaged var attribute1: String

}
