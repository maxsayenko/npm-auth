//
//  LoginViewController.swift
//  socializr
//
//  Created by Max Saienko on 3/30/15.
//  Copyright (c) 2015 Max Saienko. All rights reserved.
//

import UIKit

@available(iOS 8.0, *)
class LoginViewController: UIViewController {
    
    @IBAction func FBLoginClick(sender: UIButton) {
        ParseFacebook.logInWithFacebook({() -> Void in
            let allEventsViewController = self.storyboard?.instantiateViewControllerWithIdentifier("allEventsViewController") as! AllEventsViewController
            Console.log("Before redirect")
            self.navigationController?.pushViewController(allEventsViewController, animated: true)
        })
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBarHidden = true
        if(ParseFacebook.isUserLoggedIn()) {
            Console.log("User is already logged in")
            let allEventsViewController = self.storyboard?.instantiateViewControllerWithIdentifier("allEventsViewController") as! AllEventsViewController
            self.navigationController?.pushViewController(allEventsViewController, animated: true)
        }
    }
}