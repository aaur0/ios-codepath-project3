//
//  User.swift
//  TwitterClient
//
//  Created by Anand Gupta on 9/28/15.
//  Copyright © 2015 walmartlabs. All rights reserved.
//

import UIKit

var _currentUser :  User?
let currentUserKey = "kCurrentUserKey"
let userDidLogoutNotification = "userDidLogoutNotification"

class User: NSObject {
    var name : String?
    var screenname : String?
    var profileImageURL : String?
    var tagLine : String?
    var dictionary:NSDictionary


    init(dictionary: NSDictionary){
        self.dictionary = dictionary
        self.name = dictionary["name"] as? String
        self.screenname = dictionary["screen_name"] as? String
        self.profileImageURL = dictionary["profile_image_url"] as? String
        self.tagLine = dictionary["description"] as? String
    }
    
    
    func logout(){
        User.currentUser = nil
        TwitterAPIClient.sharedInstance.requestSerializer.removeAccessToken()
        NSNotificationCenter.defaultCenter().postNotificationName(userDidLogoutNotification, object: nil)
    }
    class var currentUser: User? {
        get {
            if _currentUser == nil {
              var data =   NSUserDefaults.standardUserDefaults().objectForKey(currentUserKey)as? NSData
                if data != nil {
                var dictionary = try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions(rawValue: 0)) as! NSDictionary
                _currentUser = User(dictionary: dictionary)
        }
        }
            return _currentUser
        }
        set(user) {
            _currentUser = user
            if _currentUser != nil {
                var data = try! NSJSONSerialization.dataWithJSONObject(user!.dictionary, options: NSJSONWritingOptions(rawValue: 0))
                NSUserDefaults.standardUserDefaults().setObject(data, forKey: currentUserKey)
                

            } else {
                NSUserDefaults.standardUserDefaults().setObject(nil, forKey: currentUserKey)
            }
            NSUserDefaults.standardUserDefaults().synchronize()
        }
    }
}
