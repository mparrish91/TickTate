//
//  CitiesViewController.swift
//  TickTateChallenge
//
//  Created by Malcolm Parrish on 1/6/16.
//  Copyright © 2016 mparrish. All rights reserved.
//

import UIKit


class CitiesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    var citiesArray = ["New York", "Oakland", "Los Angeles", "Miami", "Las Vegas", "San Francisco"]
    var myArea: String?

    @IBOutlet weak var citiesTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Cities"
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cell")
        cell?.backgroundColor = UIColor.clearColor()
        
        cell?.textLabel!.text = citiesArray[indexPath.row]
   
        
        
        cell?.textLabel?.font = UIFont(name: "Verdana", size: 13)
        cell?.contentView.backgroundColor = UIColor.clearColor()
        
        return cell!
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return (citiesArray.count)
        
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let currentCell = tableView.cellForRowAtIndexPath(indexPath) as UITableViewCell!;
        
        myArea = currentCell.textLabel!.text
        print(myArea)
//        performSegueWithIdentifier("eventsSegue", sender: self)
        
        
    }

    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        //        if segue.identifier == "eventsSegue" {
        //            var eventsVC = segue.destinationViewController as! EventsViewController
        //            eventsVC.selectedCity = myArea
        //
        //        }
        let eventsVC = segue.destinationViewController as! EventsViewController
        let selectedPath = self.citiesTableView.indexPathForCell(sender as! UITableViewCell)
        myArea = citiesArray[(selectedPath?.row)!]
    }
    
//     func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject) {
//
//        
//    }
    
    
    

}