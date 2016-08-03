//
//  UpdateAccount.swift
//  ChoreMastr
//
//  Created by Demetri Kostakis on 4/14/16.
//  Copyright © 2016 ChoreMastr. All rights reserved.
//

import UIKit
import Firebase
import CoreLocation

class UpdateAccount: UITableViewController, UITextFieldDelegate {

    let reuseIdentifier = "reuseIdentifier"
    let passwordUpdatedIdentifier = "passwordUpdated"
    
    //local UI variables
    @IBOutlet weak var headerLabel: UILabel!
    
    //Change Password
    var currentPasswordField: UITextField = UITextField()
    var newPasswordField: UITextField = UITextField()
    var confirmNewPasswordField: UITextField = UITextField()
    //Edit/Add Address
    var addressField: UITextField = UITextField()
    //Edit Display Name
    var nameField: UITextField = UITextField()
    var saveButton: UIBarButtonItem!
    
    
   
    
    var pageType: EditAccountType = .ChangePassword
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hideKeyboardWhenTappedAround()
        
        removeNavigationSeparator(self.navigationController!)
        
        //changes save button action to type of page
        saveButton = UIBarButtonItem(title: "Save", style: .Done, target: self, action: #selector(UpdateAccount.updatePassword))
        switch pageType{
        case .ChangePassword:
            saveButton.action = #selector(UpdateAccount.updatePassword)
            headerLabel.text = "Update your password"
        case .UpdateAddress:
            saveButton.action = #selector(UpdateAccount.updateAddress)
            headerLabel.text = "Update your address"
        case .ChangeDisplayName:
            saveButton.action = #selector(UpdateAccount.changeDisplayName)
            headerLabel.text = "Update your display name"
        default:
            saveButton.action = #selector(UpdateAccount.updatePayment)
            headerLabel.text = "Update your payment method"
        }
        
        saveButton.enabled = false
        self.navigationItem.rightBarButtonItem = saveButton
        
        
        
        
        //makes sure that there are no trailing cells
        self.tableView.tableFooterView = UIView()
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        
        switch pageType{
        case .ChangePassword:
            return 2
        case .UpdateAddress:
            return 1
        case .ChangeDisplayName:
            return 1
        default:
            return 1
        }
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        switch pageType{
        case .ChangePassword:
            if section == 0{
                return 1
            }
            return 2
        case .UpdateAddress:
            return 1
        case .ChangeDisplayName:
            return 1
        default:
            return 1
        }
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return EditAccountCells(tableView, indexPath: indexPath)
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if pageType == .ChangePassword{
            if section == 1{
                return "New password"
            }else{
                return "Old password"
            }
        }else{
            return ""
        }
    }

    // Mark: - updateData functions
    func updatePassword(){
        if currentUser.password == currentPasswordField.text! && newPasswordField.text! == confirmNewPasswordField.text!{
            FIRAuth.auth()?.currentUser!.updateEmail(newPasswordField.text!, completion: {
                error in
                if (error != nil) {
                    // an error occurred while attempting login
                    switch(error!.code) {
                    case FIRAuthErrorCode.ErrorCodeUserNotFound.rawValue:
                        // Handle invalid user
                        print("User Does Not Exist")
                        self.createAlert("Invalid Credentials", message: "User does not exist", viewController: self)
                        break;
                    case FIRAuthErrorCode.ErrorCodeInvalidEmail.rawValue:
                        // Handle invalid email
                        self.createAlert("Invalid Credentials", message: "Invalid email address", viewController: self)
                        print("Invalid Email")
                        break;
                    case FIRAuthErrorCode.ErrorCodeWrongPassword.rawValue:
                        // Handle invalid password
                        self.createAlert("Invalid Credentials", message: "Invalid password", viewController: self)
                        print("Invalid Email")
                        break;
                    case FIRAuthErrorCode.ErrorCodeNetworkError.rawValue:
                        //Handle network errors
                        self.createAlert("Network Error", message: "Oops! There was an error connecting to the server. Check your internet connection and try again", viewController: self)
                        print("Network Error")
                    default:
                        break;
                    }
                }else{
                    appRef.child("User/\(currentUser.userID)").updateChildValues(["password": self.newPasswordField.text!])
                    currentUser.password = self.newPasswordField.text!
                    self.performSegueWithIdentifier(self.passwordUpdatedIdentifier, sender: self)
                    
                }
            })
        }else{
            if self.currentPasswordField.text! != currentUser.password{
                self.createAlert("Could not update password", message: "Current password is incorrect", viewController: self)
            }else{
                self.createAlert("Could not update password", message: "New passwords do not match", viewController: self)
            }
        }
    }
    
    func updateAddress(){
        let newAddress = self.addressField.text
        let geocoder = CLGeocoder()
        
        geocoder.geocodeAddressString(newAddress!, completionHandler: {
            placemarks, error in
            
            if error != nil{
                
            }else{
                let placemark = placemarks?.first
                if let subThouroughfare = placemark!.subThoroughfare{
                    let addressDictionary = ["subThoroughfare": subThouroughfare, "thoroughfare":placemark!.thoroughfare!, "locality": placemark!.locality!, "administrativeArea":placemark!.administrativeArea!]
                    appRef.child("User/\(currentUser.userID)").updateChildValues(["address": addressDictionary])
                    currentUser.address = addressDictionary
                    self.performSegueWithIdentifier(self.passwordUpdatedIdentifier, sender: self)
                }else{
                    self.createAlert("Invalid address", message: "The address you entered is not valid. Please check your input and try again.", viewController: self)
                }
            }
            
        })
        
        
    }
    
    func changeDisplayName(){
        appRef.child("User/\(currentUser.userID)").updateChildValues(["displayName": self.nameField.text!])
        currentUser.displayName = self.nameField.text!
        self.performSegueWithIdentifier(self.passwordUpdatedIdentifier, sender: self)
    }
    
    func updatePayment(){
        
    }
    
    // MARK: - TextView Delegate methods
    func textFieldDidBeginEditing(textField: UITextField) {
        self.saveButton.enabled = true
    }
    
    // MARK: - Custom functions to change tableview depending on page type
    
    func EditAccountCells(tableView: UITableView, indexPath: NSIndexPath) -> UITableViewCell{
        
        switch self.pageType{
        case .ChangePassword:
            
            let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath) as! TextFieldCell
            cell.textField.delegate = self
            switch indexPath.section{
            case 0:
                cell.textField.placeholder = "Enter current password"
                
                currentPasswordField = cell.textField
            case 1:
                if indexPath.row == 0{
                    cell.textField.placeholder = "Enter new password"
                    newPasswordField = cell.textField
                }else{
                    cell.textField.placeholder = "Re-enter new password"
                    confirmNewPasswordField = cell.textField
                }
            default:
                break
            }
            
            return cell
        case EditAccountType.UpdateAddress:
            
            let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath) as! TextFieldCell
            cell.textField.delegate = self
            cell.textField.placeholder = "Enter address"
            addressField = cell.textField
            
            return cell
        case EditAccountType.ChangeDisplayName:
            let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath) as! TextFieldCell
            cell.textField.delegate = self
            cell.textField.placeholder = "Enter display name"
            nameField = cell.textField
            
            return cell
        default:
            
            //incomplete implementation
            let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath) as! TextFieldCell
            
            return cell
        
        }
        
        
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == self.passwordUpdatedIdentifier{
            let destinationVC = segue.destinationViewController as! AccountPage
            destinationVC.tableView.reloadData()
        }
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    

}

enum EditAccountType{
    case ChangePassword
    case UpdateAddress
    case ChangeDisplayName
    case UpdatePayment
}
