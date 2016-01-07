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
    
    
    //store finalized user location
    //then saves in ActiveUsers row and fetches events 
    
    func locationManager(manager: CLLocationManager, didUpdateToLocation newLocation: CLLocation, fromLocation oldLocation: CLLocation) {
        let meters = newLocation.distanceFromLocation(oldLocation)
        
        
        if (meters != -1 && meters < 50.0) {
            return
        }
        
        print(NSString(format: "## Latitude :%.0f", newLocation.coordinate.latitude))
        print(NSString(format: "## Longtitude :%.0f", newLocation.coordinate.longitude))
        
        appDelegate.currentLocation = newLocation
        
        
        stopUpdate()
        
        let thisUser = ParseHelper().loggedInUser
        
        
        ParseHelper.saveUserWithLocationToParse(thisUser, geopoint: PFGeoPoint(location: appDelegate.currentLocation))
        
        
        
        
    }
    
    
    
    

    
    
    
    
    
    func stopUpdate() {
        if (locationManager != nil) {
            locationManager!.stopUpdatingLocation()
        }
    }
    
    func fireNearEventsQuery(distanceinMiles: CLLocationDistance?, argCoord: CLLocationCoordinate2D?, bRefreshUI: Bool?) {
        
        let miles = distanceinMiles
        print("fireNearUsersQuery \(miles)")
        
        let query = PFQuery(className: "Events")
        query.whereKey("location", nearGeoPoint: PFGeoPoint(latitude: (argCoord?.latitude)!, longitude: (argCoord?.longitude)!), withinMiles: miles!)
        
        //delete existing rows
        eventsArray?.removeAll()
        eventsTableView.reloadData()

        query.findObjectsInBackgroundWithBlock {(objects, error) -> Void in
            if error == nil {
                for object in objects! {
                    //if for this user, skip it
                    let eventID = object["eventID"] as! String
                    print(eventID)
                    
                    let artist = object["artist"]
                    
                    let dict = NSMutableDictionary()
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
        
        
        let dict = eventsArray![indexPath.row]
        
        
        
        let artist = dict.objectForKey("artist") as! String

        
        let cell = tableView.dequeueReusableCellWithIdentifier("cell")
        cell?.backgroundColor = UIColor.clearColor()
        
        cell?.textLabel!.text = artist
        cell?.textLabel?.font = UIFont(name: "Verdana", size: 13)
        cell?.contentView.backgroundColor = UIColor.clearColor()
        
        return cell!
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      (eventsArray?.count)!ay?.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    
    
    
    
    //this method polls for events from sorrounding region






}
