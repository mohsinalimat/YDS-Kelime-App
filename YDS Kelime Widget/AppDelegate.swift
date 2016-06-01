//
//  AppDelegate.swift
//  YDS Kelime Widget
//
//  Created by Ahmet Yalcinkaya on 11/3/14.
//  Copyright (c) 2014 Hayal Co. All rights reserved.
//

import UIKit
import Crashlytics

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        let path = NSBundle.mainBundle().pathForResource("words.plist", ofType: nil)
        let tmpWordList = NSArray(contentsOfFile: path!)
        
        var wordList:[[String:AnyObject]] = []

        if let list = tmpWordList {
            for item in list {
                if let word = item as? [String : AnyObject] {
                    wordList.append(word)
                }
            }
        }
        
        
        let sharedDefaults:NSUserDefaults = NSUserDefaults(suiteName: "group.hayal.yds")!
        sharedDefaults.setObject(wordList, forKey:"wordList")
        sharedDefaults.synchronize()
        
        
        Crashlytics.startWithAPIKey("5aa5aba631dfa9d92fb2e27e77c999c825506051")
        
        Parse.setApplicationId("2DwWlHvql0nHep1hjqzofhJhyJ77veN6Vz5uPxx3", clientKey: "54o1Gt3dbxQPj40pVppRiRUfjkq3436ZZqhLjrZz")
        PFAnalytics.trackAppOpenedWithLaunchOptionsInBackground(launchOptions, block: nil)
        
        if #available(iOS 8.0, *) {
            if application.respondsToSelector(#selector(UIApplication.isRegisteredForRemoteNotifications)) {
                // iOS 8 Notifications
                application.registerUserNotificationSettings(UIUserNotificationSettings(forTypes: [.Alert, .Badge, .Sound], categories: nil))
                application.registerForRemoteNotifications()
            }
        } else {
            // Fallback on earlier versions
        }
        
        return true
    }
    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        let currentInstallation:PFInstallation = PFInstallation.currentInstallation()
        currentInstallation.setDeviceTokenFromData(deviceToken)
        currentInstallation.saveInBackgroundWithBlock(nil)
    }
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
        
        if let url:String = userInfo["url"] as? String {
            UIApplication.sharedApplication().openURL(NSURL(string: url)!)
        }
        else {
            PFPush.handlePush(userInfo)
        }
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


}

