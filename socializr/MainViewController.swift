//
//  ViewController.swift
//  socializr
//
//  Created by Max Saienko on 2/26/15.
//  Copyright (c) 2015 Max Saienko. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, UITableViewDelegate {

    var cellContent = ["One", "Two", "Three", "Four"]
    
    @IBAction func ButtonClick(sender: UIButton) {
        let eventsViewController = self.storyboard?.instantiateViewControllerWithIdentifier("eventsView") as EventsViewController
        self.navigationController?.pushViewController(eventsViewController, animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBarHidden = true
        
        NSNotificationCenter.defaultCenter().removeObserver(self)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateList:", name: "EventsUpdated", object: nil)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Get Cell Count
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellContent.count
    }
    
    // Populate table items
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "Cell")
        
        cell.textLabel?.text = cellContent[indexPath.row]
        
        return cell
    }
    
    // Cell Click
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //CODE TO BE RUN ON CELL TOUCH
        let eventsViewController = self.storyboard?.instantiateViewControllerWithIdentifier("eventsView") as EventsViewController
        self.navigationController?.pushViewController(eventsViewController, animated: true)
    }
    
    func updateList(notification: NSNotification) {
        var events = notification.userInfo
//        for e in self.events {
//            println(e)
//        }
    }
    
}

