//
//  AppDelegate.swift
//  TickTateChallenge
//
//  Created by Malcolm Parrish on 1/6/16.
//  Copyright © 2016 mparrish. All rights reserved.
//

import UIKit
import Parse
import Bolts

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var currentLocation: CLLocation?
    var userTitle: String?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        
        Parse.enableLocalDatastore()
        
        Parse.setApplicationId("mut3gKF3XXSzmPXtMjepzCGzZSp0Ktk1ze6dN1s5",
            clientKey: "A9Mn3FWaxJhrRvT1xDNUlXNZatd3qAHQi2xiQMWb")
        
        // [Optional] Track statistics around application opens.
        PFAnalytics.trackAppOpenedWithLaunchOptions(launchOptions)
        
        
        return true
    }

}

