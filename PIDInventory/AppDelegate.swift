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
        
        if NSUserDefaults.standardUserDefaults().stringForKey("server") == nil {
            NSUserDefaults.standardUserDefaults().setValue("hamivgis2:8080", forKey: "server")
            NSUserDefaults.standardUserDefaults().synchronize()
        }
        
        return true
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
        let coordinator = self.persistentStoreCoordinator
        if coordinator == nil {
            return nil
        }
        
        var managedObjectContext = NSManagedObjectContext()
        //var managedObjectContext = NSManagedObjectContext(concurrencyType: .PrivateQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        if NSThread.isMainThread() {
        if let moc = self.managedObjectContext {
            var error: NSError? = nil
            if moc.hasChanges && !moc.save(&error) {
                NSLog("Unresolved error \(error), \(error!.userInfo)")
                UIAlertView(title: "Database Error", message: "No changes were persisted", delegate: nil, cancelButtonTitle: "OK").show()
            }
        }
        } else {
            dispatch_async(dispatch_get_main_queue(), {
                self.saveContext()
            })
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
    func deleteAllManagedObjects() {
        for entityName in managedObjectModel.entitiesByName.keys {
            let request = NSFetchRequest(entityName: entityName as String)
            let response = self.managedObjectContext?.executeFetchRequest(request, error: nil) as [NSManagedObject]
            for item in response {
                managedObjectContext?.deleteObject(item)
            }
        }
    }
    
    func deleteObject(item: NSManagedObject) {
        managedObjectContext?.deleteObject(item)
    }
    
    func deleteObjects(objects: [NSManagedObject]) {
        for item in objects {
            managedObjectContext?.deleteObject(item)
        }
    }
    
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
    
    func count(name: String, aCondition: String, aValue: Bool) -> Int {
        var request = NSFetchRequest(entityName: name)
        request.propertiesToFetch = [ "id" ]
        request.predicate = NSPredicate(format: "%K == %@", aCondition, NSNumber(bool: aValue))
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
    
    func querySingle(name: String, ToRetrieve aProperty: String, aCondition: String, aValue: Int) -> Bool {
        var request = NSFetchRequest(entityName: name)
        request.propertiesToFetch = [ aProperty ]
        request.fetchLimit = 1
        request.predicate = NSPredicate(format: "%K == %d", aCondition, aValue)
        request.resultType = NSFetchRequestResultType.DictionaryResultType
        var result = self.managedObjectContext?.executeFetchRequest(request, error: nil)
        
        if (result?.count > 0) {
            return result![0][aProperty] as Bool
        }
        
        return false
    }
    
    func queryList(name: String, aCondition: String, aValue: Bool) -> [PIDCase]? {
        var request = NSFetchRequest(entityName: name)
        request.predicate = NSPredicate(format: "%K == %@", aCondition, NSNumber(bool: aValue))
        
        var result = self.managedObjectContext?.executeFetchRequest(request, error: nil)
        
        if result != nil {
            return result! as? [PIDCase]
        }
        
        return nil
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
    
    func queryList(name: String, ToRetrieve aProperty: String, condition1: String, value1: String, condition2: String, value2: [String], SortBy aSorting: String) -> [Int] {
        var request = NSFetchRequest(entityName: name)
        request.propertiesToFetch = [ aProperty ]
        request.resultType = NSFetchRequestResultType.DictionaryResultType
        
        var predicates:[NSPredicate] = []
        
        var p1 = NSPredicate(format: "%K contains[c] %@", condition1, value1)!
        predicates.append(p1)
        
        if value2.count > 0 {
            var p2 = NSPredicate(format: "%K IN $IDLIST", condition2)!.predicateWithSubstitutionVariables(["IDLIST":value2])
            predicates.append(p2)
        }
        
        request.predicate = NSCompoundPredicate(type: .OrPredicateType, subpredicates: predicates)
        
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
        request.propertiesToFetch = [ PIDCaseName.id, PIDCaseName.caseBarcode, PIDCaseName.latitude, PIDCaseName.longitude, PIDCaseName.modified ]
        request.resultType = NSFetchRequestResultType.DictionaryResultType
        request.sortDescriptors = [NSSortDescriptor(key: PIDCaseName.caseBarcode, ascending: true)]
        
        request.predicate = NSPredicate(format: "%K BETWEEN {%f, %f} AND %K BETWEEN {%f, %f}", PIDCaseName.latitude, aSouthPoint, aNorthPoint, PIDCaseName.longitude, aWestPoint, anEastPoint)
        
        return self.managedObjectContext?.executeFetchRequest(request, error: nil)
    }
    
    func sendToService(serviceAddress: String, method: String, pidCase: PIDCase, onSuccess: ((PIDCase) -> Void)!, onError: (() -> Void)!) -> Bool {
        var error: NSError?
        var url = NSURL(string: serviceAddress + method)
        var response: NSURLResponse?
        
        if url == nil {
            return false
        }
        
        var objectToSend = toJSON(pidCase)
        
        var jsonData = NSJSONSerialization.dataWithJSONObject(objectToSend, options: nil, error: &error)
        
        if jsonData == nil || error != nil {
            return false
        }
        
        var request = NSMutableURLRequest(URL: url!, cachePolicy: .ReloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 240)
        request.HTTPMethod = "POST"
        request.setValue(NSString(format: "%d", jsonData!.length), forHTTPHeaderField:"Content-Length")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.HTTPBody = jsonData
        
        let queue:NSOperationQueue = NSOperationQueue()
        NSURLConnection.sendAsynchronousRequest(request, queue: queue, completionHandler:{ (response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
            
            var error2: NSError?
            
            if data == nil || error != nil {
                onError()
                return
            }
    
            var dataList = NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers, error: &error2) as? NSDictionary
    
            if dataList == nil && error2 != nil {
                onError()
                return
            }
    
            var results:AnyObject? = dataList!.valueForKey(method + "Result")
    
            if results == nil {
                onError()
                return
            }
            
            var value = results! as? Int
            
            if value != nil && value! == 1 {
                onSuccess(pidCase)
                return
            }
    
        })
        
        return true
    }
    
    func queryService(serviceAddress: String, _ method: String, _ onSuccess: ((AnyObject?) -> Void)!, _ onError: (() -> Void)?, _ interval:NSTimeInterval = 15) -> Bool? {
        var url = NSURL(string: serviceAddress + method)
        var response: NSURLResponse?
        
        if url == nil {
            return false
        }
        
        var request = NSURLRequest(URL: url!, cachePolicy: .ReloadIgnoringLocalAndRemoteCacheData, timeoutInterval: interval)
        
        let queue:NSOperationQueue = NSOperationQueue()
        NSURLConnection.sendAsynchronousRequest(request, queue: queue, completionHandler:{ (response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
            var error: NSError?
            
            if data == nil || error != nil {
                if onError != nil {
                    onError!()
                }
                return
            }
    
            var dataList = NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers, error: &error) as? NSDictionary
    
            if dataList == nil && error != nil {
                if onError != nil {
                    onError!()
                }
                return
            }
    
            var results:AnyObject? = dataList!.valueForKey(method + "Result")
            
            if results == nil {
                if onError != nil {
                    onError!()
                }
                return
            }
            
            onSuccess(results)
        })
        
        return true
    }
    
    
    func createPIDInsert() -> PIDInsert {
        var pidObject = NSEntityDescription.insertNewObjectForEntityForName(PIDInsertName.name, inManagedObjectContext: self.managedObjectContext!) as PIDInsert
        
        pidObject.id = 0
        pidObject.barcode = ""
        pidObject.name = ""
        pidObject.date = "00000000"
        pidObject.category = ""
        
        return pidObject
    }

    
    func createPIDCase() -> PIDCase {
        var pidObject = NSEntityDescription.insertNewObjectForEntityForName(PIDCaseName.name, inManagedObjectContext: self.managedObjectContext!) as PIDCase
        
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
        pidObject.inventoryStationCode = ""
        pidObject.inventoryPhoto1Date = ""
        pidObject.inventoryPhoto2Date = ""
     
        return pidObject
    }
}

