import Foundation
import CoreData
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    private(set) var _managedObjectContext: NSManagedObjectContext?
    private(set) var _managedObjectModel: NSManagedObjectModel?
    private(set) var _persistentStoreCoordinator: NSPersistentStoreCoordinator?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        // Pass our managed object context to our view controller
        let navController = window?.rootViewController as? UINavigationController
        let tableViewController = navController?.viewControllers.first as? TableViewController
        tableViewController?.context = managedObjectContext

        return true
    }

    func applicationWillTerminate(_ application: UIApplication) {
        saveContext()
    }

    func applicationDocumentsDirectory() -> URL? {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last
    }

    func managedObjectModel() -> NSManagedObjectModel? {
        if _managedObjectModel != nil {
            return _managedObjectModel
        }
        let modelURL: URL? = Bundle.main.url(forResource: "CoreDataUniqueConstraints", withExtension: "momd")
        if let modelURL = modelURL {
            _managedObjectModel = NSManagedObjectModel(contentsOf: modelURL)
        }
        return _managedObjectModel
    }

    var persistentStoreCoordinator: NSPersistentStoreCoordinator? {
        if _persistentStoreCoordinator != nil {
            return _persistentStoreCoordinator
        }

        guard let managedObjectModel = managedObjectModel() else {return nil}
        _persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: managedObjectModel)
        let storeURL: URL? = applicationDocumentsDirectory()?.appendingPathComponent("CoreDataUniqueConstraints.sqlite")
        do {
            // Choose to compile with SQLite or In Memory store
            #if true
            try _persistentStoreCoordinator?.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: storeURL, options: nil)
            #else
            try _persistentStoreCoordinator?.addPersistentStore(ofType: NSInMemoryStoreType, configurationName: nil, at: nil, options: nil)
            #endif
        } catch {
            print("Unresolved error 1 \(error)")
            abort()
        }

        return _persistentStoreCoordinator
    }

    var managedObjectContext: NSManagedObjectContext? {
        if _managedObjectContext != nil {
            return _managedObjectContext
        }

        let coordinator: NSPersistentStoreCoordinator? = persistentStoreCoordinator
        _managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        _managedObjectContext?.persistentStoreCoordinator = coordinator
        _managedObjectContext?.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        return _managedObjectContext
    }

    func saveContext() {
        if let managedObjectContext: NSManagedObjectContext = self.managedObjectContext {
            if managedObjectContext.hasChanges {
                do {
                    try managedObjectContext.save()
                } catch {
                    print("Unresolved error 2 \(error)")
                    abort()
                }
            }
        }
    }
}
