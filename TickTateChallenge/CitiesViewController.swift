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

    @IBOutlet weak var citiesTableView: UITableView!
    
    
    override func viewDidLoad() {
        
        self.viewDidLoad()
        
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
        
    }



}