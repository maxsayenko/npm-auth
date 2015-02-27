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

    var startDatePickerView : UIDatePicker = UIDatePicker()

    
    @IBOutlet var startDateTxt: UITextField!


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
        
        startDatePickerView = UIDatePicker()
        startDatePickerView.datePickerMode = UIDatePickerMode.DateAndTime
        startDateTxt.inputView = startDatePickerView
        startDatePickerView.addTarget( self, action: Selector("handelStartDatePicker:"), forControlEvents: UIControlEvents.ValueChanged)
    }
    
    func handelStartDatePicker(datePicker:UIDatePicker) {
        var dateFormatter = NSDateFormatter()
        
        dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
        dateFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
        
        var strDate = dateFormatter.stringFromDate(datePicker.date)
        startDateTxt.text =  strDate
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
