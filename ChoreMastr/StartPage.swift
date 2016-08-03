//
//  ViewController.swift
//  ChoreMastr
//
//  Created by Demetri Kostakis on 4/10/16.
//  Copyright © 2016 ChoreMastr. All rights reserved.
//
//  This file is the viewcontroller for the very first view in the app if you are not logged in. Allows the user to chose whether or not to sign into an existing account or sign up

import UIKit
import QuartzCore
import Firebase
import CoreLocation

class ViewController: UIViewController {

    let segueIdentifier = "toAuthentication"
    let autoAuthenticateIdentifier = "autoLogIn"
    
    var authType: AuthenticationType?
    
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var logInButton: UIButton!
    
    //determines if there is a user logged in from previous session
    override func viewDidAppear(animated: Bool) {
        
        if FIRAuth.auth()?.currentUser != nil{
            loadUser((FIRAuth.auth()?.currentUser?.uid)!)
            self.performSegueWithIdentifier(autoAuthenticateIdentifier, sender: nil)
        }else{
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func signUp(){
        
        self.authType = .SignUp
        self.performSegueWithIdentifier(segueIdentifier, sender: self)
    }
    
    @IBAction func logIn(){
        self.authType = .LogIn
        self.performSegueWithIdentifier(segueIdentifier, sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == segueIdentifier{
            let destinationVC = (segue.destinationViewController as! UINavigationController).viewControllers[0] as! AuthenticationPage
            destinationVC.pageType = self.authType!
        }
    }


}

//Need to add custom functions for firebase methods
extension UIViewController{
    
    //adds rounded corner to a button
    
    func roundCorners(button: UIButton){
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
    }
    
    //removes separator between nav bar and view
    func removeNavigationSeparator(navigationController: UINavigationController){
        navigationController.navigationBar.translucent = false
        navigationController.navigationBar.shadowImage = UIImage()
        navigationController.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
    }
    
    func transparentNavigationBar(navigationController: UINavigationController){
        navigationController.navigationBar.translucent = true
        navigationController.navigationBar.shadowImage = UIImage()
        navigationController.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
    }
    
    
    //Firebase URL: https://choremastr.firebaseio.com
    
    func loadUser(userID: String){
        //finds that user in the database
        let usersRef = appRef.child("User")
        usersRef.queryOrderedByChild(userID).observeSingleEventOfType(FIRDataEventType.Value, withBlock: {
            snapshot in
            
            if snapshot.exists(){
                
                //gets the snapshot of the user
                let currentUserSnapshot = snapshot.childSnapshotForPath(userID)
                
                //assigns values to the current user
                currentUser.userID = userID
                currentUser.didAcceptUserAgreement =  currentUserSnapshot.value!["didAcceptUserAgreement"] as! Bool
                currentUser.address = currentUserSnapshot.value!["address"] as! [String: String]
                //Checks the type of user since firebase can't store enums
                if  currentUserSnapshot.value!["userType"] as! String == "Standard"{
                    currentUser.userType == .Standard
                }else{
                    currentUser.userType == .Helper
                }
                currentUser.displayName =  currentUserSnapshot.value!["displayName"] as! String
                currentUser.email = currentUserSnapshot.value!["email"] as! String
                currentUser.password = currentUserSnapshot.value!["password"] as! String
                
            }//closure for snapshot.exists()
            
        })//closure for query

    }
    
    func logInUser(email: String, password: String, viewController: UIViewController){
        FIRAuth.auth()?.signInWithEmail(email, password: password, completion: {
            user, error in
            if (error != nil) {
                // an error occurred while attempting login
                switch(error!.code) {
                case FIRAuthErrorCode.ErrorCodeUserNotFound.rawValue:
                    // Handle invalid user
                    print("User Does Not Exist")
                    viewController.createAlert("Invalid Credentials", message: "User does not exist", viewController: viewController)
                    break;
                case FIRAuthErrorCode.ErrorCodeInvalidEmail.rawValue:
                    // Handle invalid email
                    viewController.createAlert("Invalid Credentials", message: "Invalid email address", viewController: viewController)
                    print("Invalid Email")
                    break;
                case FIRAuthErrorCode.ErrorCodeWrongPassword.rawValue:
                    // Handle invalid password
                    viewController.createAlert("Invalid Credentials", message: "Invalid password", viewController: viewController)
                    print("Invalid Email")
                    break;
                case FIRAuthErrorCode.ErrorCodeNetworkError.rawValue:
                    //Handle network errors
                    viewController.createAlert("Network Error", message: "Oops! There was an error connecting to the server. Check your internet connection and try again", viewController: viewController)
                    print("Network Error")
                default:
                    break;
                }
            } else{
                // User is logged in
                currentUser.email = email
                currentUser.password = password
                currentUser.userID = (FIRAuth.auth()?.currentUser?.uid)!
                
                //finds that user in the database
                let usersRef = appRef.child("User")
                usersRef.queryOrderedByChild(currentUser.userID).observeSingleEventOfType(FIRDataEventType.Value, withBlock: {
                    snapshot in
                    
                    if snapshot.exists(){
                        
                        let currentUserSnapshot = snapshot.childSnapshotForPath(currentUser.userID)
                        
                        currentUser.didAcceptUserAgreement =  currentUserSnapshot.value!["didAcceptUserAgreement"] as! Bool
                        currentUser.address = currentUserSnapshot.value!["address"] as! [String: String]
                        if  currentUserSnapshot.value!["userType"] as! String == "Standard"{
                            currentUser.userType == .Standard
                        }else{
                            currentUser.userType == .Helper
                        }
                        
                        currentUser.displayName =  currentUserSnapshot.value!["displayName"] as! String
                        
                        viewController.performSegueWithIdentifier("logIn", sender: viewController)
                        
                    }//closure for snapshot.exists()
                    
                })//closure for query
                
                //Sets the listeners for the current user to sync data all the time
                usersRef.queryOrderedByChild(currentUser.userID).observeEventType(FIRDataEventType.ChildChanged, withBlock: {
                    snapshot in
                    
                    
                    
                })
                
            }//closure for else statement

        })//closure for initial closure
        
    }
    
    //Used in generating the address of a new user
    func generateNewUserWithAddressLocationData(address: String, segueIdentifier: String, viewController: UIViewController){
        
        let geocoder: CLGeocoder = CLGeocoder()
        
        geocoder.geocodeAddressString(address, completionHandler: {placemarks,error in
            
            if error != nil{
                if error?.domain == kCLErrorDomain{
                    switch error!.code{
                        
                    case CLError.LocationUnknown.rawValue:
                        viewController.createAlert("Invalid address", message: "The address you entered is not valid.", viewController: viewController)
                    case CLError.Network.rawValue:
                        viewController.createAlert("Network error", message: "Could not locate address. Please check your internet connection and try again.", viewController: viewController)
                    case CLError.GeocodeFoundNoResult.rawValue:
                        viewController.createAlert("Invalid address", message: "The address you entered is not valid.", viewController: viewController)
                    default:
                        viewController.createAlert("Invalid address", message: "The address you entered is not valid.", viewController: viewController)
                    }
                    
                }
            }else{
                if placemarks!.count > 0{
                    let placemark = placemarks!.first
                    if error != nil{
                        viewController.createAlert("Invalid address", message: "The address you entered is not valid.", viewController: viewController)
                    }else{
                        
                        //checks to make sure the address is valid. only need to check one of the aspects of the placemark
                        if let subThoroughfare = placemark?.subThoroughfare{
                            //builds address string
                            let addressDictionary = ["subThoroughfare": subThoroughfare, "thoroughfare":placemark!.thoroughfare!, "locality": placemark!.locality!, "administrativeArea":placemark!.administrativeArea!]
                            
                            newAccount.address = addressDictionary
                            
                            //creates the user if the address is valid
                            FIRAuth.auth()?.createUserWithEmail(newAccount.email, password: newAccount.password, completion: {
                                user, error in
                                if error != nil{
                                    
                                    switch error!.code{
                                    case FIRAuthErrorCode.ErrorCodeNetworkError.rawValue:
                                        viewController.createAlert("Network Error", message: "could not connect to server. Please check connection and try again", viewController: viewController)
                                    default:
                                        viewController.createAlert("Error", message: "Could not complete request", viewController: viewController)
                                    }
                                    //There was an error creating the account
                                    
                                }else{
                                    //authorizes user once account is created
                                    FIRAuth.auth()?.signInWithEmail(newAccount.email, password: newAccount.password, completion: {
                                        user, error in
                                        if error != nil{
                                            //error signing in
                                            switch error!.code{
                                            case FIRAuthErrorCode.ErrorCodeNetworkError.rawValue:
                                                viewController.createAlert("Network Error", message: "could not connect to server. Please check connection and try again", viewController: viewController)
                                            default:
                                                viewController.createAlert("Error", message: "Could not authenticate", viewController: viewController)
                                            }
                                        }else{
                                            //creates a new user in the database to save custom data
                                            newAccount.userID = user!.uid
                                            appRef.child("User/\(newAccount.userID)").setValue(newAccount.toAnyObject())
                                            currentUser = newAccount
                                            viewController.performSegueWithIdentifier(segueIdentifier, sender: viewController)
                                        }
                                    })

                                    
                                }
                            })
                        }else{
                            //if the address is invalid
                            viewController.createAlert("Error", message: "Could not complete request", viewController: viewController)
                        }
                        
                    }
                    
                }

            }
        })
    }
    
    //Creates an alert for notifying the user
    func createAlert(title: String, message: String, viewController: UIViewController){
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        let doneAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alertController.addAction(doneAction)
        viewController.presentViewController(alertController, animated: true, completion: nil)
        
    }
    
    //Allows the view to dismiss the keyboard on a tap
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    
}
