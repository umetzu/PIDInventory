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

struct PIDObjectName {
    static let name = "PIDObject"
    static let id = "id"
    static let pid = "pid"
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

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
        
        if (self.count(PIDObjectName.name) == 0) {
            setInitialData()
        }
        
        return true
    }
    
    func setInitialData() {
        
        for var i = 1000; i <= 3300; i++ {
            let object1 = NSEntityDescription.insertNewObjectForEntityForName(PIDObjectName.name,
                inManagedObjectContext: self.managedObjectContext!) as PIDObject
            
            object1.id = i
            object1.pid = "0\(i)"
            object1.barcode = ""
            object1.attribute1 = ""
            object1.gps = ""
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
    
    // MARK: - Core Data Operations
    
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
}

