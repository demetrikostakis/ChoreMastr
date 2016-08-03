//
//  AuthenticationPage.swift
//  ChoreMastr
//
//  Created by Demetri Kostakis on 4/10/16.
//  Copyright © 2016 ChoreMastr. All rights reserved.
//  
//  AuthenticationPage.swift file creates a view for either logging in or signing up. This one file is dynamic and depends on the button pressed on the start page.
//

import UIKit
import Firebase

var newAccount: User = User()

class AuthenticationPage: UITableViewController {
    
    //cell identifier strings
    let standardIdentifier = "reuseIdentifier"
    let providerIdentifier = "providerSignUp"
    
    //header text
    let logInHeader = "Sign in to ChoreMastr"
    let signUpHeader = "Sign Up for ChoreMastr"
    
    //segue identifiers
    let standardSignUpIdentifier = "standardSignUp"
    let providerSignUpIdentifier = "providerSignUp"
    let logInIdentifier = "logIn"
    
    //IBOutlets
    @IBOutlet weak var header: UILabel!
    @IBOutlet weak var rightBarButton: UIBarButtonItem!
    
    
    //Textfields
    var emailField = UITextField()
    var passwordField = UITextField()
    var confirmPasswordField = UITextField()
    
    //type of page; could be a sign up screen or a log in screen
    var pageType: AuthenticationType!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hideKeyboardWhenTappedAround()
        
        if pageType == .LogIn{
            header.text = logInHeader
            rightBarButton.title = "Log in"
        }else{
            header.text = signUpHeader
            rightBarButton.title = "Next"
        }
        
        transparentNavigationBar(self.navigationController!)
        
        //makes sure that there are no trailing cells
        self.tableView.tableFooterView = UIView()
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.Light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        
        self.tableView.backgroundView = blurEffectView
        
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        
        
        if pageType == .LogIn{
            return 1
        }else{
            return 1
        }
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if pageType == .LogIn{
            return 2
        }else{
            return 4
        }
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        if pageType == .LogIn{
            switch indexPath.row{
            case 0:
                let cell = tableView.dequeueReusableCellWithIdentifier(standardIdentifier, forIndexPath: indexPath) as! TextFieldCell
                cell.textField.placeholder = "Email or username"
                emailField = cell.textField
                return cell
            default:
                let cell = tableView.dequeueReusableCellWithIdentifier(standardIdentifier, forIndexPath: indexPath) as! TextFieldCell
                cell.textField.placeholder = "Password"
                passwordField = cell.textField
                passwordField.secureTextEntry = true
                return cell
            }
        }else{
            switch indexPath.row{
            case 0:
                let cell = tableView.dequeueReusableCellWithIdentifier(standardIdentifier, forIndexPath: indexPath) as! TextFieldCell
                cell.textField.placeholder = "Email or username"
                emailField = cell.textField
                return cell
            case 1:
                let cell = tableView.dequeueReusableCellWithIdentifier(standardIdentifier, forIndexPath: indexPath) as! TextFieldCell
                cell.textField.placeholder = "Password"
                cell.textField.secureTextEntry = true
                passwordField = cell.textField
                return cell
            case 2:
                let cell = tableView.dequeueReusableCellWithIdentifier(standardIdentifier, forIndexPath: indexPath) as! TextFieldCell
                cell.textField.placeholder = "Re-enter password"
                cell.textField.secureTextEntry = true
                confirmPasswordField = cell.textField
                return cell
            default:
                let cell = tableView.dequeueReusableCellWithIdentifier(providerIdentifier, forIndexPath: indexPath) as! ButtonCell
                return cell
            }
        }
        
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if self.pageType == .SignUp && indexPath.section == 2{
            return 60
        }
        return 44
    }
    
    //removes this view from the superview on the back button
    @IBAction func back(){
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func completeForm(){
        
        if self.pageType == .LogIn{
            //Segue authenticates and brings user to profile page
            let email = emailField.text
            let password = passwordField.text
            self.logInUser(email!, password: password!, viewController: self)
        }else{
            newAccount.email = emailField.text!
            
            //Checks to make sure a valid email is entered
            if emailField.text?.containsString("@") == true{
                //checks to make sure the user enters the password the same in both boxes
                if passwordField.text == confirmPasswordField.text{
                    newAccount.password = passwordField.text!
                    
                    //Now we check to make sure the email is not already in use
                    appRef.child("User").queryEqualToValue(newAccount.email).observeSingleEventOfType(FIRDataEventType.Value, withBlock: {
                        snapshot in
                        if snapshot.exists(){
                            self.createAlert("Email in use", message: "Please enter a different email", viewController: self)
                            print("Email already in use")
                        }else{
                            self.performSegueWithIdentifier(self.standardSignUpIdentifier, sender: self)
                        }
                    })
                    
                }else{
                    //This is when the passwords don't match. suggestion: add alert
                    self.createAlert("Passwords don't match", message: "Re-type password", viewController: self)
                    print("Passwords don't match")
                }

            }else{
                self.createAlert("Invalid email", message: "Please enter a valid email and try again.", viewController: self)
            }
            
        }
        
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if tableView.numberOfSections > 1{
            if section == 0{
                return ""
            }
            return " "
        }else{
            return ""
        }
    }

    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    

}

enum AuthenticationType{
    case SignUp
    case LogIn
}


//ButtonCell class is used to create a rounded button
class ButtonCell: UITableViewCell{
    
    @IBOutlet weak var authButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        authButton.layer.cornerRadius = 10
        authButton.clipsToBounds = true
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

    
}

class TextFieldCell: UITableViewCell{
    
    @IBOutlet weak var textField: UITextField!
    var placeholderText = "Placeholder"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        textField.placeholder = placeholderText
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }

}
