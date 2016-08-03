//
//  AppDelegate.swift
//  ChoreMastr
//
//  Created by Demetri Kostakis on 4/10/16.
//  Copyright © 2016 ChoreMastr. All rights reserved.
//

import UIKit
import Firebase

let appThemeColor = UIColor(colorLiteralRed: 255, green: 204, blue: 102, alpha: 1)

//defines global variable for the current user
var currentUser: User = User()
let appRef = FIRDatabase.database().reference()

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        //configures the GoogleService-Info Plist file
        FIRApp.configure()
        
        //Allows offline cache of data
        FIRDatabase.database().persistenceEnabled = true
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        
    }

    func applicationDidEnterBackground(application: UIApplication) {
        
    }

    func applicationWillEnterForeground(application: UIApplication) {
    
    }

    func applicationDidBecomeActive(application: UIApplication) {
       
    }

    func applicationWillTerminate(application: UIApplication) {
        
    }


}

