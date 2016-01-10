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
        if self.myCityTextField.text?.characters.count == 0 {
            return
        }else{
            //story text in parse
            
            var city = PFObject(className:"UserCity")
            city["username"] = PFUser.currentUser()?.username
            city["city"] = myCityTextField.text
            
            city.saveInBackgroundWithBlock {
                (success: Bool, error: NSError?) -> Void in
                if (success) {
                    // The object has been saved.
                } else {
                    // There was a problem, check error.description
                }
            }

            
        }
        
        
    }
    
    
}