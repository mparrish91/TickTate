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
    var eventsArray: [[String: AnyObject]] = []
    var RANGE_IN_MILES: CLLocationDistance = 25
    
    @IBOutlet weak var eventsTableView: UITableView!
    
    override func viewDidLoad() {
        
//        var user = PFUser()
//        user.username = "malcolm"
//        user.password = "12345"
//        user.email = "email@example.com"
//        
//        user.signUpInBackgroundWithBlock {
//            (succeeded: Bool, error: NSError?) -> Void in
//            if error == nil {
//                // Hooray! Let them use the app now.
//                print("user Saved")
//            } else {
//            }
//        }
        
        
        var currentUser = PFUser.currentUser()
        startUpdate()
        
        let geoCoder = CLGeocoder()
        
        var longitude :CLLocationDegrees = -122.0312186
        var latitude :CLLocationDegrees = 37.33233141
        
        var location = CLLocation(latitude: latitude, longitude: longitude)
//        let location = appDelegate.currentLocation
        
        
        
        geoCoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) -> Void in
            
            // Place details
            var placeMark: CLPlacemark!
            placeMark = placemarks?[0]
            
            // Address dictionary
            print(placeMark.addressDictionary)
            
            // Location name
            if let locationName = placeMark.addressDictionary!["Name"] as? NSString {
                print(locationName)
            }
            
            // Street address
            if let street = placeMark.addressDictionary!["Thoroughfare"] as? NSString {
                print(street)
            }
            
            // City
            if let city = placeMark.addressDictionary!["City"] as? NSString {
                print(city)
                self.title = city as String
            }
            
            // Zip code
            if let zip = placeMark.addressDictionary!["ZIP"] as? NSString {
                print(zip)
            }
            
            // Country
            if let country = placeMark.addressDictionary!["Country"] as? NSString {
                print(country)
            }
            
        })

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
        eventsArray.removeAll()
        eventsTableView.reloadData()

        query.findObjectsInBackgroundWithBlock {(objects, error) -> Void in
            if error == nil {
                for object in objects! {
                    
                    let eventID = object["eventID"]
                    let venue = object["venue"]
//                    let date = object["date"] as! NSDate
                    let city = object["city"]
                    let artist = object["artist"]
                    print(artist)

                    var dict = [String: AnyObject]()
                    dict["eventID"] = eventID
                    dict["artist"] = artist
                    
                    self.eventsArray.append(dict)
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
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cell")
        cell?.backgroundColor = UIColor.clearColor()
        
//        guard let d = eventsArray[indexPath.row], dict = d as? [String: AnyObject] else { return cell! }
        
        let dict = eventsArray[indexPath.row]

        let artist = dict["artist"] as! String
        let date = dict["date"] as! NSDate
        let venue = dict["venue"] as! String

        cell?.textLabel!.text = artist
        cell?.detailTextLabel!.text = artist

        cell?.textLabel?.font = UIFont(name: "Verdana", size: 13)
        cell?.contentView.backgroundColor = UIColor.clearColor()
        
        return cell!
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
        return (eventsArray.count)
    
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    
    


}
