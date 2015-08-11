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
        ParseFacebook.logInWithFacebook({() -> Void in
            let mainViewController = self.storyboard?.instantiateViewControllerWithIdentifier("mainView") as! MainViewController
            Console.log("Before redirect")
            self.navigationController?.pushViewController(mainViewController, animated: true)
        })
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBarHidden = true
        if(ParseFacebook.loggedIn()) {
            Console.log("User is already logged in")
            let mainViewController = self.storyboard?.instantiateViewControllerWithIdentifier("mainView") as! MainViewController
            self.navigationController?.pushViewController(mainViewController, animated: true)
        }
    }
}