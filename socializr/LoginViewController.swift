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
        ParseFacebook.logInWithFacebook()
    }
    
    @IBAction func FBLogoutClick(sender: UIButton) {
        ParseFacebook.logOut()
    }
    
    @IBAction func GetDataClick(sender: UIButton) {
        ParseFacebook.obtainUserNameAndFbId()
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBarHidden = true
    }
}