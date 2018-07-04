//
//  AppDelegate.swift
//  FoodPin
//
//  Created by 许有红 on 2018/6/13.
//  Copyright © 2018 EmptyWlaker. All rights reserved.
//

import UIKit
import CoreData
import UserNotifications



@UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate {
    
    
//    enum QuickAction: String {
//        case OpenFavorites: "OpenFavorites"
//        case OpenDiscover: "OpenDiscover"
//        case NewRestaurant: "NewRestaurant"
//        init?(fullIdentifier: String) {
//            guard let shortcutIdentifier = fullIdentifier.components(separatedBy: ".").last else {
//                return nil
//            }
//            self.init(rawValue: shortcutIdentifier)
//        }
//    }
    
    enum QuickAction: String {
        case OpenFavorites = "OpenFavorites"
        case OpenDiscover = "OpenDiscover"
        case NewRestaurant = "NewRestaurant"

        init?(fullIdentifier: String) {

            guard let shortcutIdentifier = fullIdentifier.components(separatedBy: ".").last else {
                return nil
            }

            self.init(rawValue: shortcutIdentifier)
        }
    }
    
    
    
    

    var window: UIWindow?
    
    // MARK: Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "FoodPin")
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unsolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        // Customize the back button
        let backButtonImage = UIImage(named: "back")
        UINavigationBar.appearance().backIndicatorImage = backButtonImage
        UINavigationBar.appearance().backIndicatorTransitionMaskImage = backButtonImage
        
        // Customize the tab bar
        UITabBar.appearance().tintColor = UIColor(red: 231, green: 76, blue: 60)
        UITabBar.appearance().barTintColor = UIColor.white
        
        
        // UNUserNotificationCenter
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
            if granted {
                print("User notifications are allowed.")
            } else {
                print("User notifications are not allowed.")
            }
        }
        UNUserNotificationCenter.current().delegate = self
        
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
    }
    
    // MARK: - Core Data Saving Support
    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unsolved error \(nserror), \(nserror.userInfo)")
                
            }
        }
        
    }
    
    // MARK: - Preform 3D Touch Action
    func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
        completionHandler(handleQuickAction(shortcutItem: shortcutItem))
    }
    
    // MARK: - Private methods
    private func handleQuickAction(shortcutItem: UIApplicationShortcutItem) -> Bool {
        let shortcutType = shortcutItem.type
        guard let shortcutIdentifier = QuickAction(fullIdentifier: shortcutType) else {
            return false
        }
        guard let tabbarController = window?.rootViewController as? UITabBarController else {
            return false
        }
        switch shortcutIdentifier {
        case .OpenFavorites:
            tabbarController.selectedIndex = 0
        case .OpenDiscover:
            tabbarController.selectedIndex = 1
        case .NewRestaurant:
            if let navController = tabbarController.viewControllers?[0] {
                let restaurantController = navController.childViewControllers[0]
                restaurantController.performSegue(withIdentifier: "addRestaurant", sender: restaurantController)
            } else {
                return false
            }
        }
        return true
    }
}

// MARK: - Extension
extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        if response.actionIdentifier == "foodpin.makeRserveation" {
            print("Make reserveation...")
            if let phone = response.notification.request.content.userInfo["phone"] {
                let telURL = "tel://\(String(describing: phone))"
                if let url = URL(string: telURL) {
                    if UIApplication.shared.canOpenURL(url) {
                        print("Calling \(telURL)")
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    }
                }
            }
        }
        completionHandler()
    }
}

