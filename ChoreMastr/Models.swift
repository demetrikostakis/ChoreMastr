//
//  Models.swift
//  ChoreMastr
//
//  Created by Demetri Kostakis on 8/3/16.
//  Copyright © 2016 ChoreMastr. All rights reserved.
//
//  Defines the models for Users and other custom structs and enums in the app.
//

import Foundation

//MARK: - Defines User struct

struct User {
    
    var userID: String
    var email: String
    var password: String
    var displayName: String
    var address: [String:String]
    var userType: UserType
    var userData: AnyObject
    var mobileNumber: String
    //provider variables
    var didAcceptUserAgreement: Bool
    var servicesOffered: [String: AnyObject]
    var bio: String
    var schedule:[String: [String:String]]
    
    init(){
        userID = ""
        email = ""
        password = ""
        displayName = ""
        address = [:]
        didAcceptUserAgreement = false
        userType = UserType.Standard
        userData = [:]
        mobileNumber = ""
        servicesOffered = [:]
        bio = ""
        schedule = [:]
    }
    //The following functions are meant to add to the services offered variable
    mutating func addLawnMowingService(){
        self.servicesOffered["Lawn Mowing"]=["Hedging":false,"Edging":false,"Fertilizing":false,"Watering":false]
        print(self.servicesOffered)
    }
    mutating func addRakingService(){
        self.servicesOffered["Raking Leaves"]=["Disposal":false]
        print(self.servicesOffered)
    }
    mutating func addShovelingService(){
        self.servicesOffered["Shoveling Snow"]=["Walkways":false,"Porches":false,"Cars":false]
        print(self.servicesOffered)
    }
    mutating func addPlowingService(){
        self.servicesOffered["Snow Plowing"]=["Shoveling on demand":false]
        print(self.servicesOffered)
    }
    mutating func addPoolCleaningService(){
        self.servicesOffered["Pool Cleaning"]=["Apply shock":false,"Check chemicals":false]
        print(self.servicesOffered)
    }
    
    //the following functions mutate the schedule attribute
    
    mutating func addDayToSchedule(day: String, times: [String:String]){
        schedule[day] = times
    }
    //
    
    //Function allows all the user data to be saved to firebase
    func toAnyObject() -> AnyObject{
        var _userType: String = ""
        if userType == .Standard{
            _userType = "Standard"
            return [
                "email": email,
                "password": password,
                "displayName": displayName,
                "address": address,
                "didAcceptUserAgreement": didAcceptUserAgreement,
                "userType": _userType,
                "userData": userData,
                "mobileNumber": mobileNumber
                
            ]
        }else{
            _userType = "Helper"
            return [
                "email": email,
                "password": password,
                "displayName": displayName,
                "address": address,
                "didAcceptUserAgreement": didAcceptUserAgreement,
                "userType": _userType,
                "userData": userData,
                "mobileNumber": mobileNumber,
                "servicesOffered": servicesOffered,
                "bio": bio
                
            ]
        }
        
    }
    
}

enum UserType{
    case Standard
    case Helper
}

enum EditAccountType{
    case ChangePassword
    case UpdateAddress
    case ChangeDisplayName
    case UpdatePayment
}

//  SearchFilter is used in the FilterMenu file
struct SearchFilter {
    
    var searchRadius: Double
    var rating: Double
    var hourlyRate: Double
    
    init() {
        searchRadius = 7.5
        rating = 2.5
        hourlyRate = 30
    }
    
    init(radius: Double, rating: Double, rate: Double){
        self.searchRadius = radius
        self.rating = rating
        self.hourlyRate = rate
    }
}


