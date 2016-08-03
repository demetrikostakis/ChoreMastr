//
//  MessagesPage.swift
//  ChoreMastr
//
//  Created by Demetri Kostakis on 4/12/16.
//  Copyright © 2016 ChoreMastr. All rights reserved.
//

import UIKit
import TBEmptyDataSet

class MessagesPage: UITableViewController, TBEmptyDataSetDelegate, TBEmptyDataSetDataSource {

    override func viewDidLoad() {
        super.viewDidLoad()

        transparentNavigationBar(self.navigationController!)
        
        //makes sure that there are no trailing cells
        self.tableView.tableFooterView = UIView()
        
        //Assigns the emptyDataSet delegate and data source
        tableView.emptyDataSetDataSource = self
        tableView.emptyDataSetDelegate = self
        
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.Light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        
        self.tableView.backgroundView = blurEffectView
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)

        // Configure the cell...

        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */
    
    @IBAction func back(){
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: - TBEmptyDataSet Data Source
    func imageForEmptyDataSet(scrollView: UIScrollView!) -> UIImage? {
        // return the image for EmptyDataSet
        let image = UIImage(named: "icon-empty-message")
        return image
    }
    func titleForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString? {
        // return the title for EmptyDataSet
        var attributes: [String : AnyObject]?
        attributes = [NSFontAttributeName: UIFont.systemFontOfSize(22.0), NSForegroundColorAttributeName: UIColor.grayColor()]
        return NSAttributedString(string: "You don't have any messages!", attributes: attributes)
    }
    
    func descriptionForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString? {
        // return the description for EmptyDataSet
        var attributes: [String : AnyObject]?
        attributes = [NSFontAttributeName: UIFont.systemFontOfSize(17.0), NSForegroundColorAttributeName: UIColor(red: 3 / 255, green: 169 / 255, blue: 244 / 255, alpha: 1)]
        return NSAttributedString(string: "Tap the plus button to start a new chat.", attributes: attributes)
    }
    
    
    // MARK: - TBEmptyDataSet Delegate

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
