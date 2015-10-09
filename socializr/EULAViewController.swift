//
//  EULAViewController.swift
//  socializr
//
//  Created by Max Saienko on 10/8/15.
//  Copyright © 2015 Max Saienko. All rights reserved.
//

import UIKit

@available(iOS 8.0, *)
class EULAViewController: UIViewController {
    
    @IBOutlet var webViewEULA: UIWebView!
    
    override func viewDidLoad() {
        let url = NSBundle.mainBundle().URLForResource("EULAtext", withExtension:"html")
        let request = NSURLRequest(URL: url!)
        webViewEULA.loadRequest(request)
    }
    
    override func viewDidAppear(animated: Bool) {
        
    }
}