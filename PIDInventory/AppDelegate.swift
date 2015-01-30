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

struct PIDInsertName {
    static let name = "PIDInsert"
    static let id = "id"
    static let insertName = "name"
    static let insertBarcode = "barcode"
}

struct PIDCaseName {
    static let name = "PIDCase"
    static let id = "id"
    static let caseBarcode = "caseBarcode"
    static let latitude = "latitude"
    static let longitude = "longitude"
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    var lastUserLocation: CLLocationCoordinate2D?

    lazy var locationManager: CLLocationManager = {
        var x = CLLocationManager()
        //x.delegate = self
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
        var lat = 40.2
        
        for var i:Int32 = 1000; i <= 3300; i++ {
            let object1 = createPIDCase()
            
            lat += 0.001
            
            object1.id = i
            object1.caseBarcode = "0\(i)"
            object1.latitude = lat
            object1.longitude = -74.70
        }
        
        self.saveContext()
    }
    
    //    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
    //        var location = locations.last as CLLocation
    //        var eventDate = location.timestamp
    //        var howRecent = eventDate.timeIntervalSinceNow
    //        if (abs(howRecent) < 15.0) {
    //
    //        }
    //    }

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
    
    func querySingle<T>(name: String, ByProperty aProperty: String, aValue: String) -> T? {
        var request = NSFetchRequest(entityName: name)
        request.fetchLimit = 1
        request.predicate = NSPredicate(format: "%K == %d", aProperty, aValue)
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
        request.predicate = NSPredicate(format: "%K == %d", aCondition, aValue)
        var objects = self.managedObjectContext?.executeFetchRequest(request, error: nil)
        
        if (objects != nil) {
            return objects!.count > 0 ? objects![0] as String : ""
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
    
    func queryList(name: String, ToRetrieve aProperty: String) -> [Int] {
        var request = NSFetchRequest(entityName: name)
        request.propertiesToFetch = [ aProperty ]
        request.resultType = NSFetchRequestResultType.DictionaryResultType
        request.sortDescriptors = [NSSortDescriptor(key: aProperty, ascending: true)]
        
        var objects: NSArray? = self.managedObjectContext?.executeFetchRequest(request, error: nil)
        
        if objects != nil {
            return objects!.valueForKey(aProperty) as [Int]
        }
        
        return []
    }
    
    func queryList(name: String, ToRetrieve aProperty: String, aCondition: String, aValue: String) -> [Int] {
        var request = NSFetchRequest(entityName: name)
        request.propertiesToFetch = [ aProperty ]
        request.resultType = NSFetchRequestResultType.DictionaryResultType
        request.predicate = NSPredicate(format: "\(aCondition) like[c] %@", "\(aValue)*")
        request.sortDescriptors = [NSSortDescriptor(key: aProperty, ascending: true)]
        
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
        
        request.predicate = NSPredicate(format: "%K BETWEEN {%f, %f} AND %K BETWEEN {%f, %f}", PIDCaseName.latitude, aSouthPoint, aNorthPoint, PIDCaseName.longitude, aWestPoint, anEastPoint)
        
        return self.managedObjectContext?.executeFetchRequest(request, error: nil)
    }
    
    func createPIDCase() -> PIDCase {
        var pidObject = NSEntityDescription.insertNewObjectForEntityForName(PIDCaseName.name,
            inManagedObjectContext: self.managedObjectContext!) as PIDCase
        
        pidObject.id = 0
        pidObject.caseBarcode = ""
        pidObject.comments = ""
        pidObject.insertBarcode = ""
        pidObject.insertName = ""
        pidObject.latitude = 0
        pidObject.longitude = 0
        pidObject.caseBent = false
        pidObject.caseComingApart = false
        pidObject.caseRusted = false
        pidObject.casePitted = false
        pidObject.caseBroken = false
        pidObject.caseGraffiti = false
        pidObject.caseUnauthorized = false
        pidObject.caseOther = false
        pidObject.caseCondition = 0
        pidObject.caseColor = 0
        pidObject.coverNoCover = false
        pidObject.coverCracked = false
        pidObject.coverDiscolored = false
        pidObject.coverGraffiti = false
        pidObject.coverUnauthorized = false
        pidObject.coverOther = false
        pidObject.coverCondition = 0
        pidObject.insertFaded = false
        pidObject.insertTorn = false
        pidObject.insertMissing = false
        pidObject.insertOther = false
        pidObject.insertCondition = 0
        pidObject.insertDescription = ""
        pidObject.standRusted = false
        pidObject.standRustedBasePlate = false
        pidObject.standBroken = false
        pidObject.standGraffiti = false
        pidObject.standUnauthorized = false
        pidObject.standOther = false
        pidObject.standCondition = 0
        
        return pidObject
    }
}

