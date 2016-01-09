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
    var loggedInUser: PFUser?
    var selectedCity: String?
    
    @IBOutlet weak var eventsTableView: UITableView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
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
        
        if checkUserCredentials() != false {
            loggedInUser = PFUser.currentUser()
            print(loggedInUser)
        }
        startUpdate()

    }
    
    func checkUserCredentials() -> Bool {
        do {
            try PFUser.logInWithUsername("malcolm", password: "12345")
        }
        catch _ {
            // Error handling
        }
        
        if (User.currentUser() != nil) {
            return true
        }
        return false
    }
    
    
    func didLogin() {
        startUpdate()
    }
    
    
    func startUpdate() {
        
        if CLLocationManager.locationServicesEnabled() {
            print("enabled")
        }else{
            return
        }
        if locationManager != nil {
                locationManager!.stopUpdatingLocation()
            }else {
            locationManager = CLLocationManager()
            locationManager!.delegate = self
            locationManager!.desiredAccuracy = kCLLocationAccuracyBest
            locationManager!.requestAlwaysAuthorization()
            view.backgroundColor = UIColor.grayColor()
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
        
        //reverseGeocode to find city
        let geoCoder = CLGeocoder()
        var location = appDelegate.currentLocation
        print(location)

        
        geoCoder.reverseGeocodeLocation(location!, completionHandler: { (placemarks, error) -> Void in
            
            // Place details
            var placeMark: CLPlacemark!
            placeMark = placemarks?[0]
            
            // City
            if let city = placeMark.addressDictionary!["City"] as? NSString {
                self.title = "Ticktate - " + (city as String)
            }
            
        })


        stopUpdate()
        
        let thisUser = loggedInUser
        print(thisUser)
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

        query.findObjectsInBackgroundWithBlock {(objects: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
                for object in objects! {
                    
                    let eventID = object["eventID"]
                    print(eventID)

                    let venue = object["venue"]
                    print(venue)

                    let date = object["date"]
                    print(date)
                    
                    let city = object["city"]
                    print(city)

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
        
        let dict = eventsArray[indexPath.row]

        let artist = dict["artist"] as! String
        let date = dict["date"]
        
//        convert Parse date into NSDate
        
//        let dateFormatter = NSDateFormatter()
//        dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
//        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSSSxxx"
//        let converteddate = dateFormatter.dateFromString(date as! NSDate)
//
//        print(converteddate)
        
        
        //convert NSDate into formatted string


////        dateFormatter.timeZone = NSTimeZone(name:"UTC")
//        let convertedDate = dateFormatter.dateFromString(strDate) as NSDate!
//        let finalconvertedDate = dateFormatter.stringFromDate(convertedDate)
//        dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
//        print(date)

        
        
//        var convertedDate = dateFormatter.stringFromDate(date)

        cell?.textLabel!.text = artist
//        cell?.detailTextLabel!.text = date


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
