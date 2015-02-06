//
//  AppDelegate.swift
//  PIDInventory
//
//  Created by Baker on 1/21/15.
//  Copyright (c) 2015 Umetzu. All rights reserved.
//

import UIKit
import CoreLocation
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    var lastUserLocation: CLLocationCoordinate2D?

    lazy var locationManager: CLLocationManager = {
        var x = CLLocationManager()
        x.desiredAccuracy = kCLLocationAccuracyBest
        x.distanceFilter = 10
        return x
        }()

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        if (locationManager.respondsToSelector("requestWhenInUseAuthorization")) {
            locationManager.requestWhenInUseAuthorization()
        }
        
        if (self.count(PIDCaseName.name) == 0) {
            setInitialData()
        }
        
        return true
    }
    

    
    func setInitialData() {
        
        
        var o: PIDCase!

        o = createPIDCase(); o.id = 101; o.inventoryStation = "Hamilton"; o.inventoryCaseBarcode = "00268"; o.inventoryCaseNameArchive = "CHAM509"; o.inventoryLatitude = 40.255211970744597; o.inventoryLongitude = -74.703974948528497; o.inventoryComments = ""; o.caseRusted = true; o.caseBroken = false; o.caseGraffiti = false; o.caseOther = false; o.caseWidth = "2"; o.caseSide = "1"; o.caseColor = "BL"; o.caseSeverity = "FR"; o.coverNoCover = false; o.coverCracked = false; o.coverDiscolored = true; o.coverGraffiti = false; o.coverOther = false; o.coverSeverity = "FR"; o.insertBarcode = ""; o.insertCategory = ""; o.insertName = ""; o.insertDate = "00000000"; o.insertFaded = false; o.insertTorn = false; o.insertMissing = false; o.insertWaterDamage = false; o.insertOther = false; o.insertComments = ""; o.locationDescription = "STAT"; o.locationAdjacentTVM = false; o.locationCasesInCluster = "2"; o.locationPositionInCluster = "2"; o.locationOrientation = "PERP"; o.locationMountType = "SM"; o.standRusted = true; o.standRustedBasePlate = false; o.standBroken = false; o.standGraffiti = false; o.standOther = false; o.standSeverity = "FR";
        o = createPIDCase(); o.id = 102; o.inventoryStation = "Hamilton"; o.inventoryCaseBarcode = "00267"; o.inventoryCaseNameArchive = "CHAM508"; o.inventoryLatitude = 40.255211970744597; o.inventoryLongitude = -74.703974948528497; o.inventoryComments = ""; o.caseRusted = true; o.caseBroken = false; o.caseGraffiti = false; o.caseOther = false; o.caseWidth = "2"; o.caseSide = "1"; o.caseColor = "BL"; o.caseSeverity = "FR"; o.coverNoCover = false; o.coverCracked = true; o.coverDiscolored = true; o.coverGraffiti = false; o.coverOther = false; o.coverSeverity = "FR"; o.insertBarcode = "RSM 030214"; o.insertCategory = "RSM"; o.insertName = "Rail System Map"; o.insertDate = "20140301"; o.insertFaded = false; o.insertTorn = false; o.insertMissing = false; o.insertWaterDamage = false; o.insertOther = false; o.insertComments = ""; o.locationDescription = "STAT"; o.locationAdjacentTVM = false; o.locationCasesInCluster = "2"; o.locationPositionInCluster = "1"; o.locationOrientation = "PERP"; o.locationMountType = "SM"; o.standRusted = true; o.standRustedBasePlate = false; o.standBroken = false; o.standGraffiti = false; o.standOther = false; o.standSeverity = "FR";
        o = createPIDCase(); o.id = 103; o.inventoryStation = "Hamilton"; o.inventoryCaseBarcode = "00266"; o.inventoryCaseNameArchive = "CHAM513"; o.inventoryLatitude = 40.255130998942803; o.inventoryLongitude = -74.703725335442300; o.inventoryComments = ""; o.caseRusted = true; o.caseBroken = false; o.caseGraffiti = false; o.caseOther = false; o.caseWidth = "1"; o.caseSide = "2"; o.caseColor = "BL"; o.caseSeverity = "FR"; o.coverNoCover = false; o.coverCracked = false; o.coverDiscolored = false; o.coverGraffiti = false; o.coverOther = false; o.coverSeverity = "FR"; o.insertBarcode = "RSM 030214"; o.insertCategory = "RSM"; o.insertName = "Rail System Map"; o.insertDate = "20140301"; o.insertFaded = false; o.insertTorn = false; o.insertMissing = false; o.insertWaterDamage = false; o.insertOther = false; o.insertComments = ""; o.locationDescription = "STAT"; o.locationAdjacentTVM = false; o.locationCasesInCluster = "2"; o.locationPositionInCluster = "2"; o.locationOrientation = "PERP"; o.locationMountType = "SM"; o.standRusted = true; o.standRustedBasePlate = false; o.standBroken = false; o.standGraffiti = false; o.standOther = false; o.standSeverity = "FR";
        o = createPIDCase(); o.id = 104; o.inventoryStation = "Hamilton"; o.inventoryCaseBarcode = "00265"; o.inventoryCaseNameArchive = "CHAM512"; o.inventoryLatitude = 40.255130998942803; o.inventoryLongitude = -74.703725335442300; o.inventoryComments = ""; o.caseRusted = false; o.caseBroken = false; o.caseGraffiti = true; o.caseOther = false; o.caseWidth = "1"; o.caseSide = "2"; o.caseColor = "BL"; o.caseSeverity = "FR"; o.coverNoCover = false; o.coverCracked = true; o.coverDiscolored = false; o.coverGraffiti = false; o.coverOther = false; o.coverSeverity = "FR"; o.insertBarcode = "R0270 030214"; o.insertCategory = "RS"; o.insertName = "R 0270"; o.insertDate = "20140302"; o.insertFaded = true; o.insertTorn = false; o.insertMissing = false; o.insertWaterDamage = false; o.insertOther = false; o.insertComments = ""; o.locationDescription = "STAT"; o.locationAdjacentTVM = false; o.locationCasesInCluster = "2"; o.locationPositionInCluster = "1"; o.locationOrientation = "PERP"; o.locationMountType = "SM"; o.standRusted = true; o.standRustedBasePlate = false; o.standBroken = false; o.standGraffiti = false; o.standOther = false; o.standSeverity = "FR";
        o = createPIDCase(); o.id = 105; o.inventoryStation = "Hamilton"; o.inventoryCaseBarcode = "00264"; o.inventoryCaseNameArchive = "CHAM515"; o.inventoryLatitude = 40.255223389972699; o.inventoryLongitude = -74.703687254362407; o.inventoryComments = ""; o.caseRusted = true; o.caseBroken = false; o.caseGraffiti = false; o.caseOther = false; o.caseWidth = "2"; o.caseSide = "1"; o.caseColor = "BL"; o.caseSeverity = "FR"; o.coverNoCover = false; o.coverCracked = false; o.coverDiscolored = true; o.coverGraffiti = false; o.coverOther = false; o.coverSeverity = "FR"; o.insertBarcode = "R0270 030214"; o.insertCategory = "RS"; o.insertName = "R 0270"; o.insertDate = "20140302"; o.insertFaded = false; o.insertTorn = false; o.insertMissing = false; o.insertWaterDamage = false; o.insertOther = false; o.insertComments = ""; o.locationDescription = "STAT"; o.locationAdjacentTVM = false; o.locationCasesInCluster = "2"; o.locationPositionInCluster = "2"; o.locationOrientation = "PAR"; o.locationMountType = "SM"; o.standRusted = true; o.standRustedBasePlate = false; o.standBroken = false; o.standGraffiti = false; o.standOther = false; o.standSeverity = "FR";
        o = createPIDCase(); o.id = 106; o.inventoryStation = "Hamilton"; o.inventoryCaseBarcode = "00263"; o.inventoryCaseNameArchive = "CHAM514"; o.inventoryLatitude = 40.255223389972699; o.inventoryLongitude = -74.703687254362407; o.inventoryComments = ""; o.caseRusted = true; o.caseBroken = false; o.caseGraffiti = true; o.caseOther = false; o.caseWidth = "2"; o.caseSide = "1"; o.caseColor = "BL"; o.caseSeverity = "FR"; o.coverNoCover = false; o.coverCracked = false; o.coverDiscolored = true; o.coverGraffiti = false; o.coverOther = false; o.coverSeverity = "FR"; o.insertBarcode = "R0170 030214"; o.insertCategory = "RS"; o.insertName = "R 0170"; o.insertDate = "20140302"; o.insertFaded = false; o.insertTorn = false; o.insertMissing = false; o.insertWaterDamage = false; o.insertOther = false; o.insertComments = ""; o.locationDescription = "STAT"; o.locationAdjacentTVM = false; o.locationCasesInCluster = "2"; o.locationPositionInCluster = "1"; o.locationOrientation = "PAR"; o.locationMountType = "SM"; o.standRusted = true; o.standRustedBasePlate = false; o.standBroken = false; o.standGraffiti = false; o.standOther = false; o.standSeverity = "FR";
        o = createPIDCase(); o.id = 107; o.inventoryStation = "Hamilton"; o.inventoryCaseBarcode = "00262"; o.inventoryCaseNameArchive = "CHAM517"; o.inventoryLatitude = 40.255470000657603; o.inventoryLongitude = -74.703490000120397; o.inventoryComments = ""; o.caseRusted = true; o.caseBroken = false; o.caseGraffiti = false; o.caseOther = false; o.caseWidth = "1"; o.caseSide = "2"; o.caseColor = "BL"; o.caseSeverity = "FR"; o.coverNoCover = false; o.coverCracked = false; o.coverDiscolored = true; o.coverGraffiti = false; o.coverOther = false; o.coverSeverity = "FR"; o.insertBarcode = "RSM 030214"; o.insertCategory = "RSM"; o.insertName = "Rail System Map"; o.insertDate = "20140301"; o.insertFaded = false; o.insertTorn = false; o.insertMissing = false; o.insertWaterDamage = false; o.insertOther = false; o.insertComments = ""; o.locationDescription = "STAT"; o.locationAdjacentTVM = false; o.locationCasesInCluster = "2"; o.locationPositionInCluster = "2"; o.locationOrientation = "PERP"; o.locationMountType = "SM"; o.standRusted = true; o.standRustedBasePlate = false; o.standBroken = false; o.standGraffiti = false; o.standOther = false; o.standSeverity = "FR";
        o = createPIDCase(); o.id = 108; o.inventoryStation = "Hamilton"; o.inventoryCaseBarcode = "00261"; o.inventoryCaseNameArchive = "CHAM516"; o.inventoryLatitude = 40.255470000657603; o.inventoryLongitude = -74.703490000120397; o.inventoryComments = ""; o.caseRusted = true; o.caseBroken = false; o.caseGraffiti = true; o.caseOther = false; o.caseWidth = "1"; o.caseSide = "2"; o.caseColor = "BL"; o.caseSeverity = "FR"; o.coverNoCover = false; o.coverCracked = false; o.coverDiscolored = false; o.coverGraffiti = false; o.coverOther = false; o.coverSeverity = "FR"; o.insertBarcode = "R0270 030214"; o.insertCategory = "RS"; o.insertName = "R 0270"; o.insertDate = "20140302"; o.insertFaded = false; o.insertTorn = false; o.insertMissing = false; o.insertWaterDamage = false; o.insertOther = false; o.insertComments = ""; o.locationDescription = "STAT"; o.locationAdjacentTVM = false; o.locationCasesInCluster = "2"; o.locationPositionInCluster = "1"; o.locationOrientation = "PERP"; o.locationMountType = "SM"; o.standRusted = true; o.standRustedBasePlate = false; o.standBroken = false; o.standGraffiti = false; o.standOther = false; o.standSeverity = "FR";
        o = createPIDCase(); o.id = 109; o.inventoryStation = "Hamilton"; o.inventoryCaseBarcode = "00260"; o.inventoryCaseNameArchive = "CHAM523"; o.inventoryLatitude = 40.255481354360903; o.inventoryLongitude = -74.704045075040696; o.inventoryComments = ""; o.caseRusted = true; o.caseBroken = false; o.caseGraffiti = true; o.caseOther = false; o.caseWidth = "2"; o.caseSide = "1"; o.caseColor = "BL"; o.caseSeverity = "FR"; o.coverNoCover = false; o.coverCracked = false; o.coverDiscolored = true; o.coverGraffiti = false; o.coverOther = false; o.coverSeverity = "FR"; o.insertBarcode = "RSM 030214"; o.insertCategory = "RSM"; o.insertName = "Rail System Map"; o.insertDate = "20140301"; o.insertFaded = false; o.insertTorn = false; o.insertMissing = false; o.insertWaterDamage = false; o.insertOther = false; o.insertComments = ""; o.locationDescription = "STAT"; o.locationAdjacentTVM = false; o.locationCasesInCluster = "2"; o.locationPositionInCluster = "1"; o.locationOrientation = "PAR"; o.locationMountType = "SM"; o.standRusted = true; o.standRustedBasePlate = false; o.standBroken = false; o.standGraffiti = false; o.standOther = false; o.standSeverity = "FR";
        o = createPIDCase(); o.id = 110; o.inventoryStation = "Hamilton"; o.inventoryCaseBarcode = "00259"; o.inventoryCaseNameArchive = "CHAM522"; o.inventoryLatitude = 40.255481354360903; o.inventoryLongitude = -74.704045075040696; o.inventoryComments = ""; o.caseRusted = true; o.caseBroken = false; o.caseGraffiti = false; o.caseOther = false; o.caseWidth = "2"; o.caseSide = "1"; o.caseColor = "BL"; o.caseSeverity = "FR"; o.coverNoCover = false; o.coverCracked = false; o.coverDiscolored = true; o.coverGraffiti = false; o.coverOther = false; o.coverSeverity = "FR"; o.insertBarcode = "R0170 030214"; o.insertCategory = "RS"; o.insertName = "R 0170"; o.insertDate = "20140302"; o.insertFaded = false; o.insertTorn = false; o.insertMissing = false; o.insertWaterDamage = false; o.insertOther = false; o.insertComments = ""; o.locationDescription = "STAT"; o.locationAdjacentTVM = false; o.locationCasesInCluster = "2"; o.locationPositionInCluster = "1"; o.locationOrientation = "PAR"; o.locationMountType = "SM"; o.standRusted = true; o.standRustedBasePlate = false; o.standBroken = false; o.standGraffiti = false; o.standOther = false; o.standSeverity = "FR";
        o = createPIDCase(); o.id = 111; o.inventoryStation = "Hamilton"; o.inventoryCaseBarcode = "00247"; o.inventoryCaseNameArchive = "CHAM607"; o.inventoryLatitude = 40.255155612728700; o.inventoryLongitude = -74.701559186823900; o.inventoryComments = "Gray spray paint covers entire cover."; o.caseRusted = true; o.caseBroken = false; o.caseGraffiti = false; o.caseOther = false; o.caseWidth = "2"; o.caseSide = "1"; o.caseColor = "BL"; o.caseSeverity = "FR"; o.coverNoCover = false; o.coverCracked = false; o.coverDiscolored = false; o.coverGraffiti = false; o.coverOther = true; o.coverSeverity = "FR"; o.insertBarcode = ""; o.insertCategory = ""; o.insertName = ""; o.insertDate = "00000000"; o.insertFaded = false; o.insertTorn = false; o.insertMissing = true; o.insertWaterDamage = false; o.insertOther = false; o.insertComments = ""; o.locationDescription = "PARK"; o.locationAdjacentTVM = false; o.locationCasesInCluster = "2"; o.locationPositionInCluster = "2"; o.locationOrientation = "PERP"; o.locationMountType = "SM"; o.standRusted = true; o.standRustedBasePlate = false; o.standBroken = false; o.standGraffiti = false; o.standOther = false; o.standSeverity = "FR";
        o = createPIDCase(); o.id = 112; o.inventoryStation = "Hamilton"; o.inventoryCaseBarcode = "00246"; o.inventoryCaseNameArchive = "CHAM606"; o.inventoryLatitude = 40.255155612728700; o.inventoryLongitude = -74.701559186823900; o.inventoryComments = "Gray spray paint covers entire cover."; o.caseRusted = true; o.caseBroken = false; o.caseGraffiti = false; o.caseOther = false; o.caseWidth = "2"; o.caseSide = "1"; o.caseColor = "BL"; o.caseSeverity = "FR"; o.coverNoCover = false; o.coverCracked = false; o.coverDiscolored = false; o.coverGraffiti = false; o.coverOther = true; o.coverSeverity = "FR"; o.insertBarcode = ""; o.insertCategory = ""; o.insertName = ""; o.insertDate = "00000000"; o.insertFaded = false; o.insertTorn = false; o.insertMissing = true; o.insertWaterDamage = false; o.insertOther = false; o.insertComments = ""; o.locationDescription = "PARK"; o.locationAdjacentTVM = false; o.locationCasesInCluster = "2"; o.locationPositionInCluster = "1"; o.locationOrientation = "PERP"; o.locationMountType = "SM"; o.standRusted = true; o.standRustedBasePlate = false; o.standBroken = false; o.standGraffiti = false; o.standOther = false; o.standSeverity = "FR";
        o = createPIDCase(); o.id = 113; o.inventoryStation = "Hamilton"; o.inventoryCaseBarcode = "00244"; o.inventoryCaseNameArchive = "CHAM518"; o.inventoryLatitude = 40.255307209544100; o.inventoryLongitude = -74.703831683370794; o.inventoryComments = "Missing part of case, replacement plexiglass doesn't fully cover insert"; o.caseRusted = true; o.caseBroken = false; o.caseGraffiti = false; o.caseOther = true; o.caseWidth = "2"; o.caseSide = "1"; o.caseColor = "BL"; o.caseSeverity = "PR"; o.coverNoCover = false; o.coverCracked = false; o.coverDiscolored = true; o.coverGraffiti = false; o.coverOther = true; o.coverSeverity = "PR"; o.insertBarcode = "R0170 030214"; o.insertCategory = "RS"; o.insertName = "R 0170"; o.insertDate = "20140302"; o.insertFaded = false; o.insertTorn = false; o.insertMissing = false; o.insertWaterDamage = false; o.insertOther = false; o.insertComments = ""; o.locationDescription = "STAT"; o.locationAdjacentTVM = true; o.locationCasesInCluster = "2"; o.locationPositionInCluster = "1"; o.locationOrientation = "NA"; o.locationMountType = "SM"; o.standRusted = true; o.standRustedBasePlate = false; o.standBroken = false; o.standGraffiti = false; o.standOther = false; o.standSeverity = "PR";
        o = createPIDCase(); o.id = 114; o.inventoryStation = "Hamilton"; o.inventoryCaseBarcode = "00243"; o.inventoryCaseNameArchive = "CHAM519"; o.inventoryLatitude = 40.255307209544100; o.inventoryLongitude = -74.703831683370794; o.inventoryComments = ""; o.caseRusted = true; o.caseBroken = false; o.caseGraffiti = false; o.caseOther = false; o.caseWidth = "2"; o.caseSide = "1"; o.caseColor = "BL"; o.caseSeverity = "FR"; o.coverNoCover = false; o.coverCracked = false; o.coverDiscolored = false; o.coverGraffiti = false; o.coverOther = false; o.coverSeverity = "FR"; o.insertBarcode = "R0270 030214"; o.insertCategory = "RS"; o.insertName = "R 0270"; o.insertDate = "20140302"; o.insertFaded = false; o.insertTorn = false; o.insertMissing = false; o.insertWaterDamage = false; o.insertOther = false; o.insertComments = ""; o.locationDescription = "STAT"; o.locationAdjacentTVM = true; o.locationCasesInCluster = "2"; o.locationPositionInCluster = "2"; o.locationOrientation = "NA"; o.locationMountType = "SM"; o.standRusted = true; o.standRustedBasePlate = false; o.standBroken = false; o.standGraffiti = false; o.standOther = false; o.standSeverity = "FR";
        o = createPIDCase(); o.id = 115; o.inventoryStation = "Hamilton"; o.inventoryCaseBarcode = "00242"; o.inventoryCaseNameArchive = "CHAM507"; o.inventoryLatitude = 40.255185766971401; o.inventoryLongitude = -74.703821422048193; o.inventoryComments = ""; o.caseRusted = false; o.caseBroken = false; o.caseGraffiti = false; o.caseOther = false; o.caseWidth = "2"; o.caseSide = "1"; o.caseColor = "BL"; o.caseSeverity = "FR"; o.coverNoCover = false; o.coverCracked = false; o.coverDiscolored = false; o.coverGraffiti = false; o.coverOther = false; o.coverSeverity = "FR"; o.insertBarcode = ""; o.insertCategory = ""; o.insertName = ""; o.insertDate = "00000000"; o.insertFaded = false; o.insertTorn = false; o.insertMissing = false; o.insertWaterDamage = false; o.insertOther = false; o.insertComments = ""; o.locationDescription = "STAT"; o.locationAdjacentTVM = false; o.locationCasesInCluster = "2"; o.locationPositionInCluster = "2"; o.locationOrientation = "PAR"; o.locationMountType = "SM"; o.standRusted = false; o.standRustedBasePlate = false; o.standBroken = false; o.standGraffiti = false; o.standOther = false; o.standSeverity = "FR";
        o = createPIDCase(); o.id = 116; o.inventoryStation = "Hamilton"; o.inventoryCaseBarcode = "00241"; o.inventoryCaseNameArchive = "CHAM506"; o.inventoryLatitude = 40.255185766971401; o.inventoryLongitude = -74.703821422048193; o.inventoryComments = ""; o.caseRusted = false; o.caseBroken = false; o.caseGraffiti = false; o.caseOther = false; o.caseWidth = "2"; o.caseSide = "1"; o.caseColor = "BL"; o.caseSeverity = "FR"; o.coverNoCover = false; o.coverCracked = false; o.coverDiscolored = false; o.coverGraffiti = false; o.coverOther = false; o.coverSeverity = "FR"; o.insertBarcode = "R0270 030214"; o.insertCategory = "RS"; o.insertName = "R 0270"; o.insertDate = "20140302"; o.insertFaded = false; o.insertTorn = false; o.insertMissing = false; o.insertWaterDamage = false; o.insertOther = false; o.insertComments = ""; o.locationDescription = "STAT"; o.locationAdjacentTVM = false; o.locationCasesInCluster = "2"; o.locationPositionInCluster = "1"; o.locationOrientation = "PAR"; o.locationMountType = "SM"; o.standRusted = false; o.standRustedBasePlate = false; o.standBroken = false; o.standGraffiti = false; o.standOther = false; o.standSeverity = "FR";
        o = createPIDCase(); o.id = 117; o.inventoryStation = "Hamilton"; o.inventoryCaseBarcode = "00240"; o.inventoryCaseNameArchive = "CHAM505"; o.inventoryLatitude = 40.255208802235103; o.inventoryLongitude = -74.703786276434599; o.inventoryComments = ""; o.caseRusted = false; o.caseBroken = false; o.caseGraffiti = true; o.caseOther = false; o.caseWidth = "2"; o.caseSide = "1"; o.caseColor = "BL"; o.caseSeverity = "FR"; o.coverNoCover = false; o.coverCracked = false; o.coverDiscolored = false; o.coverGraffiti = false; o.coverOther = false; o.coverSeverity = "FR"; o.insertBarcode = "R0170 030214"; o.insertCategory = "RS"; o.insertName = "R 0170"; o.insertDate = "20140302"; o.insertFaded = false; o.insertTorn = false; o.insertMissing = false; o.insertWaterDamage = false; o.insertOther = false; o.insertComments = ""; o.locationDescription = "STAT"; o.locationAdjacentTVM = false; o.locationCasesInCluster = "2"; o.locationPositionInCluster = "2"; o.locationOrientation = "PAR"; o.locationMountType = "SM"; o.standRusted = false; o.standRustedBasePlate = true; o.standBroken = false; o.standGraffiti = false; o.standOther = false; o.standSeverity = "FR";
        o = createPIDCase(); o.id = 118; o.inventoryStation = "Hamilton"; o.inventoryCaseBarcode = "00239"; o.inventoryCaseNameArchive = "CHAM504"; o.inventoryLatitude = 40.255208802235103; o.inventoryLongitude = -74.703786276434599; o.inventoryComments = ""; o.caseRusted = false; o.caseBroken = false; o.caseGraffiti = false; o.caseOther = false; o.caseWidth = "2"; o.caseSide = "1"; o.caseColor = "BL"; o.caseSeverity = "FR"; o.coverNoCover = false; o.coverCracked = false; o.coverDiscolored = false; o.coverGraffiti = false; o.coverOther = false; o.coverSeverity = "FR"; o.insertBarcode = "RSM 030214"; o.insertCategory = "RSM"; o.insertName = "Rail System Map"; o.insertDate = "20140301"; o.insertFaded = false; o.insertTorn = false; o.insertMissing = false; o.insertWaterDamage = false; o.insertOther = false; o.insertComments = ""; o.locationDescription = "STAT"; o.locationAdjacentTVM = false; o.locationCasesInCluster = "2"; o.locationPositionInCluster = "1"; o.locationOrientation = "PAR"; o.locationMountType = "SM"; o.standRusted = false; o.standRustedBasePlate = true; o.standBroken = false; o.standGraffiti = false; o.standOther = false; o.standSeverity = "FR";
        o = createPIDCase(); o.id = 119; o.inventoryStation = "Hamilton"; o.inventoryCaseBarcode = "00238"; o.inventoryCaseNameArchive = "CHAM501"; o.inventoryLatitude = 40.255179311623998; o.inventoryLongitude = -74.703758142923903; o.inventoryComments = ""; o.caseRusted = false; o.caseBroken = false; o.caseGraffiti = false; o.caseOther = false; o.caseWidth = "1"; o.caseSide = "1"; o.caseColor = "BL"; o.caseSeverity = "FR"; o.coverNoCover = false; o.coverCracked = false; o.coverDiscolored = false; o.coverGraffiti = true; o.coverOther = false; o.coverSeverity = "FR"; o.insertBarcode = "R0170 030214"; o.insertCategory = "RS"; o.insertName = "R 0170"; o.insertDate = "20140302"; o.insertFaded = false; o.insertTorn = false; o.insertMissing = false; o.insertWaterDamage = false; o.insertOther = false; o.insertComments = ""; o.locationDescription = "STAT"; o.locationAdjacentTVM = true; o.locationCasesInCluster = "1"; o.locationPositionInCluster = "1"; o.locationOrientation = "PAR"; o.locationMountType = "SM"; o.standRusted = false; o.standRustedBasePlate = true; o.standBroken = false; o.standGraffiti = false; o.standOther = false; o.standSeverity = "FR";
        o = createPIDCase(); o.id = 120; o.inventoryStation = "Hamilton"; o.inventoryCaseBarcode = "00237"; o.inventoryCaseNameArchive = "CHAM503"; o.inventoryLatitude = 40.255195353713397; o.inventoryLongitude = -74.703774358353598; o.inventoryComments = ""; o.caseRusted = false; o.caseBroken = false; o.caseGraffiti = false; o.caseOther = false; o.caseWidth = "1"; o.caseSide = "1"; o.caseColor = "BL"; o.caseSeverity = "FR"; o.coverNoCover = false; o.coverCracked = false; o.coverDiscolored = false; o.coverGraffiti = false; o.coverOther = false; o.coverSeverity = "FR"; o.insertBarcode = ""; o.insertCategory = ""; o.insertName = ""; o.insertDate = "00000000"; o.insertFaded = false; o.insertTorn = false; o.insertMissing = false; o.insertWaterDamage = false; o.insertOther = false; o.insertComments = ""; o.locationDescription = "STAT"; o.locationAdjacentTVM = true; o.locationCasesInCluster = "1"; o.locationPositionInCluster = "1"; o.locationOrientation = "PAR"; o.locationMountType = "SM"; o.standRusted = false; o.standRustedBasePlate = true; o.standBroken = false; o.standGraffiti = false; o.standOther = false; o.standSeverity = "FR";
        o = createPIDCase(); o.id = 121; o.inventoryStation = "Hamilton"; o.inventoryCaseBarcode = "00236"; o.inventoryCaseNameArchive = "CHAM502"; o.inventoryLatitude = 40.255173406181797; o.inventoryLongitude = -74.703805571493703; o.inventoryComments = ""; o.caseRusted = false; o.caseBroken = false; o.caseGraffiti = false; o.caseOther = false; o.caseWidth = "1"; o.caseSide = "1"; o.caseColor = "BL"; o.caseSeverity = "FR"; o.coverNoCover = false; o.coverCracked = false; o.coverDiscolored = false; o.coverGraffiti = false; o.coverOther = false; o.coverSeverity = "FR"; o.insertBarcode = "R0270 030214"; o.insertCategory = "RS"; o.insertName = "R 0270"; o.insertDate = "20140302"; o.insertFaded = false; o.insertTorn = false; o.insertMissing = false; o.insertWaterDamage = false; o.insertOther = false; o.insertComments = ""; o.locationDescription = "STAT"; o.locationAdjacentTVM = true; o.locationCasesInCluster = "1"; o.locationPositionInCluster = "1"; o.locationOrientation = "PAR"; o.locationMountType = "SM"; o.standRusted = false; o.standRustedBasePlate = true; o.standBroken = false; o.standGraffiti = false; o.standOther = false; o.standSeverity = "FR";
        o = createPIDCase(); o.id = 122; o.inventoryStation = "Hamilton"; o.inventoryCaseBarcode = "00235"; o.inventoryCaseNameArchive = "CHAM510"; o.inventoryLatitude = 40.255100675705997; o.inventoryLongitude = -74.703878485219604; o.inventoryComments = ""; o.caseRusted = true; o.caseBroken = false; o.caseGraffiti = false; o.caseOther = false; o.caseWidth = "2"; o.caseSide = "1"; o.caseColor = "BL"; o.caseSeverity = "FR"; o.coverNoCover = false; o.coverCracked = true; o.coverDiscolored = true; o.coverGraffiti = false; o.coverOther = false; o.coverSeverity = "FR"; o.insertBarcode = "R0170 030214"; o.insertCategory = "RS"; o.insertName = "R 0170"; o.insertDate = "20140302"; o.insertFaded = false; o.insertTorn = false; o.insertMissing = false; o.insertWaterDamage = false; o.insertOther = false; o.insertComments = ""; o.locationDescription = "STAT"; o.locationAdjacentTVM = false; o.locationCasesInCluster = "2"; o.locationPositionInCluster = "2"; o.locationOrientation = "PAR"; o.locationMountType = "SM"; o.standRusted = false; o.standRustedBasePlate = true; o.standBroken = false; o.standGraffiti = false; o.standOther = false; o.standSeverity = "FR";
        o = createPIDCase(); o.id = 123; o.inventoryStation = "Hamilton"; o.inventoryCaseBarcode = "00234"; o.inventoryCaseNameArchive = "CHAM511"; o.inventoryLatitude = 40.255100675705997; o.inventoryLongitude = -74.703878485219604; o.inventoryComments = ""; o.caseRusted = true; o.caseBroken = false; o.caseGraffiti = false; o.caseOther = false; o.caseWidth = "2"; o.caseSide = "1"; o.caseColor = "BL"; o.caseSeverity = "FR"; o.coverNoCover = false; o.coverCracked = true; o.coverDiscolored = true; o.coverGraffiti = false; o.coverOther = false; o.coverSeverity = "FR"; o.insertBarcode = "R0270 030214"; o.insertCategory = "RS"; o.insertName = "R 0270"; o.insertDate = "20140302"; o.insertFaded = false; o.insertTorn = false; o.insertMissing = false; o.insertWaterDamage = false; o.insertOther = false; o.insertComments = ""; o.locationDescription = "STAT"; o.locationAdjacentTVM = false; o.locationCasesInCluster = "2"; o.locationPositionInCluster = "1"; o.locationOrientation = "PAR"; o.locationMountType = "SM"; o.standRusted = false; o.standRustedBasePlate = true; o.standBroken = false; o.standGraffiti = false; o.standOther = false; o.standSeverity = "FR";
        o = createPIDCase(); o.id = 124; o.inventoryStation = "Hamilton"; o.inventoryCaseBarcode = "00233"; o.inventoryCaseNameArchive = "CHAM002"; o.inventoryLatitude = 40.254498182552702; o.inventoryLongitude = -74.705017116327497; o.inventoryComments = ""; o.caseRusted = false; o.caseBroken = false; o.caseGraffiti = false; o.caseOther = false; o.caseWidth = "1"; o.caseSide = "2"; o.caseColor = "BL"; o.caseSeverity = "FR"; o.coverNoCover = false; o.coverCracked = false; o.coverDiscolored = true; o.coverGraffiti = false; o.coverOther = false; o.coverSeverity = "FR"; o.insertBarcode = "R0270 030214"; o.insertCategory = "RS"; o.insertName = "R 0270"; o.insertDate = "20140302"; o.insertFaded = false; o.insertTorn = false; o.insertMissing = false; o.insertWaterDamage = false; o.insertOther = false; o.insertComments = ""; o.locationDescription = "SPIO"; o.locationAdjacentTVM = false; o.locationCasesInCluster = "2"; o.locationPositionInCluster = "2"; o.locationOrientation = "PERP"; o.locationMountType = "SM"; o.standRusted = false; o.standRustedBasePlate = true; o.standBroken = false; o.standGraffiti = false; o.standOther = false; o.standSeverity = "FR";
        o = createPIDCase(); o.id = 125; o.inventoryStation = "Hamilton"; o.inventoryCaseBarcode = "00232"; o.inventoryCaseNameArchive = "CHAM001"; o.inventoryLatitude = 40.254498182552702; o.inventoryLongitude = -74.705017116327497; o.inventoryComments = ""; o.caseRusted = false; o.caseBroken = false; o.caseGraffiti = true; o.caseOther = false; o.caseWidth = "1"; o.caseSide = "2"; o.caseColor = "BL"; o.caseSeverity = "FR"; o.coverNoCover = false; o.coverCracked = false; o.coverDiscolored = true; o.coverGraffiti = false; o.coverOther = false; o.coverSeverity = "FR"; o.insertBarcode = "R0170 030214"; o.insertCategory = "RS"; o.insertName = "R 0170"; o.insertDate = "20140302"; o.insertFaded = false; o.insertTorn = false; o.insertMissing = false; o.insertWaterDamage = false; o.insertOther = false; o.insertComments = ""; o.locationDescription = "SPIO"; o.locationAdjacentTVM = false; o.locationCasesInCluster = "2"; o.locationPositionInCluster = "1"; o.locationOrientation = "PERP"; o.locationMountType = "SM"; o.standRusted = false; o.standRustedBasePlate = true; o.standBroken = false; o.standGraffiti = false; o.standOther = false; o.standSeverity = "FR";
        o = createPIDCase(); o.id = 126; o.inventoryStation = "Hamilton"; o.inventoryCaseBarcode = "00231"; o.inventoryCaseNameArchive = "CHAM521"; o.inventoryLatitude = 40.255408192560502; o.inventoryLongitude = -74.704161761565601; o.inventoryComments = ""; o.caseRusted = false; o.caseBroken = false; o.caseGraffiti = true; o.caseOther = false; o.caseWidth = "2"; o.caseSide = "1"; o.caseColor = "BL"; o.caseSeverity = "FR"; o.coverNoCover = false; o.coverCracked = false; o.coverDiscolored = true; o.coverGraffiti = false; o.coverOther = false; o.coverSeverity = "FR"; o.insertBarcode = ""; o.insertCategory = ""; o.insertName = ""; o.insertDate = "00000000"; o.insertFaded = true; o.insertTorn = false; o.insertMissing = false; o.insertWaterDamage = false; o.insertOther = false; o.insertComments = ""; o.locationDescription = "STAT"; o.locationAdjacentTVM = false; o.locationCasesInCluster = "2"; o.locationPositionInCluster = "1"; o.locationOrientation = "PAR"; o.locationMountType = "SM"; o.standRusted = true; o.standRustedBasePlate = false; o.standBroken = false; o.standGraffiti = false; o.standOther = false; o.standSeverity = "FR";
        o = createPIDCase(); o.id = 127; o.inventoryStation = "Kenia"; o.inventoryCaseBarcode = "00230"; o.inventoryCaseNameArchive = "CHAM520"; o.inventoryLatitude = 40.255408192560502; o.inventoryLongitude = -74.704161761565601; o.inventoryComments = ""; o.caseRusted = true; o.caseBroken = false; o.caseGraffiti = false; o.caseOther = false; o.caseWidth = "2"; o.caseSide = "1"; o.caseColor = "BL"; o.caseSeverity = "FR"; o.coverNoCover = false; o.coverCracked = false; o.coverDiscolored = true; o.coverGraffiti = false; o.coverOther = false; o.coverSeverity = "FR"; o.insertBarcode = "R0270 030214"; o.insertCategory = "RS"; o.insertName = "R 0270"; o.insertDate = "20140302"; o.insertFaded = false; o.insertTorn = false; o.insertMissing = false; o.insertWaterDamage = false; o.insertOther = false; o.insertComments = ""; o.locationDescription = "STAT"; o.locationAdjacentTVM = false; o.locationCasesInCluster = "2"; o.locationPositionInCluster = "2"; o.locationOrientation = "PAR"; o.locationMountType = "SM"; o.standRusted = true; o.standRustedBasePlate = false; o.standBroken = false; o.standGraffiti = false; o.standOther = false; o.standSeverity = "FR";
        
        var i: PIDInsert!
        
        i = createPIDInsert();        i.name = "Connecting Service Information";      i.barcode = "";         i.category = "AD";      i.date = "00000000";
        i = createPIDInsert();  i.name = "Gap Safety Poster";   i.barcode = "";         i.category = "AD";      i.date = "00000000";
        i = createPIDInsert();  i.name = "Homeland Security  Madrid Rail Poster  2010";        i.barcode = "";         i.category = "AD";      i.date = "00000000";
        i = createPIDInsert();  i.name = "Homeland Security  Madrid Rail Poster 2010";         i.barcode = "";         i.category = "AD";      i.date = "00000000";
        i = createPIDInsert();  i.name = "Homeland Security  Text Against Terror Rail Poster";         i.barcode = "";         i.category = "AD";      i.date = "00000000";
        i = createPIDInsert();  i.name = "Keeping you in the Know  Rail Poster";       i.barcode = "";         i.category = "AD";      i.date = "00000000";
        i = createPIDInsert();  i.name = "NJTPD  Act Up Locked Up";    i.barcode = "";         i.category = "AD";      i.date = "00000000";
        i = createPIDInsert();  i.name = "NJTPD – Act Up Locked Up";    i.barcode = "";         i.category = "AD";      i.date = "00000000";
        i = createPIDInsert();  i.name = "NJTPD  Video and Audio Surveillance";        i.barcode = "";         i.category = "AD";      i.date = "00000000";
        i = createPIDInsert();  i.name = "NJTPD – Video and Audio Surveillance";        i.barcode = "";         i.category = "AD";      i.date = "00000000";
        i = createPIDInsert();  i.name = "Please Use The Handrails";    i.barcode = "";         i.category = "AD";      i.date = "00000000";
        i = createPIDInsert();  i.name = "You’re Not Alone Poster";     i.barcode = "";         i.category = "AD";      i.date = "00000000";
        i = createPIDInsert();  i.name = "You're Not Alone Poster";     i.barcode = "";         i.category = "AD";      i.date = "00000000";
        i = createPIDInsert();  i.name = "LRP 0101";    i.barcode = "";         i.category = "LRS";     i.date = "20130323";
        i = createPIDInsert();  i.name = "LRP 0101 HudsonBergen Light Rail Northbound";        i.barcode = "";         i.category = "LRS";     i.date = "20130323";
        i = createPIDInsert();  i.name = "LRP 0102";    i.barcode = "";         i.category = "LRS";     i.date = "20130323";
        i = createPIDInsert();  i.name = "LRP 0102 HudsonBergen Light Rail Southbound";        i.barcode = "";         i.category = "LRS";     i.date = "20130323";
        i = createPIDInsert();  i.name = "LRP 0301";    i.barcode = "LRP0301 101413";   i.category = "LRS";     i.date = "20131014";
        i = createPIDInsert();  i.name = "LRP 0301 RiverLine North TO Trenton";         i.barcode = "";         i.category = "LRS";     i.date = "20130323";
        i = createPIDInsert();  i.name = "LRP 0301 RiverLine North TO Trenton";         i.barcode = "LRP0301 101413";   i.category = "LRS";     i.date = "20131014";
        i = createPIDInsert();  i.name = "LRP 0302";    i.barcode = "LRP0302 101413";   i.category = "LRS";     i.date = "20131014";
        i = createPIDInsert();  i.name = "LRP 0302 RiverLine South TO Camden";  i.barcode = "";         i.category = "LRS";     i.date = "20130323";
        i = createPIDInsert();  i.name = "LRP 0302 RiverLine South TO Camden";  i.barcode = "LRP0302 101413";   i.category = "LRS";     i.date = "20131014";
        i = createPIDInsert();  i.name = "LRP 0701";    i.barcode = "LRP0701 062114";   i.category = "LRS";     i.date = "20140621";
        i = createPIDInsert();  i.name = "LRP 0701 Newark Light Rail TO GroveStNewark PennBroadSt";   i.barcode = "";         i.category = "LRS";     i.date = "20130622";
        i = createPIDInsert();  i.name = "LRP 0701 Newark Light Rail TO GroveStNewark PennBroadSt";   i.barcode = "";         i.category = "LRS";     i.date = "20130831";
        i = createPIDInsert();  i.name = "LRP 0701 Newark Light Rail TO GroveStNewark PennBroadSt";   i.barcode = "LRP0701 011114";   i.category = "LRS";     i.date = "20140111";
        i = createPIDInsert();  i.name = "LRP 0701 Newark Light Rail TO GroveStNewark PennBroadSt";   i.barcode = "LRP0701 062114";   i.category = "LRS";     i.date = "20140621";
        i = createPIDInsert();  i.name = "LRP 0702";    i.barcode = "LRP0702 062114";   i.category = "LRS";     i.date = "20140621";
        i = createPIDInsert();  i.name = "LRP 0702 Newark Light Rail FROM BroadStNewarkPennGroveSt";  i.barcode = "";         i.category = "LRS";     i.date = "20130622";
        i = createPIDInsert();  i.name = "LRP 0702 Newark Light Rail FROM BroadStNewarkPennGroveSt";  i.barcode = "";         i.category = "LRS";     i.date = "20130831";
        i = createPIDInsert();  i.name = "LRP 0702 Newark Light Rail FROM BroadStNewarkPennGroveSt";  i.barcode = "LRP0702 011114";   i.category = "LRS";     i.date = "20140111";
        i = createPIDInsert();  i.name = "LRP 0702 Newark Light Rail FROM BroadStNewarkPennGroveSt";  i.barcode = "LRP0702 062114";   i.category = "LRS";     i.date = "20140621";
        i = createPIDInsert();  i.name = "NLR Important Return Trip Information";       i.barcode = "";         i.category = "LRS";     i.date = "00000000";
        i = createPIDInsert();  i.name = "HBLR";        i.barcode = "";         i.category = "LRSM";    i.date = "20090701";
        i = createPIDInsert();  i.name = "HBLR";        i.barcode = "";         i.category = "LRSM";    i.date = "20120701";
        i = createPIDInsert();  i.name = "HBLR";        i.barcode = "";         i.category = "LRSM";    i.date = "20120701";
        i = createPIDInsert();  i.name = "HBLR";        i.barcode = "LRSMHBLR 0814";    i.category = "LRSM";    i.date = "20140801";
        i = createPIDInsert();  i.name = "NLR_amexlogo";        i.barcode = "";         i.category = "LRSM";    i.date = "00000000";
        i = createPIDInsert();  i.name = "NLR_amexlogo";        i.barcode = "LRSMRIV 101313";   i.category = "LRSM";    i.date = "20131001";
        i = createPIDInsert();  i.name = "NLR_amexlogo";        i.barcode = "LRSMNLR 0114";     i.category = "LRSM";    i.date = "20140101";
        i = createPIDInsert();  i.name = "NLR_amexlogo";        i.barcode = "LRSMNLR 0114";     i.category = "LRSM";    i.date = "20140101";
        i = createPIDInsert();  i.name = "River Line_ amex_logo";       i.barcode = "LRSMRIV 101313";   i.category = "LRSM";    i.date = "20131001";
        i = createPIDInsert();  i.name = "Riverline_amex_logo";         i.barcode = "";         i.category = "LRSM";    i.date = "20040301";
        i = createPIDInsert();  i.name = "Riverline_amex_logo";         i.barcode = "";         i.category = "LRSM";    i.date = "20080701";
        i = createPIDInsert();  i.name = "Riverline_amex_logo";         i.barcode = "LRSMRIV 101313";   i.category = "LRSM";    i.date = "20080701";
        i = createPIDInsert();  i.name = "Riverline_amex_logo";         i.barcode = "LRSMRIV 101313";   i.category = "LRSM";    i.date = "20131001";
        i = createPIDInsert();  i.name = "Blank";       i.barcode = "";         i.category = "O";       i.date = "00000000";
        i = createPIDInsert();  i.name = "Other";       i.barcode = "";         i.category = "O";       i.date = "00000000";
        i = createPIDInsert();  i.name = "Other";       i.barcode = "";         i.category = "O";       i.date = "20011021";
        i = createPIDInsert();  i.name = "Other";       i.barcode = "LRSMNLR 0114";     i.category = "O";       i.date = "20140101";
        i = createPIDInsert();  i.name = "Parking";     i.barcode = "";         i.category = "O";       i.date = "00000000";
        i = createPIDInsert();  i.name = "Parking";     i.barcode = "";         i.category = "O";       i.date = "20050701";
        i = createPIDInsert();  i.name = "R 0110";      i.barcode = "R0110 030214";     i.category = "RS";      i.date = "20140302";
        i = createPIDInsert();  i.name = "R 0110";      i.barcode = "R0110 062214";     i.category = "RS";      i.date = "20140302";
        i = createPIDInsert();  i.name = "R 0110 Pascack Valley Line";  i.barcode = "R0110 101313";     i.category = "RS";      i.date = "20131013";
        i = createPIDInsert();  i.name = "R 0110 Pascack Valley Line";  i.barcode = "R0110 030214";     i.category = "RS";      i.date = "20140302";
        i = createPIDInsert();  i.name = "R 0110 Pascack Valley Line";  i.barcode = "R0110 062214";     i.category = "RS";      i.date = "20140302";
        i = createPIDInsert();  i.name = "R 0120";      i.barcode = "R0120 030214";     i.category = "RS";      i.date = "20140302";
        i = createPIDInsert();  i.name = "R 0120";      i.barcode = "R0120 062214";     i.category = "RS";      i.date = "20140302";
        i = createPIDInsert();  i.name = "R 0120";      i.barcode = "R0140 062214";     i.category = "RS";      i.date = "20140302";
        i = createPIDInsert();  i.name = "R 0120 Main Bergen Line FROM NYHoboken";     i.barcode = "R0120 101313";     i.category = "RS";      i.date = "20131013";
        i = createPIDInsert();  i.name = "R 0120 Main Bergen Line FROM NYHoboken";     i.barcode = "R0120 030214";     i.category = "RS";      i.date = "20140302";
        i = createPIDInsert();  i.name = "R 0120 Main Bergen Line FROM NYHoboken";     i.barcode = "R0120 062214";     i.category = "RS";      i.date = "20140302";
        i = createPIDInsert();  i.name = "R 0130";      i.barcode = "R0130 062214";     i.category = "RS";      i.date = "20140301";
        i = createPIDInsert();  i.name = "R 0130";      i.barcode = "RSM 030214";       i.category = "RS";      i.date = "20140301";
        i = createPIDInsert();  i.name = "R 0130";      i.barcode = "R0130 062214";     i.category = "RS";      i.date = "20140302";
        i = createPIDInsert();  i.name = "R 0130";      i.barcode = "R0140 030214";     i.category = "RS";      i.date = "20140302";
        i = createPIDInsert();  i.name = "R 0130";      i.barcode = "R0170 030214";     i.category = "RS";      i.date = "20140302";
        i = createPIDInsert();  i.name = "R 0130";      i.barcode = "R0130 030214";     i.category = "RS";      i.date = "20140302";
        i = createPIDInsert();  i.name = "R 0130 MontclairBoonton Line";       i.barcode = "R0130 101313";     i.category = "RS";      i.date = "20131013";
        i = createPIDInsert();  i.name = "R 0130 MontclairBoonton Line";       i.barcode = "R0130 030214";     i.category = "RS";      i.date = "20140302";
        i = createPIDInsert();  i.name = "R 0130 MontclairBoonton Line";       i.barcode = "R0130 062214";     i.category = "RS";      i.date = "20140302";
        i = createPIDInsert();  i.name = "R 0140";      i.barcode = "R0120 062214";     i.category = "RS";      i.date = "20140302";
        i = createPIDInsert();  i.name = "R 0140";      i.barcode = "R0130 062214";     i.category = "RS";      i.date = "20140302";
        i = createPIDInsert();  i.name = "R 0140";      i.barcode = "R0140 030214";     i.category = "RS";      i.date = "20140302";
        i = createPIDInsert();  i.name = "R 0140";      i.barcode = "R0140 062214";     i.category = "RS";      i.date = "20140302";
        i = createPIDInsert();  i.name = "R 0140 MorrisEssex Line FROM NYHoboken";    i.barcode = "R0140 101313";     i.category = "RS";      i.date = "20131013";
        i = createPIDInsert();  i.name = "R 0140 MorrisEssex Line FROM NYHoboken";    i.barcode = "R0140 030214";     i.category = "RS";      i.date = "20140302";
        i = createPIDInsert();  i.name = "R 0140 MorrisEssex Line FROM NYHoboken";    i.barcode = "R0140 062214";     i.category = "RS";      i.date = "20140302";
        i = createPIDInsert();  i.name = "R 0160";      i.barcode = "R0160 101313";     i.category = "RS";      i.date = "20131013";
        i = createPIDInsert();  i.name = "R 0160";      i.barcode = "R0160 030214";     i.category = "RS";      i.date = "20140302";
        i = createPIDInsert();  i.name = "R 0160 Raritan Valley Line";  i.barcode = "R0160 101313";     i.category = "RS";      i.date = "20131013";
        i = createPIDInsert();  i.name = "R 0160 Raritan Valley Line";  i.barcode = "R0160 030214";     i.category = "RS";      i.date = "20140302";
        i = createPIDInsert();  i.name = "R 0170";      i.barcode = "R0170 101313";     i.category = "RS";      i.date = "20131001";
        i = createPIDInsert();  i.name = "R 0170";      i.barcode = "R0170 030214";     i.category = "RS";      i.date = "20140301";
        i = createPIDInsert();  i.name = "R 0170";      i.barcode = "R0170 030214";     i.category = "RS";      i.date = "20140302";
        i = createPIDInsert();  i.name = "R 0170";      i.barcode = "R0140 062214";     i.category = "RS";      i.date = "20140302";
        i = createPIDInsert();  i.name = "R 0170";      i.barcode = "R0170 050114";     i.category = "RS";      i.date = "20140501";
        i = createPIDInsert();  i.name = "R 0170 Northeast Corridor FROM NYNewark";    i.barcode = "R0170 030214";     i.category = "RS";      i.date = "20140302";
        i = createPIDInsert();  i.name = "R 0170 Northeast Corridor FROM NYNewark";    i.barcode = "R0170 050114";     i.category = "RS";      i.date = "20140501";
        i = createPIDInsert();  i.name = "R 0176";      i.barcode = "";         i.category = "RS";      i.date = "20140302";
        i = createPIDInsert();  i.name = "R 0176";      i.barcode = "R0170 030214";     i.category = "RS";      i.date = "20140302";
        i = createPIDInsert();  i.name = "R 0176";      i.barcode = "R0176 030214";     i.category = "RS";      i.date = "20140302";
        i = createPIDInsert();  i.name = "R 0176 Newark Liberty Int'l Airport Station";         i.barcode = "R0176 101313";     i.category = "RS";      i.date = "20131013";
        i = createPIDInsert();  i.name = "R 0176 Newark Liberty Int'l Airport Station";         i.barcode = "R0176 030214";     i.category = "RS";      i.date = "20140302";
        i = createPIDInsert();  i.name = "R 0178";      i.barcode = "R0178 030214";     i.category = "RS";      i.date = "20140302";
        i = createPIDInsert();  i.name = "R 0178";      i.barcode = "R0178 050114";     i.category = "RS";      i.date = "20140501";
        i = createPIDInsert();  i.name = "R 0178 Secaucus Junction  WEEKDAYS";         i.barcode = "R0178 101313";     i.category = "RS";      i.date = "20131013";
        i = createPIDInsert();  i.name = "R 0178 Secaucus Junction  WEEKDAYS";         i.barcode = "R0178 030214";     i.category = "RS";      i.date = "20140302";
        i = createPIDInsert();  i.name = "R 0178 Secaucus Junction  WEEKDAYS";         i.barcode = "R0178 050114";     i.category = "RS";      i.date = "20140501";
        i = createPIDInsert();  i.name = "R 0180";      i.barcode = "";         i.category = "RS";      i.date = "00000000";
        i = createPIDInsert();  i.name = "R 0180";      i.barcode = "R0180 062214";     i.category = "RS";      i.date = "20140302";
        i = createPIDInsert();  i.name = "R 0180";      i.barcode = "R0180 062214";     i.category = "RS";      i.date = "20140622";
        i = createPIDInsert();  i.name = "R 0180";      i.barcode = "R0180 090714";     i.category = "RS";      i.date = "20140907";
        i = createPIDInsert();  i.name = "R 0180 North Jersey Coast Line FROM NYHobNewark";   i.barcode = "R0180 101313";     i.category = "RS";      i.date = "20131013";
        i = createPIDInsert();  i.name = "R 0180 North Jersey Coast Line FROM NYHobNewark";   i.barcode = "R0180 030214";     i.category = "RS";      i.date = "20140302";
        i = createPIDInsert();  i.name = "R 0180 North Jersey Coast Line FROM NYHobNewark";   i.barcode = "R0180 050114";     i.category = "RS";      i.date = "20140501";
        i = createPIDInsert();  i.name = "R 0180 North Jersey Coast Line FROM NYHobNewark";   i.barcode = "R0180 062214";     i.category = "RS";      i.date = "20140622";
        i = createPIDInsert();  i.name = "R 0190";      i.barcode = "R0190 030214";     i.category = "RS";      i.date = "20130302";
        i = createPIDInsert();  i.name = "R 0190";      i.barcode = "R0190 030214";     i.category = "RS";      i.date = "20140302";
        i = createPIDInsert();  i.name = "R 0190 Atlantic City Line";   i.barcode = "R0190 101413";     i.category = "RS";      i.date = "20131014";
        i = createPIDInsert();  i.name = "R 0190 Atlantic City Line";   i.barcode = "R0190 030214";     i.category = "RS";      i.date = "20140302";
        i = createPIDInsert();  i.name = "R 0220";      i.barcode = "";         i.category = "RS";      i.date = "20121014";
        i = createPIDInsert();  i.name = "R 0220";      i.barcode = "RSM 030214";       i.category = "RS";      i.date = "20140301";
        i = createPIDInsert();  i.name = "R 0220";      i.barcode = "R0120 062214";     i.category = "RS";      i.date = "20140302";
        i = createPIDInsert();  i.name = "R 0220";      i.barcode = "R0220 030214";     i.category = "RS";      i.date = "20140302";
        i = createPIDInsert();  i.name = "R 0220";      i.barcode = "R0220 062214";     i.category = "RS";      i.date = "20140302";
        i = createPIDInsert();  i.name = "R 0220 Main Bergen Line TO HobokenNewYork";  i.barcode = "R0220 101313";     i.category = "RS";      i.date = "20131013";
        i = createPIDInsert();  i.name = "R 0220 Main Bergen Line TO HobokenNewYork";  i.barcode = "R0220 030214";     i.category = "RS";      i.date = "20140302";
        i = createPIDInsert();  i.name = "R 0220 Main Bergen Line TO HobokenNewYork";  i.barcode = "R0220 062214";     i.category = "RS";      i.date = "20140302";
        i = createPIDInsert();  i.name = "R 0240";      i.barcode = "RSM 030214";       i.category = "RS";      i.date = "20140301";
        i = createPIDInsert();  i.name = "R 0240";      i.barcode = "R0140 062214";     i.category = "RS";      i.date = "20140302";
        i = createPIDInsert();  i.name = "R 0240";      i.barcode = "R0240 030214";     i.category = "RS";      i.date = "20140302";
        i = createPIDInsert();  i.name = "R 0240";      i.barcode = "R0240 062214";     i.category = "RS";      i.date = "20140302";
        i = createPIDInsert();  i.name = "R 0240 MorrisEssex Line TO HobokenNewYork";         i.barcode = "R0240 101313";     i.category = "RS";      i.date = "20131013";
        i = createPIDInsert();  i.name = "R 0240 MorrisEssex Line TO HobokenNewYork";         i.barcode = "R0240 030214";     i.category = "RS";      i.date = "20140302";
        i = createPIDInsert();  i.name = "R 0240 MorrisEssex Line TO HobokenNewYork";         i.barcode = "R0240 062214";     i.category = "RS";      i.date = "20140302";
        i = createPIDInsert();  i.name = "R 0270";      i.barcode = "R0270 030214";     i.category = "RS";      i.date = "20140302";
        i = createPIDInsert();  i.name = "R 0270";      i.barcode = "R0270 050114";     i.category = "RS";      i.date = "20140501";
        i = createPIDInsert();  i.name = "R 0270";      i.barcode = "R0270 030214";     i.category = "RS";      i.date = "20140502";
        i = createPIDInsert();  i.name = "R 0270 Northeast Corridor Line TO NewarkNewYork";    i.barcode = "R0270 101313";     i.category = "RS";      i.date = "20131013";
        i = createPIDInsert();  i.name = "R 0270 Northeast Corridor Line TO NewarkNewYork";    i.barcode = "R0270 030214";     i.category = "RS";      i.date = "20140302";
        i = createPIDInsert();  i.name = "R 0270 Northeast Corridor Line TO NewarkNewYork";    i.barcode = "R0270 050114";     i.category = "RS";      i.date = "20140501";
        i = createPIDInsert();  i.name = "R 0277";      i.barcode = "R0277 101313";     i.category = "RS";      i.date = "20131013";
        i = createPIDInsert();  i.name = "R 0277";      i.barcode = "R0277 030214";     i.category = "RS";      i.date = "20140302";
        i = createPIDInsert();  i.name = "R 0277 Newark Penn Station to New York";      i.barcode = "R0277 101313";     i.category = "RS";      i.date = "20131013";
        i = createPIDInsert();  i.name = "R 0277 Newark Penn Station to New York";      i.barcode = "R0277 030214";     i.category = "RS";      i.date = "20140302";
        i = createPIDInsert();  i.name = "R 0278";      i.barcode = "R0278 030214";     i.category = "RS";      i.date = "20140302";
        i = createPIDInsert();  i.name = "R 0278";      i.barcode = "R0278 050114";     i.category = "RS";      i.date = "20140501";
        i = createPIDInsert();  i.name = "R 0278 Secaucus Junction WEEKENDS";   i.barcode = "R0278 101313";     i.category = "RS";      i.date = "20131013";
        i = createPIDInsert();  i.name = "R 0278 Secaucus Junction WEEKENDS";   i.barcode = "R0278 030214";     i.category = "RS";      i.date = "20140302";
        i = createPIDInsert();  i.name = "R 0278 Secaucus Junction WEEKENDS";   i.barcode = "R0278 050114";     i.category = "RS";      i.date = "20140501";
        i = createPIDInsert();  i.name = "R 0280";      i.barcode = "";         i.category = "RS";      i.date = "00000000";
        i = createPIDInsert();  i.name = "R 0280";      i.barcode = "RSM 030214";       i.category = "RS";      i.date = "20140301";
        i = createPIDInsert();  i.name = "R 0280";      i.barcode = "R0280 062214";     i.category = "RS";      i.date = "20140622";
        i = createPIDInsert();  i.name = "R 0280";      i.barcode = "R0280 090714";     i.category = "RS";      i.date = "20140907";
        i = createPIDInsert();  i.name = "R 0280 North Jersey Coast Line TO NewarkHobNY";     i.barcode = "R0280 101313";     i.category = "RS";      i.date = "20131013";
        i = createPIDInsert();  i.name = "R 0280 North Jersey Coast Line TO NewarkHobNY";     i.barcode = "R0280 030214";     i.category = "RS";      i.date = "20140302";
        i = createPIDInsert();  i.name = "R 0280 North Jersey Coast Line TO NewarkHobNY";     i.barcode = "R0280 050114";     i.category = "RS";      i.date = "20140501";
        i = createPIDInsert();  i.name = "R 0280 North Jersey Coast Line TO NewarkHobNY";     i.barcode = "R0280 062214";     i.category = "RS";      i.date = "20140622";
        i = createPIDInsert();  i.name = "Rail System Map";     i.barcode = "";         i.category = "RSM";     i.date = "00000000";
        i = createPIDInsert();  i.name = "Rail System Map";     i.barcode = "";         i.category = "RSM";     i.date = "20090101";
        i = createPIDInsert();  i.name = "Rail System Map";     i.barcode = "";         i.category = "RSM";     i.date = "20090701";
        i = createPIDInsert();  i.name = "Rail System Map";     i.barcode = "";         i.category = "RSM";     i.date = "20111101";
        i = createPIDInsert();  i.name = "Rail System Map";     i.barcode = "RSM 101313";       i.category = "RSM";     i.date = "20131001";
        i = createPIDInsert();  i.name = "Rail System Map";     i.barcode = "RSM 102713";       i.category = "RSM";     i.date = "20131027";
        i = createPIDInsert();  i.name = "Rail System Map";     i.barcode = "RSM 030214";       i.category = "RSM";     i.date = "20140301";
        i = createPIDInsert();  i.name = "Rail System Map";     i.barcode = "RSM 030214";       i.category = "RSM";     i.date = "20140301";
        i = createPIDInsert();  i.name = "Rail System Map";     i.barcode = "R0160 030214";     i.category = "RSM";     i.date = "20140302";
        i = createPIDInsert();  i.name = "Rail System Map";     i.barcode = "R0240 062214";     i.category = "RSM";     i.date = "20140302";
        i = createPIDInsert();  i.name = "Rail System Map";     i.barcode = "";         i.category = "RSM";     i.date = "20141101";
        i = createPIDInsert();  i.name = "Camden SAM";  i.barcode = "";         i.category = "SAM";     i.date = "00000000";
        i = createPIDInsert();  i.name = "Cranford SAM";        i.barcode = "";         i.category = "SAM";     i.date = "00000000";
        i = createPIDInsert();  i.name = "Hoboken DIR";         i.barcode = "";         i.category = "SAM";     i.date = "20131201";
        i = createPIDInsert();  i.name = "Hoboken SAM";         i.barcode = "";         i.category = "SAM";     i.date = "00000000";
        i = createPIDInsert();  i.name = "Hoboken SAM";         i.barcode = "SAMHOB 101313";    i.category = "SAM";     i.date = "20131001";
        i = createPIDInsert();  i.name = "Maplewood SAM";       i.barcode = "";         i.category = "SAM";     i.date = "00000000";
        i = createPIDInsert();  i.name = "Middletown SAM";      i.barcode = "";         i.category = "SAM";     i.date = "00000000";
        i = createPIDInsert();  i.name = "Morristown SAM";      i.barcode = "";         i.category = "SAM";     i.date = "00000000";
        i = createPIDInsert();  i.name = "Morristown SAM";      i.barcode = "SAMMOR 101313";    i.category = "SAM";     i.date = "20131001";
        i = createPIDInsert();  i.name = "New Brunswick SAM";   i.barcode = "";         i.category = "SAM";     i.date = "00000000";
        i = createPIDInsert();  i.name = "New Brunswick SAM";   i.barcode = "SAMBK 091014";     i.category = "SAM";     i.date = "20140901";
        i = createPIDInsert();  i.name = "Newark Penn SAM";     i.barcode = "";         i.category = "SAM";     i.date = "00000000";
        i = createPIDInsert();  i.name = "Newark Penn SAM";     i.barcode = "";         i.category = "SAM";     i.date = "20140401";
        i = createPIDInsert();  i.name = "Newport SAM";         i.barcode = "";         i.category = "SAM";     i.date = "00000000";
        i = createPIDInsert();  i.name = "Pennsauken Transit Center";   i.barcode = "SAMPAC 101313";    i.category = "SAM";     i.date = "20131001";
        i = createPIDInsert();  i.name = "Pennsauken Transit Center";   i.barcode = "SAMPTC 101313";    i.category = "SAM";     i.date = "20131001";
        i = createPIDInsert();  i.name = "Pennsauken Transit Center";   i.barcode = "SAMRPTC 010213";   i.category = "SAM";     i.date = "20140701";
        i = createPIDInsert();  i.name = "Plainfield SAM";      i.barcode = "";         i.category = "SAM";     i.date = "00000000";
        i = createPIDInsert();  i.name = "Plauderville SAM";    i.barcode = "";         i.category = "SAM";     i.date = "20111001";
        i = createPIDInsert();  i.name = "Plauderville SAM";    i.barcode = "";         i.category = "SAM";     i.date = "20140701";
        i = createPIDInsert();  i.name = "Rahway SAM";  i.barcode = "";         i.category = "SAM";     i.date = "00000000";
        i = createPIDInsert();  i.name = "Ridgewood SAM";       i.barcode = "";         i.category = "SAM";     i.date = "00000000";
        i = createPIDInsert();  i.name = "Ridgewood SAM";       i.barcode = "";         i.category = "SAM";     i.date = "20140701";
        i = createPIDInsert();  i.name = "Rutgers SAM";         i.barcode = "";         i.category = "SAM";     i.date = "00000000";
        i = createPIDInsert();  i.name = "Secaucus SAM";        i.barcode = "";         i.category = "SAM";     i.date = "20120101";
        i = createPIDInsert();  i.name = "Secaucus SAM";        i.barcode = "SAMSEC 112713";    i.category = "SAM";     i.date = "20131101";
        i = createPIDInsert();  i.name = "Secaucus SAM";        i.barcode = "";         i.category = "SAM";     i.date = "20140701";
        i = createPIDInsert();  i.name = "Somerville SAM";      i.barcode = "";         i.category = "SAM";     i.date = "00000000";
        i = createPIDInsert();  i.name = "Somerville SAM";      i.barcode = "";         i.category = "SAM";     i.date = "20140701";
        i = createPIDInsert();  i.name = "South Amboy SAM";     i.barcode = "";         i.category = "SAM";     i.date = "00000000";
        i = createPIDInsert();  i.name = "South Amboy SAM";     i.barcode = "";         i.category = "SAM";     i.date = "20140701";
        i = createPIDInsert();  i.name = "Tonnelle Ave SAM";    i.barcode = "";         i.category = "SAM";     i.date = "00000000";
        i = createPIDInsert();  i.name = "Trenton SAM";         i.barcode = "";         i.category = "SAM";     i.date = "00000000";
        i = createPIDInsert();  i.name = "Whitehouse Station SAM";      i.barcode = "";         i.category = "SAM";     i.date = "00000000";
        i = createPIDInsert();  i.name = "Woodbridge SAM";      i.barcode = "";         i.category = "SAM";     i.date = "00000000";
        i = createPIDInsert();  i.name = "HBLR Ticket info Time Stamp";         i.barcode = "";         i.category = "TVM";     i.date = "00000000";
        i = createPIDInsert();  i.name = "HBLR Ticket info_time stamp";         i.barcode = "";         i.category = "TVM";     i.date = "00000000";
        i = createPIDInsert();  i.name = "NLR tic info PID";    i.barcode = "";         i.category = "TVM";     i.date = "00000000";
        i = createPIDInsert();  i.name = "Rail Ticket info  Final";    i.barcode = "";         i.category = "TVM";     i.date = "00000000";
        i = createPIDInsert();  i.name = "Rail Ticket info  Final";    i.barcode = "R0176 030214";     i.category = "TVM";     i.date = "00000000";
        i = createPIDInsert();  i.name = "Rail ticket infoFINAL";      i.barcode = "";         i.category = "TVM";     i.date = "00000000";
       
        self.saveContext()
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    // MARK: - Core Data stack
    
    lazy var applicationDocumentsDirectory: NSURL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "com.umetzu.test" in the application's documents Application Support directory.
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls[urls.count-1] as NSURL
        }()
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = NSBundle.mainBundle().URLForResource("PIDInventory", withExtension: "momd")!
        return NSManagedObjectModel(contentsOfURL: modelURL)!
        }()
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator? = {
        // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        var coordinator: NSPersistentStoreCoordinator? = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.URLByAppendingPathComponent("PIDInventory.sqlite")
        var error: NSError? = nil
        var failureReason = "There was an error creating or loading the application's saved data."
        if coordinator!.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: nil, error: &error) == nil {
            coordinator = nil
            // Report any error we got.
            let dict = NSMutableDictionary()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
            dict[NSLocalizedFailureReasonErrorKey] = failureReason
            dict[NSUnderlyingErrorKey] = error
            error = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(error), \(error!.userInfo)")
            abort()
        }
        
        return coordinator
        }()
    
    lazy var managedObjectContext: NSManagedObjectContext? = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        if coordinator == nil {
            return nil
        }
        var managedObjectContext = NSManagedObjectContext()
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
        }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        if let moc = self.managedObjectContext {
            var error: NSError? = nil
            if moc.hasChanges && !moc.save(&error) {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                NSLog("Unresolved error \(error), \(error!.userInfo)")
                abort()
            }
        }
    }
    
    func rollBack () {
        if let moc = self.managedObjectContext {
            var error: NSError? = nil
            if moc.hasChanges {
                moc.rollback()
            }
        }
    }
    
    // MARK: - Core Data Operations
    
    func lastID(name: String) -> Int32 {
        var request = NSFetchRequest(entityName: name)
        request.propertiesToFetch = [ "id" ]
        request.fetchLimit = 1
        request.sortDescriptors = [NSSortDescriptor(key: "id", ascending: false)]
        request.resultType = NSFetchRequestResultType.DictionaryResultType
        var result = self.managedObjectContext?.executeFetchRequest(request, error: nil)
        
        if (result?.count > 0) {
            return (result![0]["id"] as NSNumber).intValue
        }
        
        return 0
    }
    
    func count(name: String) -> Int {
        var request = NSFetchRequest(entityName: name)
        request.propertiesToFetch = [ "id" ]
        request.resultType = NSFetchRequestResultType.CountResultType
        var count = self.managedObjectContext?.countForFetchRequest(request, error: nil)
        return count ?? 0
    }
    
    func querySingle<T>(name: String, ByID id: Int) -> T? {
        var request = NSFetchRequest(entityName: name)
        request.fetchLimit = 1
        request.predicate = NSPredicate(format: "id == %d", id)
        var objects = self.managedObjectContext?.executeFetchRequest(request, error: nil)
       
        if (objects != nil) {
            return objects!.count > 0 ? objects![0] as? T : nil
        }
        
        return nil
    }
    
    func querySingle<T>(name: String, Properties: [(property:String, value:String)]) -> T? {
        var request = NSFetchRequest(entityName: name)
        request.fetchLimit = 1
        
        var predicates:[NSPredicate] = []
        
        for x in Properties {
            var p = NSPredicate(format: "%K ==[c] %@", x.property, x.value)!
            
            predicates.append(p)
        }
        
        request.predicate = NSCompoundPredicate(type: .AndPredicateType, subpredicates: predicates)
        
        var objects = self.managedObjectContext?.executeFetchRequest(request, error: nil)
        
        if (objects != nil) {
            return objects!.count > 0 ? objects![0] as? T : nil
        }
        
        return nil
    }

    func querySingle<T>(name: String, ByProperty aProperty: String, aValue: String) -> T? {
        var request = NSFetchRequest(entityName: name)
        request.fetchLimit = 1
        request.predicate = NSPredicate(format: "%K ==[c] %@", aProperty, aValue)
        var objects = self.managedObjectContext?.executeFetchRequest(request, error: nil)
        
        if (objects != nil) {
            return objects!.count > 0 ? objects![0] as? T : nil
        }
        
        return nil
    }
    
    func querySingle(name: String, ToRetrieve aProperty: String, aCondition: String, aValue: String) -> String {
        var request = NSFetchRequest(entityName: name)
        request.propertiesToFetch = [ aProperty ]
        request.fetchLimit = 1
        request.predicate = NSPredicate(format: "%K == %@", aCondition, aValue)
        request.resultType = NSFetchRequestResultType.DictionaryResultType
        var result = self.managedObjectContext?.executeFetchRequest(request, error: nil)
        
        if (result?.count > 0) {
            return result![0][aProperty] as String
        }
        
        return ""
    }
    
    func queryList(name: String, SortedBy aProperty: String ) -> [AnyObject]? {
        var request = NSFetchRequest(entityName: name)
        request.sortDescriptors = [NSSortDescriptor(key: aProperty, ascending: true)]
        
        var result = self.managedObjectContext?.executeFetchRequest(request, error: nil)
        
        return result
    }
    
    func queryList(name: String, ToRetrieve aProperty: String) -> [String] {
        var request = NSFetchRequest(entityName: name)
        request.propertiesToFetch = [ aProperty ]
        request.resultType = NSFetchRequestResultType.DictionaryResultType
        request.sortDescriptors = [NSSortDescriptor(key: aProperty, ascending: true)]
        
        var objects: NSArray? = self.managedObjectContext?.executeFetchRequest(request, error: nil)
        
        if objects != nil {
            return objects!.valueForKey(aProperty) as [String]
        }
        
        return []
    }
    
    func queryList(name: String, ToRetrieve aProperty: String, SortBy aSorting: String) -> [Int] {
        var request = NSFetchRequest(entityName: name)
        request.propertiesToFetch = [ aProperty ]
        request.resultType = NSFetchRequestResultType.DictionaryResultType
        request.sortDescriptors = [NSSortDescriptor(key: aSorting, ascending: true)]
        
        var objects: NSArray? = self.managedObjectContext?.executeFetchRequest(request, error: nil)
        
        if objects != nil {
            return objects!.valueForKey(aProperty) as [Int]
        }
        
        return []
    }
    
    func queryList(name: String, ToRetrieve aProperty: String, aCondition: String, aValue: String, SortBy aSorting: String) -> [String] {
        var request = NSFetchRequest(entityName: name)
        request.propertiesToFetch = [ aProperty ]
        request.returnsDistinctResults = true
        request.resultType = NSFetchRequestResultType.DictionaryResultType
        request.predicate = NSPredicate(format: "%K == %@", aCondition, aValue)
        request.sortDescriptors = [NSSortDescriptor(key: aSorting, ascending: true)]
        
        var objects: NSArray? = self.managedObjectContext?.executeFetchRequest(request, error: nil)
        
        if objects != nil {
            return objects!.valueForKey(aProperty) as [String]
        }
        
        return []
    }
    
    func queryList(name: String, ToRetrieve aProperty: String, aCondition: String, aValue: String, SortBy aSorting: String) -> [Int] {
        var request = NSFetchRequest(entityName: name)
        request.propertiesToFetch = [ aProperty ]
        request.resultType = NSFetchRequestResultType.DictionaryResultType
        request.predicate = NSPredicate(format: "\(aCondition) like[c] %@", "\(aValue)*")
        request.sortDescriptors = [NSSortDescriptor(key: aSorting, ascending: true)]
        
        var objects: NSArray? = self.managedObjectContext?.executeFetchRequest(request, error: nil)
        
        if objects != nil {
            return objects!.valueForKey(aProperty) as [Int]
        }
        
        return []
    }
    
    func queryList(name: String, ToRetrieve aProperty: String, conditions: [String], aValue: String, SortBy aSorting: String) -> [Int] {
        var request = NSFetchRequest(entityName: name)
        request.propertiesToFetch = [ aProperty ]
        request.resultType = NSFetchRequestResultType.DictionaryResultType
 
        var predicates:[NSPredicate] = []
        
        for x in conditions {
            var p = NSPredicate(format: "%K contains[c] %@", x, aValue)!
            
            predicates.append(p)
        }
        
        request.predicate = NSCompoundPredicate(type: .OrPredicateType, subpredicates: predicates)
        
        request.sortDescriptors = [NSSortDescriptor(key: aSorting, ascending: true)]
        
        var objects: NSArray? = self.managedObjectContext?.executeFetchRequest(request, error: nil)
        
        if objects != nil {
                return objects!.valueForKey(aProperty) as [Int]
        }
        
        return []
    }
    
    func queryMap(aWestPoint: Double, anEastPoint: Double, aNorthPoint: Double, aSouthPoint: Double) -> NSArray? {
        var request = NSFetchRequest(entityName: PIDCaseName.name)
        request.propertiesToFetch = [ PIDCaseName.id, PIDCaseName.caseBarcode, PIDCaseName.latitude, PIDCaseName.longitude ]
        request.resultType = NSFetchRequestResultType.DictionaryResultType
        request.sortDescriptors = [NSSortDescriptor(key: PIDCaseName.caseBarcode, ascending: true)]
        
        request.predicate = NSPredicate(format: "%K BETWEEN {%f, %f} AND %K BETWEEN {%f, %f}", PIDCaseName.latitude, aSouthPoint, aNorthPoint, PIDCaseName.longitude, aWestPoint, anEastPoint)
        
        return self.managedObjectContext?.executeFetchRequest(request, error: nil)
    }
    
    func createPIDInsert() -> PIDInsert {
        var pidObject = NSEntityDescription.insertNewObjectForEntityForName(PIDInsertName.name,
            inManagedObjectContext: self.managedObjectContext!) as PIDInsert
        
        pidObject.id = 0
        pidObject.barcode = ""
        pidObject.name = ""
        
        return pidObject
    }

    
    func createPIDCase() -> PIDCase {
        var pidObject = NSEntityDescription.insertNewObjectForEntityForName(PIDCaseName.name,
            inManagedObjectContext: self.managedObjectContext!) as PIDCase
        
        pidObject.id = 0
        
        pidObject.inventoryCaseBarcode = ""
        pidObject.caseBroken = false
        pidObject.caseColor = ""
        pidObject.caseSeverity = ""
        pidObject.caseGraffiti = false
        pidObject.caseOther = false
        pidObject.caseRusted = false
        pidObject.inventoryComments = ""
        pidObject.coverSeverity = ""
        pidObject.coverCracked = false
        pidObject.coverDiscolored = false
        pidObject.coverGraffiti = false
        pidObject.coverNoCover = false
        pidObject.coverOther = false
        pidObject.insertBarcode = ""
        pidObject.insertComments = ""
        pidObject.insertFaded = false
        pidObject.insertMissing = false
        pidObject.insertName = ""
        pidObject.insertOther = false
        pidObject.insertTorn = false
        pidObject.inventoryLatitude  = 0
        pidObject.inventoryLongitude  = 0
        pidObject.standBroken = false
        pidObject.standSeverity = ""
        pidObject.standGraffiti = false
        pidObject.standOther = false
        pidObject.standRusted = false
        pidObject.standRustedBasePlate = false
        pidObject.inventoryDate = "00000000"
        pidObject.inventoryCaseNameArchive = ""
        pidObject.locationDescription = ""
        pidObject.locationOrientation = ""
        pidObject.locationAdjacentTVM = false
        pidObject.locationMountType = ""
        pidObject.caseWidth = ""
        pidObject.caseSide = ""
        pidObject.insertCategory = ""
        pidObject.locationCasesInCluster = ""
        pidObject.locationPositionInCluster = ""
        pidObject.inventoryUser = ""
        pidObject.inventoryPhoto1 = ""
        pidObject.inventoryPhoto2 = ""
        pidObject.insertDate = "00000000"
        pidObject.insertWaterDamage = false
        pidObject.caseModified = false
        pidObject.coverModified = false
        pidObject.insertModified = false
        pidObject.locationModified = false
        pidObject.standModified = false
        pidObject.inventoryModified = false
        pidObject.inventoryStation = ""
     
        return pidObject
    }
}

