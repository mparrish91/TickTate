//
//  MyCityPromptVC.swift
//  TickTateChallenge
//
//  Created by Malcolm Parrish on 1/9/16.
//  Copyright © 2016 mparrish. All rights reserved.
//

import UIKit
import Parse


class MyCityPromptVC: UIViewController {
    
    
    @IBOutlet weak var myCityTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Ticktate"
}
    
    
    @IBAction func onSubmitButtonPressed(sender: AnyObject) {
        guard let inputText = self.myCityTextField.text
            else { return }
        
        //store text in parse
        var city = PFObject(className:"UserCity")
        city["username"] = PFUser.currentUser()?.username
        city["city"] = inputText
        city.saveInBackgroundWithBlock {
            (success: Bool, error: NSError?) -> Void in
            if (success) {
                // The object has been saved.
                print("User city saved")
                
                //throw Alert Controller
                
                let alertController = UIAlertController(title: "Thank you", message: "We have noted your submission", preferredStyle: .Alert)
                
                
                let OKAction = UIAlertAction(title: "OK", style: .Default) { (action:UIAlertAction!) in
                }
                alertController.addAction(OKAction)
                
                self.presentViewController(alertController, animated: true, completion:nil)
            } else {
                // There was a problem, check error.description
                print(error?.description)
            }
        }
        
        
    }
    
    
}