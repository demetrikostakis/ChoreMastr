//
//  AccountPage.swift
//  ChoreMastr
//
//  Created by Demetri Kostakis on 4/11/16.
//  Copyright © 2016 ChoreMastr. All rights reserved.
//

import UIKit
import Firebase

private let reuseIdentifier = "reuseIdentifier"
private let signOutIdentifier = "signOut"
private let editAccountIdentifier = "editAccount"
private let showLegalItemIdentifier = "legal"

class AccountPage: UITableViewController {

    //Outlets
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var editProfilePictureButton: UIButton!
    
    //This segue is used for when an update action is completed in another ViewController
    @IBAction func unwindToVC(segue: UIStoryboardSegue) {
    }
    
    let account = ["Display Name","Email","Password","Change Password"]
    let payment = ["Add payment method"]
    let location = ["Location visible"]
    let legal = ["Terms and Conditions", "Privacy Policy", "User Agreement"]
    let company = ["About ChoreMastr", "Contact us"]
    
    //type of page to show
    var editDataType: EditAccountType?
    
    //for which legal document to show
    var documentName: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Makes the profile picture circular and adds a border
        profilePicture.layer.cornerRadius = profilePicture.frame.width/2
        profilePicture.clipsToBounds = true
        profilePicture.layer.borderWidth = 1
        profilePicture.layer.borderColor = UIColor.darkGrayColor().CGColor
        
        editProfilePictureButton.layer.cornerRadius = 5
        profilePicture.clipsToBounds = true

        //makes sure that there are no trailing cells
        self.tableView.tableFooterView = UIView()
        
        removeNavigationSeparator(self.navigationController!)
        
    }

       // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 6
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        switch section{
        case 0:
            return account.count
        case 1:
            return payment.count
        case 2:
            if currentUser.address != [:]{
                return location.count + 1
            }
            return location.count
        case 3:
            return legal.count
        case 4:
            return company.count
        case 5:
            return 1
        default:
            return 0
        }
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(reuseIdentifier, forIndexPath: indexPath)
        
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        cell.backgroundColor = UIColor.whiteColor()
        cell.textLabel?.textColor = UIColor.blackColor()
        
        switch indexPath.section{
        case 0:
            cell.textLabel?.text = account[indexPath.row]
            switch indexPath.row{
            case 0:
                cell.detailTextLabel?.text = currentUser.displayName
                cell.accessoryType = .DisclosureIndicator
            case 1:
                cell.detailTextLabel?.text = currentUser.email
            case 2:
                cell.detailTextLabel?.text = "**********"
            case 3:
                cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
                cell.textLabel?.textColor = UIColor.lightGrayColor()
                cell.detailTextLabel?.text = ""
                cell.selectionStyle = UITableViewCellSelectionStyle.Default
            default:
                break
            }
        case 1:
            cell.textLabel?.text = payment[indexPath.row]
            cell.detailTextLabel?.text = ""
            cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        case 2:
            switch indexPath.row{
            case 0:
                let subThoroughfair = currentUser.address["subThoroughfare"]!
                let thoroughfair = currentUser.address["thoroughfare"]!
                let locality = currentUser.address["locality"]!
                let administrativeArea = currentUser.address["administrativeArea"]!
                cell.textLabel?.text = "Address \(indexPath.row + 1)"
                cell.detailTextLabel?.text = "\(subThoroughfair) \(thoroughfair), \(locality) \(administrativeArea)"
            case 1:
                cell.textLabel?.text = "Add new address"
                cell.textLabel?.textColor = UIColor.lightGrayColor()
                cell.detailTextLabel?.text = ""
                cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
                cell.selectionStyle = UITableViewCellSelectionStyle.Default
            default:
                break
            }
            
        case 3:
            cell.textLabel?.text = legal[indexPath.row]
            cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
            cell.detailTextLabel?.text = ""
        case 4:
            cell.textLabel?.text = company[indexPath.row]
            cell.detailTextLabel?.text = ""
        case 5:
            cell.textLabel?.text = "Sign Out"
            cell.textLabel?.textColor = UIColor.whiteColor()
            cell.backgroundColor = UIColor.darkGrayColor()
            cell.selectionStyle = UITableViewCellSelectionStyle.Default
        default:
            break
        }
        
        // Configure the cell...

        return cell
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section{
        case 0:
            return "Account"
        case 1:
            return "Payment"
        case 2:
            return "Location Services"
        case 3:
            return "Legal"
        case 4:
            return "Company"
        case 5:
            return "Sign Out"
        default:
            return ""
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch indexPath.section{
        case 0:
            switch indexPath.row{
            case 0:
                self.editDataType = EditAccountType.ChangeDisplayName
                self.performSegueWithIdentifier(editAccountIdentifier, sender: self)
                
            case 3:
                self.editDataType = EditAccountType.ChangePassword
                self.performSegueWithIdentifier(editAccountIdentifier, sender: self)
                
            default:
                break
            }
        case 1:
            self.editDataType = EditAccountType.UpdatePayment
            self.performSegueWithIdentifier(editAccountIdentifier, sender: self)
        case 2:
            //incomplete implentation. doesn't include differentiation between new and existing address
            self.editDataType = EditAccountType.UpdateAddress
            self.performSegueWithIdentifier(editAccountIdentifier, sender: self)
        case 3:
            switch indexPath.row{
            case 0:
                documentName = "ChoreMastr Terms and Conditions Template"
            case 1:
                documentName = "ChoreMastr Privacy Policy Template"
            default:
                documentName = "ChoreMastr Terms of Service Template"
            }
            self.performSegueWithIdentifier(showLegalItemIdentifier, sender: self)
        case 5:
            try! FIRAuth.auth()!.signOut()
            
            self.performSegueWithIdentifier(signOutIdentifier, sender: self)
        default:
            break
        }
    }
    
   
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "editAccount"{
            let destinationVC = segue.destinationViewController as! UpdateAccount
            destinationVC.pageType = self.editDataType!
        }
        if segue.identifier == showLegalItemIdentifier{
            let destinationVC = segue.destinationViewController as! LegalPage
            destinationVC.fileName = documentName!
        }
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    

}
