//
//  ViewController.swift
//  TwitterClient
//
//  Created by Anand Gupta on 9/27/15.
//  Copyright © 2015 walmartlabs. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    @IBAction func onLogin(sender: AnyObject) {
        
        TwitterAPIClient.sharedInstance.loginWithCompletion() {
            (user: User?, error: NSError?) in
            if user != nil {
                self.performSegueWithIdentifier("loginSeque", sender: self)
            } else {
                //handle error
            }
        }
    }
}

