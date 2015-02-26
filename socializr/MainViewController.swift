//
//  ViewController.swift
//  socializr
//
//  Created by Max Saienko on 2/26/15.
//  Copyright (c) 2015 Max Saienko. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, UITableViewDelegate {
    
    @IBAction func ButtonClick(sender: UIButton) {
    
        let eventsViewController: EventsViewController = self.storyboard?.instantiateViewControllerWithIdentifier("eventsView") as EventsViewController
        
        self.navigationController?.pushViewController(eventsViewController, animated: true)
        
        println(eventsViewController)
    }
    
    var cellContent = ["One", "Two", "Three", "Four"]

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBarHidden = true
        // Do any additional setup after loading the view, typically from a nib.
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
        let gameViewController: EventsViewController = self.storyboard?.instantiateViewControllerWithIdentifier("eventsView") as EventsViewController
        
        self.navigationController?.pushViewController(gameViewController, animated: true)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        println("segue")
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    
}

