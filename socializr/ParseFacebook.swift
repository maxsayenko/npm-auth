//
//  ParseFacebook.swift
//  socializr
//
//  Created by Max Saienko on 4/1/15.
//  Copyright (c) 2015 Max Saienko. All rights reserved.
//

import Foundation

class ParseFacebook {
    
    class func notLoggedIn() -> Bool {
        let user = PFUser.currentUser()
        // here I assume that a user must be linked to Facebook
        return user == nil || !PFFacebookUtils.isLinkedWithUser(user!)
    }
    
    class func loggedIn() -> Bool {
        return !notLoggedIn()
    }
    
    class func logInWithFacebook(completion: (() -> Void)!) -> Void {
        var permissions = ["public_profile", "email"]
        
        PFFacebookUtils.logInWithPermissions(permissions) {
            (user: PFUser?, error: NSError?) -> Void in
            if (user == nil) {
                Console.log("The user cancelled the Facebook login (user is nil)")
            } else {
                Console.log("The user successfully logged in with Facebook (user is NOT nil)")
                // HERE I SET AN ACL TO THE INSTALLATION
                //TODO: Check if we need this
                //                if let installation = PFInstallation.currentInstallation() {
                //                    let acl = PFACL(user: PFUser.currentUser()) // Only user can write
                //                    acl.setPublicReadAccess(true) // Everybody can read
                //                    acl.setWriteAccess(true, forRoleWithName: "Admin") // Also Admins can write
                //                    installation.ACL = acl
                //                    installation.saveEventually({ (success:Bool, error:NSError!) -> Void in
                //                        println("Save eventually logInWithFacebook. Success=\(success)")
                //                    })
                //                }
                // THEN I GET THE USERNAME AND fbId
                ParseFacebook.obtainUserNameAndFbId()
                
                if(completion != nil) {
                    completion()
                }
            }
        }
    }
    
    class func logOut() -> Void
    {
        PFUser.logOut()
    }
    
    class func obtainUserNameAndFbId() {
        if notLoggedIn() {
            return
        }
        
        let user: PFUser? = PFUser.currentUser() // Won't be nil because is logged in
        // RETURN IF WE ALREADY HAVE A USERNAME AND FBID (note that we check the fbId because Parse automatically fills in the username with random numbers)
        
        if let fbId = user!["fbId"] as? String {
            if (!fbId.isEmpty) {
                Console.log("we already have a username and fbId -> return")
                return
            }
        }
        
        // REQUEST TO FACEBOOK
        Console.log("performing request to FB for username and IDF...")
        if let session = PFFacebookUtils.session() {
            if (session.isOpen) {
                Console.log("session is open")
                FBRequestConnection.startForMeWithCompletionHandler({ (connection: FBRequestConnection!, result: AnyObject!, error: NSError!) -> Void in
                    Console.log("done me request")
                    if (error != nil) {
                        Console.log("facebook me request - error is not nil :(")
                    } else {
                        Console.log("facebook me request - error is nil :)")
                        Console.log(result)
                        // You have 2 ways to access the result:
                        // 1)
                        //                        println(result["name"])
                        //                        println(result["id"])
                        //                        println(result["gender"])
                        // 2)
                        //println(result.name)
                        //println(result.objectID)
                        // Save to Parse:
                        PFUser.currentUser()!.username = result.name
                        PFUser.currentUser()!.email = result.email
                        PFUser.currentUser()!.setValue(result["gender"], forKey: "gender")
                        PFUser.currentUser()!.setValue(result.objectID, forKey: "fbId")
                        
                        
                        // Always use saveEventually if you want to be sure that the save will succeed
                        PFUser.currentUser()?.saveEventually({ (success:Bool, error:NSError?) -> Void in
                            Console.log("Save eventually. Success=\(success)")
                        })
                    }
                })
            }
        }   
    }
    
    static func getCurrentUser() -> AnyObject {
        return ["fbId": PFUser.currentUser()!["fbId"] as! String, "name": PFUser.currentUser()!.username! as String]
    }
}