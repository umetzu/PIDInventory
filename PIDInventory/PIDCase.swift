//
//  PIDInventory.swift
//  PIDInventory
//
//  Created by Baker on 2/2/15.
//  Copyright (c) 2015 Umetzu. All rights reserved.
//

import Foundation
import CoreData

class PIDCase: NSManagedObject {

    @NSManaged var inventoryCaseBarcode: String
    @NSManaged var caseBroken: Bool
    @NSManaged var caseColor: String
    @NSManaged var caseSeverity: String
    @NSManaged var caseGraffiti: Bool
    @NSManaged var caseOther: Bool
    @NSManaged var caseRusted: Bool
    @NSManaged var inventoryComments: String
    @NSManaged var coverSeverity: String
    @NSManaged var coverCracked: Bool
    @NSManaged var coverDiscolored: Bool
    @NSManaged var coverGraffiti: Bool
    @NSManaged var coverNoCover: Bool
    @NSManaged var coverOther: Bool
    @NSManaged var id: Int32
    @NSManaged var inventoryInsertBarcode: String
    @NSManaged var insertComments: String
    @NSManaged var insertFaded: Bool
    @NSManaged var insertMissing: Bool
    @NSManaged var insertName: Int32
    @NSManaged var insertOther: Bool
    @NSManaged var insertTorn: Bool
    @NSManaged var inventoryLatitude: Double
    @NSManaged var inventoryLongitude: Double
    @NSManaged var standBroken: Bool
    @NSManaged var standSeverity: String
    @NSManaged var standGraffiti: Bool
    @NSManaged var standOther: Bool
    @NSManaged var standRusted: Bool
    @NSManaged var standRustedBasePlate: Bool
    @NSManaged var inventoryDate: NSTimeInterval
    @NSManaged var inventoryCaseNameArchive: String
    @NSManaged var locationDescription: String
    @NSManaged var locationOrientation: String
    @NSManaged var locationAdjacentTVM: Bool
    @NSManaged var locationMountType: String
    @NSManaged var caseWidth: Double
    @NSManaged var caseSide: Int32
    @NSManaged var insertCategory: String
    @NSManaged var locationCasesInCluster: Int32
    @NSManaged var locationPositionInCluster: Int32
    @NSManaged var inventoryUser: String
    @NSManaged var inventoryPhoto1: String
    @NSManaged var inventoryPhoto2: String
    @NSManaged var insertDate: NSTimeInterval
    @NSManaged var insertWaterDamage: Bool

}
