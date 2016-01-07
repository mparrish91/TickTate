//
//  ParseHelper.swift
//  TickTateChallenge
//
//  Created by Malcolm Parrish on 1/6/16.
//  Copyright © 2016 mparrish. All rights reserved.
//

import UIKit
import CoreLocation
import Parse


class ParseHelper: NSObject {
    
    var loggedInUser: PFUser?
    
    
    class func saveUserWithLocationToParse(user: PFUser?, geopoint: PFGeoPoint?) {
        
        var activeUser: PFObject?
        
        let query = PFQuery(className: "ActiveUsers")
        query.whereKey("userID", equalTo: user!.objectId!)
        query.findObjectsInBackgroundWithBlock {(objects, error) -> Void in
            if error == nil {
                //if user is active user already, just update the entry
                //otherwise create it.
                if objects?.count == 0 {
                    activeUser = PFObject(className: "ActiveUsers")
                }else{
                    activeUser = objects![0]
                }
                
                let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                activeUser!["userID"] = user!.objectId
                activeUser!["userTitle"] = appDelegate.userTitle
                
                activeUser!.saveInBackgroundWithBlock{ (success, error) -> Void in
                    
                    if success {
                        print("activeUser saved: \(success)")
                    }else{
                        let description = error?.localizedDescription
                        print(" \(description)")
                        let msg  = "Save to ActiveUsers failed. \(description)"
                    }
                }
            }
        }
        
    
    

        
        
        
    }






}