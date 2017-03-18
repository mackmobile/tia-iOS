//
//  AppDelegate.swift
//  MackTIA
//
//  Created by joaquim on 21/08/15.
//  Copyright (c) 2015 Mackenzie. All rights reserved.
//

import UIKit
import CoreData
import Fabric
import Crashlytics
import GoogleMaps


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    // MARK: - Enum used for 3DTouch Shortcuts
    enum Shortcut: String {
        case openAbsence = "OpenAbsences"
        case openGrades = "OpenGrades"
        case openSchedules = "OpenSchedules"
        case openCampus = "OpenCampusMap"
    }
    
    // MARK: -
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        
        // Fabric: Crashyltics and Analytics
        Fabric.with([Crashlytics.self])
        
        // Google API
        GMSServices.provideAPIKey("AIzaSyCboJix6gXaxiCwBN52axQal_4thEDViZY")
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.tintColor = UIColor.red
        
        if let _ = TIAServer.sharedInstance.loginRecorded() {
            self.logUser(TIAServer.sharedInstance.user!)
            let vc = storyboard.instantiateViewController(withIdentifier: "MainScreen")
            self.window?.rootViewController = vc
            self.window?.makeKeyAndVisible()
            return true
        }
        let vc = storyboard.instantiateViewController(withIdentifier: "LoginScreen")
        self.window?.rootViewController = vc
        self.window?.makeKeyAndVisible()
        
        
        // 3DTouch
        
        var isLaunchedFromQuickAction = false
        
        //Check if app is beign launched from QuickAction
        if let shortcutItems = launchOptions?[UIApplicationLaunchOptionsKey.shortcutItem] as? UIApplicationShortcutItem {
            
            isLaunchedFromQuickAction = true
            
            //Handle Shortcut Item
            let _ = self.handleQuickAction(shortcutItems)
        }
        
        return !isLaunchedFromQuickAction
    }
    
    func logUser(_ user:User) {
        // TODO: Use the current user's information
        // You can call any combination of these three methods
        Crashlytics.sharedInstance().setUserEmail("\(user.tia)@mackenzista.com.br")
        Crashlytics.sharedInstance().setUserIdentifier(user.tia)
        Crashlytics.sharedInstance().setUserName(user.name ?? user.tia)
    }
    
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
    }
    
    
    //3DTouch Functions
    //Method to access the QuickActions
    func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
        
        //Handle Quick Action
        completionHandler(handleQuickAction(shortcutItem))
    }
    
    //Method to handle quick actions by the Shortcut Item
    func handleQuickAction(_ shortcutItem: UIApplicationShortcutItem) -> Bool {
        
        //Create a Boolean which is a Indicatior if the QuickAction is correct
        var quickActionHandled = false
        
        //Get the type of the ShortcutItem
        let type = shortcutItem.type.components(separatedBy: ".").last!
        
        //Get Tab Controller
        guard let tabController = self.window?.rootViewController as? UITabBarController else {
            //Error handling
            return false
        }
        
        //Verify if the type is in Enum of Shortcuts
        if let shortcutType = Shortcut.init(rawValue: type) {
            
            switch shortcutType {
                
            case .openAbsence:
                tabController.selectedIndex = 0
                quickActionHandled = true
                
            case .openGrades:
                tabController.selectedIndex = 1
                quickActionHandled = true
                
            case .openSchedules:
                tabController.selectedIndex = 2
                quickActionHandled = true
                
            case .openCampus:
                tabController.selectedIndex = 3
                quickActionHandled = true
            }
        }
        
        return quickActionHandled
    }
}
