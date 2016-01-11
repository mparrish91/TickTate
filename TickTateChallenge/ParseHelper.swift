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
        
    
    class func saveUserWithLocationToParse(user: PFUser?, geopoint: PFGeoPoint?) {
        
        var activeUser: PFObject?
        
        let query = PFQuery(className: "User")
        query.whereKey("objectID", equalTo: user!.objectId!)
        query.findObjectsInBackgroundWithBlock {(objects, error) -> Void in
            if error == nil {
                //if user is active user already, just update the entry
                //otherwise create it.
                if objects?.count == 0 {
                    activeUser = PFObject(className: "User")
                }else{
                    activeUser = objects![0]
                }
                
                let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                activeUser!["userTitle"] = appDelegate.userTitle
                activeUser!["userLocation"] = geopoint

                
                activeUser!.saveInBackgroundWithBlock{ (success, error) -> Void in
                    
                    if success {
                        print("User saved: \(success)")
                    }else{
                        let description = error?.localizedDescription
                        print(" \(description)")
                    }
                }
            }
        }
        
    
    

        
        
        
    }






}