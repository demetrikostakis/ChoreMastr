//
//  SignUpPage.swift
//  ChoreMastr
//
//  Created by Demetri Kostakis on 4/10/16.
//  Copyright © 2016 ChoreMastr. All rights reserved.
//

import UIKit

class SignUp_NameEntry: UITableViewController {
    //segue Identifier
    let segueIdentifier = "mobileEntry"
    //cell Identifier
    let standardIdentifier = "reuseIdentifier"
    let skipIdentifier = "skip"
    
    //local UI elements
    var nameField: UITextField = UITextField()
    @IBOutlet weak var navItem: UINavigationItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hideKeyboardWhenTappedAround()
        
        removeNavigationSeparator(self.navigationController!)
        
        //makes sure that there are no trailing cells
        self.tableView.tableFooterView = UIView()
        
        //adds bar button item for navigation
        let nextButton = UIBarButtonItem(title: "Next", style: .Plain, target: self, action: #selector(SignUp_NameEntry.nextPage))
        navItem.rightBarButtonItem = nextButton
        
        self.tableView.tableFooterView = UIView()
        
        transparentNavigationBar(self.navigationController!)
        
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.Light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        
        self.tableView.backgroundView = blurEffectView
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return 2
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        switch indexPath.row{
        case 0:
            let cell = tableView.dequeueReusableCellWithIdentifier(standardIdentifier, forIndexPath: indexPath) as! TextFieldCell
            nameField = cell.textField
            return cell
        default:
            
            //make sure identifier is the same as IB
            let cell = tableView.dequeueReusableCellWithIdentifier(skipIdentifier, forIndexPath: indexPath)
            return cell
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        //Checks if user decides to skip this section
        if indexPath.row == 1{
            performSegueWithIdentifier(segueIdentifier, sender: self)
        }
    }
    
    // MARK: - Bar Button Item actions
    
    func nextPage(){
        if nameField.text != nil{
            newAccount.displayName = nameField.text!
            performSegueWithIdentifier(segueIdentifier, sender: self)
        }else{
            //Incomplete implementation
            print("Either skip this section or enter a name.")
        }
        
    }
 


    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    

}
