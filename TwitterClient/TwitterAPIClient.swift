//
//  TwitterAPIClient.swift
//  TwitterClient
//
//  Created by Anand Gupta on 9/27/15.
//  Copyright © 2015 walmartlabs. All rights reserved.
//

import UIKit



let consumerKey = "hgXGugBRIw0McqRTjWRBsEqzz"
let consumerSecret = "rJDGWqzBDn5Ng1zlm0A0iDE9AHZtI4JoeCRqSylE4FEvFWxiqw"
let apiUrl = NSURL(string: "https://api.twitter.com")

class TwitterAPIClient: BDBOAuth1RequestOperationManager {
    var loginCompletion : ((user: User?, error:NSError?) -> ())!
    class var sharedInstance : TwitterAPIClient {
        struct Static {
                static let instance  = TwitterAPIClient(baseURL: apiUrl, consumerKey: consumerKey, consumerSecret: consumerSecret)
        }
        return Static.instance
    }
    
    func loginWithCompletion(completion : (user: User?, error:NSError?) -> ()){
        loginCompletion = completion
        
        // fetch request token and redirect to authorization
        TwitterAPIClient.sharedInstance.requestSerializer.removeAccessToken()
        TwitterAPIClient.sharedInstance.fetchRequestTokenWithPath("oauth/request_token", method: "GET", callbackURL: NSURL(string: "cptwitterdemo://oauth"), scope: nil, success: { (requestToken: BDBOAuth1Credential!) -> Void in
            let authURL = NSURL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken.token)")
            UIApplication.sharedApplication().openURL(authURL!)
            }) { (error: NSError!) -> Void in
                print("Failed")
        }
        
    }
    
    
    func homeTimeLineWithCompletion(params: NSDictionary, completion: (tweets: [Tweet]?, error: NSError?) -> ()){
        
            GET("1.1/statuses/home_timeline.json", parameters: params, success: { (operation:AFHTTPRequestOperation!, response:AnyObject!) -> Void in
            var tweets =  Tweet.tweetsWithArray(response as! [NSDictionary])
            completion(tweets: tweets, error: nil)
            }, failure: { (operation:AFHTTPRequestOperation!, error:NSError!) -> Void in
                print("unable to fetch user")
                completion(tweets: nil, error: error)
        })
        
    }
    
    
    
    
    func openURL(url:NSURL){
        fetchAccessTokenWithPath(
            "oauth/access_token", method: "POST", requestToken: BDBOAuth1Credential(queryString: url.query), success: { (accessToken: BDBOAuth1Credential!) -> Void in
                TwitterAPIClient.sharedInstance.requestSerializer.saveAccessToken(accessToken)
                TwitterAPIClient.sharedInstance.GET("1.1/account/verify_credentials.json", parameters: nil, success: { (operation:AFHTTPRequestOperation!, response:AnyObject!) -> Void in
                    var user = User(dictionary:response as! NSDictionary)
                    User.currentUser = user
                    self.loginCompletion?(user: user, error: nil)
                    }, failure: { (operation:AFHTTPRequestOperation!, error:NSError!) -> Void in
                        print("unable to fetch user")
                })
                
            }) { (error: NSError!) -> Void in
                print("error")
        }

        
    }
}
