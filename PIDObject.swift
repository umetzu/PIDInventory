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
    
    @NSManaged var barcode: String
    @NSManaged var caseBent: Bool
    @NSManaged var caseBroken: Bool
    @NSManaged var caseColor: Int32
    @NSManaged var caseComingApart: Bool
    @NSManaged var caseCondition: Int32
    @NSManaged var caseGraffiti: Bool
    @NSManaged var caseOther: Bool
    @NSManaged var casePitted: Bool
    @NSManaged var caseRusted: Bool
    @NSManaged var caseUnauthorized: Bool
    @NSManaged var comments: String
    @NSManaged var coverCondition: Int32
    @NSManaged var coverCracked: Bool
    @NSManaged var coverDiscolored: Bool
    @NSManaged var coverGraffiti: Bool
    @NSManaged var coverNoCover: Bool
    @NSManaged var coverOther: Bool
    @NSManaged var coverUnauthorized: Bool
    @NSManaged var latitude: Double
    @NSManaged var id: Int32
    @NSManaged var insertCondition: Int32
    @NSManaged var insertDescription: String
    @NSManaged var insertFaded: Bool
    @NSManaged var insertMissing: Bool
    @NSManaged var insertOther: Bool
    @NSManaged var insertTorn: Bool
    @NSManaged var pid: String
    @NSManaged var standBroken: Bool
    @NSManaged var standCondition: Int32
    @NSManaged var standGraffiti: Bool
    @NSManaged var standOther: Bool
    @NSManaged var standRusted: Bool
    @NSManaged var standRustedBasePlate: Bool
    @NSManaged var standUnauthorized: Bool
    @NSManaged var longitude: Double

}
