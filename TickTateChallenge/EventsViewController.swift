//
//  EventsViewController.swift
//  TickTateChallenge
//
//  Created by Malcolm Parrish on 1/6/16.
//  Copyright © 2016 mparrish. All rights reserved.
//

import UIKit
import CoreLocation
import Parse


class EventsViewController: UIViewController, CLLocationManagerDelegate, UITableViewDelegate, UITableViewDataSource {
    
    var locationManager:CLLocationManager?
    var locationRecieved: Bool?
    var appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    var eventsArray: [Any]?
    var RANGE_IN_MILES: CLLocationDistance = 25
    
    @IBOutlet weak var eventsTableView: UITableView!
    
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
    
    func stopUpdate() {
        if (locationManager != nil) {
            locationManager!.stopUpdatingLocation()
        }
    }
    
    
    //store finalized user location
    //then saves users and fetches events
    func locationManager(manager: CLLocationManager, didUpdateToLocation newLocation: CLLocation, fromLocation oldLocation: CLLocation) {
        
        let meters = newLocation.distanceFromLocation(oldLocation)
        
        //if meters is innacurate or if user hasn't moved much
        if (meters != -1 && meters < 50.0) {
            return
        }
        
        print(NSString(format: "## Latitude :%.0f", newLocation.coordinate.latitude))
        print(NSString(format: "## Longtitude :%.0f", newLocation.coordinate.longitude))
        
        //users current location
        appDelegate.currentLocation = newLocation
    
        stopUpdate()
        
        let thisUser = ParseHelper().loggedInUser
        ParseHelper.saveUserWithLocationToParse(thisUser, geopoint: PFGeoPoint(location: appDelegate.currentLocation))
        self.fireNearEventsQuery(RANGE_IN_MILES, argCoord: appDelegate.currentLocation?.coordinate, bRefreshUI: true)
    }
    

    //this method polls for events from sorrounding region
    func fireNearEventsQuery(distanceinMiles: CLLocationDistance?, argCoord: CLLocationCoordinate2D?, bRefreshUI: Bool?) {
        
        let miles = distanceinMiles
        print("fireEventsWithinXMiles: \(miles)")
        
        let query = PFQuery(className: "Events")
        query.whereKey("location", nearGeoPoint: PFGeoPoint(latitude: (argCoord?.latitude)!, longitude: (argCoord?.longitude)!), withinMiles: miles!)
        
        //delete existing rows
        eventsArray?.removeAll()
        eventsTableView.reloadData()

        query.findObjectsInBackgroundWithBlock {(objects, error) -> Void in
            if error == nil {
                for object in objects! {
                    
                    let eventID = object["eventID"] as! String
                    let venue = object["venue"] as! String
//                    let date = object["date"] as! NSDate
                    let city = object["city"] as! String
                    let artist = object["artist"] as! String
                    print(artist)

                    var dict = [String: String]()
                    dict["eventID"] = eventID
                    dict["artist"] = artist
                    
                    self.eventsArray?.append(dict)
                }
                
                if ((bRefreshUI) != nil)
                {
                    self.eventsTableView.reloadData()
                }
            }
            
            else{
                print("\(error?.description)")
                }
        }
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let dict = eventsArray?[indexPath.row]
        
        let artist = dict["artist"]

        let cell = tableView.dequeueReusableCellWithIdentifier("cell")
        cell?.backgroundColor = UIColor.clearColor()
        
        cell?.textLabel!.text = artist
        cell?.textLabel?.font = UIFont(name: "Verdana", size: 13)
        cell?.contentView.backgroundColor = UIColor.clearColor()
        
        return cell!
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
        return (eventsArray?.count)!
    
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    


}
