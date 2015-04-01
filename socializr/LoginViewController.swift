//
//  LoginViewController.swift
//  socializr
//
//  Created by Max Saienko on 3/30/15.
//  Copyright (c) 2015 Max Saienko. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBAction func FBLoginClick(sender: UIButton) {
        var permissions = ["public_profile", "email"]
        
        PFFacebookUtils.logInWithPermissions(permissions, {
            (user: PFUser!, error: NSError!) -> Void in
            if let user = user {
                if (user.isNew) {
                    println("User signed up and logged in through Facebook!")
                    println(user)
                } else {
                    println("User logged in through Facebook!")
                    println(user)
                }
            } else {
                println("Uh oh. The user cancelled the Facebook login.")
            }
        })
        
        println(PFUser.currentUser())
        
//        var usr:PFUser = PFUser.currentUser()
//        
//        println("usr=\(usr) -- \(usr.email) -- \(usr.username)")
    }
    
    @IBAction func FBLogoutClick(sender: UIButton) {
        PFUser.logOut()
    }
    
    @IBAction func GetDataClick(sender: UIButton) {
        LoginViewController.obtainUserNameAndFbId()
    }
    
    
    class func obtainUserNameAndFbId() {
//        if notLoggedIn() {
//            return
//        }
        
        let user = PFUser.currentUser() // Won't be nil because is logged in
        // RETURN IF WE ALREADY HAVE A USERNAME AND FBID (note that we check the fbId because Parse automatically fills in the username avec random numbers)
        if let fbId = user["fbId"] as? String {
            if !fbId.isEmpty {
                println("we already have a username and fbId -> return")
                return
            }
        }
        // REQUEST TO FACEBOOK
        println("performing request to FB for username and IDF...")
        if let session = PFFacebookUtils.session() {
            if session.isOpen {
                println("session is open")
                FBRequestConnection.startForMeWithCompletionHandler({ (connection: FBRequestConnection!, result: AnyObject!, error: NSError!) -> Void in
                    println("done me request")
                    if (error != nil) {
                        println("facebook me request - error is not nil :(")
                    } else {
                        println("facebook me request - error is nil :)")
                        println(result)
                        // You have 2 ways to access the result:
                        // 1)
                        println(result["name"])
                        println(result["id"])
                        println(result["gender"])
                        // 2)
                        //println(result.name)
                        //println(result.objectID)
                        // Save to Parse:
                        PFUser.currentUser().username = result.name
                        PFUser.currentUser().email = result.email
                        PFUser.currentUser().setValue(result["gender"], forKey: "gender")
                        PFUser.currentUser().setValue(result.objectID, forKey: "fbId")
                        
                        // Always use saveEventually if you want to be sure that the save will succeed
                        PFUser.currentUser().saveEventually({ (success:Bool, error:NSError!) -> Void in
                            println("Save eventually. Success=\(success)")
                        })
                    }
                })
            }
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBarHidden = true
    }

}