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
            let mainViewController = self.storyboard?.instantiateViewControllerWithIdentifier("mainView") as MainViewController
            self.navigationController?.pushViewController(mainViewController, animated: true)
        })
    }
    
//    @IBAction func FBLogoutClick(sender: UIButton) {
//        ParseFacebook.logOut()
//    }
//    
//    @IBAction func GetDataClick(sender: UIButton) {
//        ParseFacebook.obtainUserNameAndFbId()
//    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBarHidden = true
        //self.navigationController?.pushViewController(eventsViewController, animated: true)
        //println(PFUser.currentUser())
    }
}