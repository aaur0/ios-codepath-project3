//
//  TweetsViewController.swift
//  TwitterClient
//
//  Created by Anand Gupta on 9/29/15.
//  Copyright © 2015 walmartlabs. All rights reserved.
//

import UIKit

class TweetsViewController: UIViewController {

    var tweets : [Tweet]?
    
    @IBAction func onLogout(sender: AnyObject) {
        User.currentUser?.logout()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        TwitterAPIClient.sharedInstance.homeTimeLineWithCompletion([:] , completion: {(tweets, error) -> () in
                self.tweets = tweets
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
