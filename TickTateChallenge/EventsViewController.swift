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
        
        <#code#>
    }
    
    
    
    
    func stopUpdate() {
        if (locationManager != nil) {
            locationManager!.stopUpdatingLocation()
        }
    }
    
    
    
    
    
    
    
    //this method polls for events from sorrounding region






}
