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
    var delegate:EULAViewControllerDelegate? = nil
    
    @IBOutlet var webViewEULA: UIWebView!
    
    override func viewDidLoad() {
        // Load html content into webView
        let url = NSBundle.mainBundle().URLForResource("EULAtext", withExtension:"html")
        let request = NSURLRequest(URL: url!)
        webViewEULA.loadRequest(request)
    }
    
    @IBAction func disagreeBtnClick(sender: UIButton) {
        closeModal(false)
    }
    
    @IBAction func agreeBtnClick(sender: UIButton) {
        closeModal(true)
    }
    
    func closeModal(isEULAaccepted: Bool) -> Void {
        self.delegate?.isEULAaccepted(isEULAaccepted)
        dismissViewControllerAnimated(true, completion: nil)
    }
}

protocol EULAViewControllerDelegate {
    func isEULAaccepted(value: Bool)
}