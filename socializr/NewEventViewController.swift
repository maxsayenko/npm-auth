//
//  NewEventViewController.swift
//  socializr
//
//  Created by Max Saienko on 2/26/15.
//  Copyright (c) 2015 Max Saienko. All rights reserved.
//

import UIKit
import MapKit

class NewEventViewController: UIViewController {

    @IBOutlet var locationLabel: UILabel!
    
    @IBAction func addButtonClick(sender: UIBarButtonItem) {
        
    }
    
    override func viewDidAppear(animated: Bool) {
        if(Singleton.sharedInstance.eventLocation != nil) {
            locationLabel.text = "Set"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
