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
    
    var window: UIWindow?
    
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        // Fabric: Crashyltics and Analytics
        Fabric.with([Crashlytics.self])
        
        // Google API
        GMSServices.provideAPIKey("AIzaSyCboJix6gXaxiCwBN52axQal_4thEDViZY")
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        self.window?.tintColor = UIColor.redColor()
        
        if let _ = TIAServer.sharedInstance.loginRecorded() {
            self.logUser(TIAServer.sharedInstance.user!)
            let vc = storyboard.instantiateViewControllerWithIdentifier("MainScreen")
            self.window?.rootViewController = vc
            self.window?.makeKeyAndVisible()
            return true
        }
        let vc = storyboard.instantiateViewControllerWithIdentifier("LoginScreen")
        self.window?.rootViewController = vc
        self.window?.makeKeyAndVisible()
        return true
    }
    
    func logUser(user:User) {
        // TODO: Use the current user's information
        // You can call any combination of these three methods
        Crashlytics.sharedInstance().setUserEmail("\(user.tia)@mackenzista.com.br")
        Crashlytics.sharedInstance().setUserIdentifier(user.tia)
        Crashlytics.sharedInstance().setUserName(user.name ?? user.tia)
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
        // Saves changes in the application's managed object context before the application terminates.
    }
        
}

