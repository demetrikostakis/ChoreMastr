//
//  UpdateHelperProfile.swift
//  ChoreMastr
//
//  Created by Demetri Kostakis on 4/16/16.
//  Copyright © 2016 ChoreMastr. All rights reserved.
//

import UIKit

private let darkGrayBackground = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 0.5)
private let lightGrayBackground = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.5)

private let imageCellIdentifier = "image"
private let bioCellIdentifier = "bio"
private let sectionTitleIdentifier = "sectionTitle"
private let choreAccessoryCellIdentifier = "choreAccessory"
private let choreScheduleCellIdentifier = "choreSchedule"

private let saveSegueIdentifier = "saveProfileData"

class UpdateHelperProfile: UICollectionViewController {

    var servicesOffered: [String] = ["Lawn Mowing","Raking Leaves"]
    
    //details for each service
    let mowingDetails:[String] = ["Hedging","Edging","Fertilizing","Watering"]
    let rakingDetails:[String] = ["Disposal"]
    let shovelingDetails: [String] = ["Walkways","Porches","Cars"]
    let plowingDetails: [String] = ["Shoveling on demand"]
    let poolDetails: [String] = ["Apply shock","Check chemicals"]
    //Dictionary containing services and details
    var choreNames: [String: [String]] = ["Lawn Mowing":["Hedging","Edging","Fertilizing","Watering"],"Raking Leaves":["Disposal"],"Shoveling Snow":["Walkways","Porches","Cars"],"Snow Plowing":["Shoveling on demand"],"Pool Cleaning":["Apply shock","Check chemicals"]]
    
    //other variables
    var weekDays: [String] = ["Sun","Mon","Tue","Wed","Thu","Fri","Sat"]
    var editsMade: Bool = false
    
    //uivariables
    var bioTextView: UITextView = UITextView()
    
    @IBOutlet weak var navItem: UINavigationItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.Light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        
        self.collectionView!.backgroundView = blurEffectView
        
        let saveButton = UIBarButtonItem(title: "Save", style: .Done, target: self, action: #selector(UpdateHelperProfile.saveProfileData))
        saveButton.enabled = false
        navItem.rightBarButtonItem = saveButton
        
        hideKeyboardWhenTappedAround()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 3+servicesOffered.count
    }


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        switch section{
        case 0:
            return 6
        case 1:
            return 2
        case 2:
            return 8
        default:
            var index = 0
            
            for key in Array(choreNames.keys){
                if key == servicesOffered[section - 3]{
                    return (choreNames[key]?.count)!+1
                }
                index += 1
            }
            return 0
        }
    }

    //initializes each cell
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        switch indexPath.section{
        case 0:
            if indexPath.row == 0{
                let cell = collectionView.dequeueReusableCellWithReuseIdentifier(sectionTitleIdentifier, forIndexPath: indexPath) as! SectionTitleCell
                cell.title.text = "Select the chores you will perform"
                return cell
            }else{
                let cell = collectionView.dequeueReusableCellWithReuseIdentifier(choreAccessoryCellIdentifier, forIndexPath: indexPath) as! ChoreAccessoryCell
                cell.accessoryLabel.text = Array(choreNames.keys)[indexPath.row-1]
                cell.makeCellSelectionCell()
                if Array(currentUser.servicesOffered.keys).contains(cell.accessoryLabel.text!){
                    cell.accessorySwitch.on = true
                }else{
                    cell.accessorySwitch.on = false
                }
                
                return cell
            }
        case 1:
            if indexPath.row == 0{
                let cell = collectionView.dequeueReusableCellWithReuseIdentifier(sectionTitleIdentifier, forIndexPath: indexPath) as! SectionTitleCell
                cell.title.text = "Edit your bio"
                return cell
            }else{
                let cell = collectionView.dequeueReusableCellWithReuseIdentifier(bioCellIdentifier, forIndexPath: indexPath) as! BioCell
                bioTextView = cell.textView
                return cell
            }
        case 2:
            if indexPath.row == 0{
                let cell = collectionView.dequeueReusableCellWithReuseIdentifier(sectionTitleIdentifier, forIndexPath: indexPath) as! SectionTitleCell
                cell.title.text = "Edit your schedule"
                return cell
            }else{
                let cell = collectionView.dequeueReusableCellWithReuseIdentifier(choreScheduleCellIdentifier, forIndexPath: indexPath) as! ChoreScheduleCell
                cell.weekDayLabel.text = weekDays[indexPath.row-1]
                if Array(currentUser.schedule.keys).contains(weekDays[indexPath.row-1]){
                    cell.dayEnabledSwitch.on = true
                    cell.startTimeField.enabled = true
                    cell.endTimeField.enabled = true
                    cell.startTimeField.placeholder = "When to start work"
                    cell.endTimeField.placeholder = "When to end work"
                    cell.backgroundColor = lightGrayBackground
                    cell.weekDayLabel.textColor = UIColor.darkGrayColor()
                }else{
                    cell.dayEnabledSwitch.on = false
                    cell.startTimeField.enabled = false
                    cell.endTimeField.enabled = false
                    cell.startTimeField.placeholder = ""
                    cell.endTimeField.placeholder = ""
                    cell.backgroundColor = darkGrayBackground
                    cell.weekDayLabel.textColor = UIColor.lightGrayColor()
                }
                return cell
            }

        default:
            if indexPath.row == 0{
                let cell = collectionView.dequeueReusableCellWithReuseIdentifier(sectionTitleIdentifier, forIndexPath: indexPath) as! SectionTitleCell
                cell.title.text = servicesOffered[indexPath.section-3]
                return cell
            }else{
                let cell = collectionView.dequeueReusableCellWithReuseIdentifier(choreAccessoryCellIdentifier, forIndexPath: indexPath) as! ChoreAccessoryCell
                let _service = (collectionView.cellForItemAtIndexPath(NSIndexPath(forItem: 0, inSection: indexPath.section)) as! SectionTitleCell).title.text
                cell.accessoryLabel.text = (choreNames[_service!])![indexPath.row-1]
                return cell
            }
        }//closure of switch
    }
    
    //sets the size of each cell
    func collectionView(collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout,sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        switch indexPath.section{
        case 0:
            switch indexPath.row{
            case 0:
                return CGSize(width: self.view.frame.width-20, height: 100)
            default:
                return CGSize(width: self.view.frame.width-20, height: 60)
            }
        case 1:
            switch indexPath.row{
            case 0:
                return CGSize(width: self.view.frame.width-20, height: 100)
            default:
                return CGSize(width: self.view.frame.width-20, height: 144)
            }
        case 2:
            switch indexPath.row{
            case 0:
                return CGSize(width: self.view.frame.width-20, height: 100)
            default:
                return CGSize(width: self.view.frame.width-20, height: 103)
            }
        default:
            switch indexPath.row{
            case 0:
                return CGSize(width: self.view.frame.width-20, height: 100)
            default:
                return CGSize(width: self.view.frame.width-20, height: 60)
            }
        }
        
    }

    func saveProfileData(){
        
    }
}

class SectionTitleCell: UICollectionViewCell {
    @IBOutlet weak var title: UILabel!
}

class ChoreAccessoryCell: UICollectionViewCell {
    @IBOutlet weak var accessoryLabel: UILabel!
    @IBOutlet weak var accessorySwitch: UISwitch!
    
    override func awakeFromNib() {
        
    }
    
    func makeCellSelectionCell(){
        accessorySwitch.addTarget(self, action: #selector(ChoreAccessoryCell.updateServiceItem(_:)), forControlEvents: UIControlEvents.ValueChanged)
    }
    
    func updateServiceItem(sender: UISwitch){
        if sender.on{
            switch self.accessoryLabel.text!{
            case "Lawn Mowing":
                currentUser.addLawnMowingService()
                print(currentUser)
            case "Raking Leaves":
                currentUser.addRakingService()
            case "Shoveling Snow":
                currentUser.addShovelingService()
            case "Snow Plowing":
                currentUser.addPlowingService()
            case "Pool Cleaning":
                currentUser.addPoolCleaningService()
            default:
                assert(true)
            }
        }else{
            currentUser.servicesOffered.removeValueForKey(self.accessoryLabel.text!)
        }
        
    }
}

class ChoreScheduleCell: UICollectionViewCell{
    
    @IBOutlet weak var startTimeField: UITextField!
    @IBOutlet weak var endTimeField: UITextField!
    @IBOutlet weak var weekDayLabel: UILabel!
    @IBOutlet weak var dayEnabledSwitch: UISwitch!
    
    
    
    override func awakeFromNib() {
        //adds date picker for start times
        let StartDatePickerView  : UIDatePicker = UIDatePicker()
        StartDatePickerView.datePickerMode = UIDatePickerMode.Time
        startTimeField.inputView = StartDatePickerView
        StartDatePickerView.addTarget(self, action: #selector(ChoreScheduleCell.handleStartDatePicker(_:)), forControlEvents: UIControlEvents.ValueChanged)
        
        //adds date picker for end times
        let EndDatePickerView  : UIDatePicker = UIDatePicker()
        EndDatePickerView.datePickerMode = UIDatePickerMode.Time
        endTimeField.inputView = EndDatePickerView
        EndDatePickerView.addTarget(self, action: #selector(ChoreScheduleCell.handleEndDatePicker(_:)), forControlEvents: UIControlEvents.ValueChanged)
        
        dayEnabledSwitch.addTarget(self, action: #selector(ChoreScheduleCell.changeDayState(_:)), forControlEvents: UIControlEvents.ValueChanged)
        
    }
    
    func handleStartDatePicker(sender: UIDatePicker) {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "hh mm aa"
        startTimeField.text = "From: \(dateFormatter.stringFromDate(sender.date))"
        (currentUser.schedule[weekDayLabel.text!])!["start"] = dateFormatter.stringFromDate(sender.date)
    }
    func handleEndDatePicker(sender: UIDatePicker) {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "hh mm aa"
        endTimeField.text = "To: \(dateFormatter.stringFromDate(sender.date))"
        (currentUser.schedule[weekDayLabel.text!])!["end"] = dateFormatter.stringFromDate(sender.date)
    }
    
    func changeDayState(sender: UISwitch){
        if sender.on{
            startTimeField.enabled = true
            endTimeField.enabled = true
            startTimeField.placeholder = "When to start work"
            endTimeField.placeholder = "When to end work"
            currentUser.schedule[weekDayLabel.text!] = ["start":"","end":""]
            self.backgroundColor = lightGrayBackground
            self.weekDayLabel.textColor = UIColor.darkGrayColor()
        }else{
            startTimeField.enabled = false
            endTimeField.enabled = false
            startTimeField.placeholder = ""
            endTimeField.placeholder = ""
            
            currentUser.schedule.removeValueForKey(self.weekDayLabel.text!)
            
            self.backgroundColor = darkGrayBackground
            self.weekDayLabel.textColor = UIColor.lightGrayColor()
        }
        
    }
}
