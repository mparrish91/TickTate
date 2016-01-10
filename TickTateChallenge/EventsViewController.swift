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
    var appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    var eventsArray: [[String: AnyObject]] = []
    var RANGE_IN_MILES: CLLocationDistance = 25
    var loggedInUser: PFUser?
    var selectedCity: String?
    var selectedLocation: CLLocation?
    var userCity: String?
    
    
    @IBOutlet weak var eventsTableView: UITableView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        //if the user selects a city from our menu
        if selectedCity != nil {
            loadSelectedCity(selectedCity!)
        }

        if checkUserCredentials() != false {
            loggedInUser = PFUser.currentUser()
            print(loggedInUser)
        }
        startUpdate()

        }


    func postNewEventsForCity() {
        self.fireNearEventsQuery(self.RANGE_IN_MILES, argCoord:self.selectedLocation?.coordinate, bRefreshUI: true)
        
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
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) { switch status {
        
        case .NotDetermined:
        break
        case .AuthorizedAlways:
        manager.startUpdatingLocation()
        break
        case .Denied:
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewControllerWithIdentifier("sorryVC") as! UIViewController
            self.navigationController?.showViewController(vc, sender: nil)
            vc.title = "Ticktate"
        break
        default:
        break
        }
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
        
        appDelegate.currentLocation = newLocation
        
        let geoCoder = CLGeocoder()
        var location = appDelegate.currentLocation
        
        //reverse geocode to find city
        geoCoder.reverseGeocodeLocation(location!, completionHandler: { (placemarks, error) -> Void in
            if let marks = placemarks {
                if marks.count > 0 {
                    
                    // Place details
                    var placeMark: CLPlacemark!
                    placeMark = placemarks?[0]
                    
                    // City
                    if let city = placeMark.addressDictionary!["City"] as? NSString {
                        
                        //if else check if current location is in supported location
                        //if not present other view
                        
                        let cities = CitiesViewController()
                        if cities.citiesArray.contains(city as String) {
                            self.title = "Ticktate - " + (city as String)
                            
                        }else {
                            let storyboard = UIStoryboard(name: "Main", bundle: nil)
                            let vc = storyboard.instantiateViewControllerWithIdentifier("sorryVC") as! UIViewController
                            self.navigationController?.showViewController(vc, sender: nil)
                            vc.title = "Ticktate"
                            
                        }
                    }
                    // should handle error here if no placemarks
                }else {
                    print(error?.description)
                }
            }
        })
        
        
        stopUpdate()
        
        let thisUser = loggedInUser
        ParseHelper.saveUserWithLocationToParse(thisUser, geopoint: PFGeoPoint(location: appDelegate.currentLocation))
        self.fireNearEventsQuery(RANGE_IN_MILES, argCoord: appDelegate.currentLocation?.coordinate, bRefreshUI: true)
    }
    

    //this method polls for events from sorrounding region
    func fireNearEventsQuery(distanceinMiles: CLLocationDistance?, argCoord: CLLocationCoordinate2D?, bRefreshUI: Bool?) {
        
        let miles = distanceinMiles
        print("fireEventsWithinXMiles: \(miles)")
        
        let query = PFQuery(className: "Events")
        query.whereKey("location", nearGeoPoint: PFGeoPoint(latitude: (argCoord?.latitude)!, longitude: (argCoord?.longitude)!), withinMiles: miles!)
        
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
                    print("date \(date)")
                    
                    let city = object["city"]
                    print(city)

                    let artist = object["artist"]
                    print(artist)

                    var dict = [String: AnyObject]()
                    dict["eventID"] = eventID
                    dict["artist"] = artist
                    dict["date"] = date
                    self.eventsArray.append(dict)
                }
                
                if ((bRefreshUI) != nil)
                {
                    self.eventsTableView.reloadData()
                    if self.selectedCity != nil {
                        self.title = "Ticktate - " + self.selectedCity!
                    }

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
        let date = dict["date"] as! NSDate
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MM/dd"
        let dateText = dateFormatter.stringFromDate(date)
        
        cell?.textLabel!.text = artist
        cell?.detailTextLabel!.text = dateText
        cell?.textLabel?.font = UIFont(name: "Verdana", size: 13)
        cell?.contentView.backgroundColor = UIColor.clearColor()
        
        return cell!
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
        return (eventsArray.count)
    
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    
    func loadSelectedCity(city: String) {
        let geoCoder = CLGeocoder()
        
        geoCoder.geocodeAddressString(city) { (placemarks, error) -> Void in
            if let marks = placemarks {
                if marks.count > 0 {
                    self.selectedLocation = marks[0].location
                     self.fireNearEventsQuery(self.RANGE_IN_MILES, argCoord:self.selectedLocation?.coordinate, bRefreshUI: true)
                }else{
                    print(error?.description)
                }
            }
        
            
        }
        
    }


}





//create user

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

