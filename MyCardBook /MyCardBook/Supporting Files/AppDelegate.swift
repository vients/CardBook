//
//  AppDelegate.swift
//  MyCardBook
//
//  Created by Yurii Vients on 10/27/17.
//  Copyright © 2017 Yurii Vients. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
//    var orientationLock = UIInterfaceOrientationMask.all
//    
//    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
//        return self.orientationLock
//    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }
    /*
    func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
        let handeledShortcutItem = self.handleShortCutItem(shortCutItem: shortcutItem)
        completionHandler(handeledShortcutItem)
    }

    enum ShortcutIdentifier : String {

        case TestViewController

        init?(fullType : String) {
            guard let last = fullType.components(separatedBy: ".").last else { return nil }
            self.init(rawValue: last)
        }

        var type : String {
            return Bundle.main.bundleIdentifier! + ".\(self.rawValue)"
        }

    }
    func handleShortCutItem(shortCutItem: UIApplicationShortcutItem) -> Bool {

        var handeled = false

        guard ShortcutIdentifier(fullType: shortCutItem.type) != nil else { return false }
        guard let shortcutType = shortCutItem.type as String? else { return false }

        switch (shortcutType) {

        case ShortcutIdentifier.TestViewController.type:

            // Handle shortcut 1 (static).
            handeled = true
            // Navigation for Camera
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let mainVC = storyboard.instantiateViewController(withIdentifier: "Main") as! UINavigationController
            let secVC : AddCardVC = storyboard.instantiateViewController(withIdentifier: "AddCardVC") as! AddCardVC
            window?.rootViewController = mainVC
            self.window?.makeKeyAndVisible()
            mainVC.pushViewController(secVC, animated: true)
            // Test to see if the button works
            print("Second")

            break

//        case ShortcutIdentifier.ThirdVC.type:
//            // Handle shortcut 1 (static).
//            handeled = true
//            // Navigation for Camera
//            let storyboard = UIStoryboard(name: "Main", bundle: nil)
//            let mainVC = storyboard.instantiateViewController(withIdentifier: "Main") as! UINavigationController
//            let secVC : ThirdVC = storyboard.instantiateViewController(withIdentifier: "Third") as! ThirdVC
//            window?.rootViewController = mainVC
//            self.window?.makeKeyAndVisible()
//            mainVC.pushViewController(secVC, animated: true)
//            // Test to see if the button works
//            print("Third")
//
//            break

        default:
            break

        }

        return handeled

    }
    
    */
    
    
    
    
    func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
        if shortcutItem.type == "AddCardVC" {
           let storyboard = UIStoryboard(name: "Main", bundle: nil)
           let mainVC = storyboard.instantiateViewController(withIdentifier: "Main") as! UINavigationController
           let addVC : AddCardVC = storyboard.instantiateViewController(withIdentifier: "AddCardVC") as! AddCardVC
        window?.rootViewController = mainVC
        self.window?.makeKeyAndVisible()
        mainVC.pushViewController(addVC, animated: true)
        }
    }
    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "MyCardBook")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

