//
//  PIDInventory.swift
//  PIDInventory
//
//  Created by Baker on 2/2/15.
//  Copyright (c) 2015 Umetzu. All rights reserved.
//

import Foundation
import CoreData

struct PIDCaseName {
    static let name = "PIDCase"
    static let id = "id"
    static let caseBarcode = "inventoryCaseBarcode"
    static let latitude = "inventoryLatitude"
    static let longitude = "inventoryLongitude"
    static let stationCode = "inventoryStationCode"
    static let modified = "inventoryModified"
}

class PIDCase: NSManagedObject {

    @NSManaged var inventoryStationCode: String
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
    @NSManaged var insertBarcode: String
    @NSManaged var insertFaded: Bool
    @NSManaged var insertMissing: Bool
    @NSManaged var insertName: String
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
    @NSManaged var inventoryDate: String
    @NSManaged var inventoryCaseNameArchive: String
    @NSManaged var locationDescription: String
    @NSManaged var locationOrientation: String
    @NSManaged var locationAdjacentTVM: Bool
    @NSManaged var locationMountType: String
    @NSManaged var caseWidth: String
    @NSManaged var caseSide: String
    @NSManaged var insertCategory: String
    @NSManaged var locationCasesInCluster: String
    @NSManaged var locationPositionInCluster: String
    @NSManaged var inventoryUser: String
    @NSManaged var inventoryPhoto1: String
    @NSManaged var inventoryPhoto2: String
    @NSManaged var inventoryPhoto1Date: String
    @NSManaged var inventoryPhoto2Date: String
    @NSManaged var insertDate: String
    @NSManaged var insertWaterDamage: Bool
    @NSManaged var caseModified: Bool
    @NSManaged var coverModified: Bool
    @NSManaged var insertModified: Bool
    @NSManaged var locationModified: Bool
    @NSManaged var standModified: Bool
    @NSManaged var inventoryModified: Bool
    @NSManaged var standBolt: String
    

}

func toJSON(caseItem: PIDCase) -> NSDictionary {
    return toJSON([caseItem])
}

func toJSON(caseList: [PIDCase]) -> NSDictionary {
    var jsonList: [String:NSArray] = [:]
    
    var jsonListItem: [AnyObject] = []
    
    for item in caseList {
        
        var image1 = base64FromPicturePath(item.inventoryPhoto1)
        var image2 = base64FromPicturePath(item.inventoryPhoto2)
        
        
        var propertylist : [String: AnyObject] = [
            "id" : Int(item.id),
            "inventoryCaseBarcode" : item.inventoryCaseBarcode,
            "caseBroken" : item.caseBroken,
            "caseColor" : item.caseColor,
            "caseSeverity" : item.caseSeverity,
            "caseGraffiti" : item.caseGraffiti,
            "caseOther" : item.caseOther,
            "caseRusted" : item.caseRusted,
            "inventoryComments" : item.inventoryComments,
            "coverSeverity" : item.coverSeverity,
            "coverCracked" : item.coverCracked,
            "coverDiscolored" : item.coverDiscolored,
            "coverGraffiti" : item.coverGraffiti,
            "coverNoCover" : item.coverNoCover,
            "coverOther" : item.coverOther,
            "insertBarcode" : item.insertBarcode,
            "insertFaded" : item.insertFaded,
            "insertMissing" : item.insertMissing,
            "insertName" : item.insertName,
            "insertOther" : item.insertOther,
            "insertTorn" : item.insertTorn,
            "inventoryLatitude" : item.inventoryLatitude,
            "inventoryLongitude" : item.inventoryLongitude,
            "standBroken" : item.standBroken,
            "standSeverity" : item.standSeverity,
            "standGraffiti" : item.standGraffiti,
            "standOther" : item.standOther,
            "standBolt" : item.standBolt,
            "standRusted" : item.standRusted,
            "standRustedBasePlate" : item.standRustedBasePlate,
            "inventoryDate" : item.inventoryDate,
            "inventoryCaseNameArchive" : item.inventoryCaseNameArchive,
            "locationDescription" : item.locationDescription,
            "locationOrientation" : item.locationOrientation,
            "locationAdjacentTVM" : item.locationAdjacentTVM,
            "locationMountType" : item.locationMountType,
            "caseWidth" : item.caseWidth,
            "caseSide" : item.caseSide,
            "insertCategory" : item.insertCategory,
            "locationCasesInCluster" : item.locationCasesInCluster,
            "locationPositionInCluster" : item.locationPositionInCluster,
            "inventoryUser" : item.inventoryUser,
            "inventoryPhoto1" : image1,
            "inventoryPhoto2" : image2,
            "insertDate" : item.insertDate,
            "insertWaterDamage" : item.insertWaterDamage,
            "caseModified" : item.caseModified,
            "coverModified" : item.coverModified,
            "insertModified" : item.insertModified,
            "locationModified" : item.locationModified,
            "standModified" : item.standModified,
            "inventoryModified" : item.inventoryModified,
            "inventoryStationCode" : item.inventoryStationCode,
            "inventoryPhoto1Date" : item.inventoryPhoto1Date,
            "inventoryPhoto2Date" : item.inventoryPhoto2Date
        ]
        
        jsonListItem.append(propertylist)
    }
    
    jsonList["CaseList"] = jsonListItem
    
    return jsonList
}
