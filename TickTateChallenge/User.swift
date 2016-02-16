//
//  User.swift
//  TickTateChallenge
//
//  Created by Malcolm Parrish on 1/6/16.
//  Copyright © 2016 mparrish. All rights reserved.
//

import Foundation
import Parse


class User: PFUser {
    
    //MARK: Properties
    @NSManaged var name: String
    
    var events : [Event]!
    var test = []
    
    
    override class func initialize() {
        struct Static {
            static var onceToken : dispatch_once_t = 0;
        }
        dispatch_once(&Static.onceToken) {
            self.registerSubclass()
        }
    }


}