//
//  Event.swift
//  TickTateChallenge
//
//  Created by Malcolm Parrish on 1/6/16.
//  Copyright © 2016 mparrish. All rights reserved.
//

import Foundation
import Parse

class Event: PFObject, PFSubclassing {
    
    @NSManaged var startDate : NSDate
    @NSManaged var endDate : NSDate
    
    @NSManaged var user: User!
    
    static func parseClassName() -> String {
        return "Event"
    }
    
    override class func initialize() {
        struct Static {
            static var onceToken : dispatch_once_t = 0;
        }
        dispatch_once(&Static.onceToken) {
            self.registerSubclass()
        }
    }
}