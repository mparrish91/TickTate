//
//  EventsViewController.swift
//  TickTateChallenge
//
//  Created by Malcolm Parrish on 1/6/16.
//  Copyright © 2016 mparrish. All rights reserved.
//

import UIKit
import CoreLocation


class EventsViewController: UIViewController, CLLocationManagerDelegate {
    
    var locationManager:CLLocationManager?
    var locationRecieved: Bool?
    var appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    
    override func viewDidLoad() {
        
    }
    
    func didLogin() {
        startUpdate()
        
    }
    
    
    func startUpdate() {
        
        if locationManager != nil {
            locationManager!.stopUpdatingLocation()
        }else{
            locationManager = CLLocationManager()
            locationManager!.delegate = self
            locationManager!.desiredAccuracy = kCLLocationAccuracyBest
            locationManager!.requestAlwaysAuthorization()
        }
        locationManager!.startUpdatingLocation()
        
    }
    
    
    //store finalized user location
    //then saves in ActiveUsers row and fetches events 
    
    func locationManager(manager: CLLocationManager, didUpdateToLocation newLocation: CLLocation, fromLocation oldLocation: CLLocation) {
        let meters = newLocation.distanceFromLocation(oldLocation)
        
        
        if (meters != -1 && meters < 50.0) {
            return
        }
        
        print(NSString(format: "## Latitude :%.0f", newLocation.coordinate.latitude))
        print(NSString(format: "## Longtitude :%.0f", newLocation.coordinate.longitude))


        appDelegate.currentLocation =
        
        stopUpdate()
            
        let thisUser = ParseHelper().loggedInUser
            
        ParseHelper.saveUserWithLocationToParse(thisUser, PFGeoPoint(appDelegate.currentLocation)
            
        
        
        
            
            
        }
    }
    
    
    
    
    func stopUpdate() {
        if (locationManager != nil) {
            locationManager!.stopUpdatingLocation()
        }
    }
    
    
    
    
    
    
    
    //this method polls for events from sorrounding region






}
