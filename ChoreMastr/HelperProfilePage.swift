//
//  HelperProfilePage.swift
//  ChoreMastr
//
//  Created by Demetri Kostakis on 4/16/16.
//  Copyright © 2016 ChoreMastr. All rights reserved.
//

import UIKit

private let statIdentifier = "stat"
private let bioIdentifier = "bio"
private let shovelingIdentifier = "shoveling"
private let plowingIdentifier = "plowing"
private let rakingIdentifier = "raking"
private let mowingIdentifier = "mowing"
private let poolIdentifier = "pool"
private let scheduleIdentifier = "schedule"

class HelperProfilePage: UICollectionViewController {
    
    let editProfileSegueIdentifier = "makeEdits"
    
    var bio: String = ""
    var rating: Double = 4.0
    var numJobsCompleted: Int = 53
    
    @IBOutlet weak var navItem: UINavigationItem!
    
    //action to perform segue back after saving in editProfile page
    @IBAction func unwindToVC(segue: UIStoryboardSegue) {
    }

    override func viewWillAppear(animated: Bool) {
        self.collectionView?.reloadData()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //makes the view slightly transparent over the home page
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.Light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        self.view.addSubview(blurEffectView)
        self.view.sendSubviewToBack(blurEffectView)
        
        navItem.leftBarButtonItem?.target = self
        navItem.leftBarButtonItem?.action = #selector(HelperProfilePage.back)
        navItem.rightBarButtonItem?.target = self
        navItem.rightBarButtonItem?.action = #selector(HelperProfilePage.editProfileSheet)
        navItem.title = "Helper Profile"
        
        transparentNavigationBar(self.navigationController!)
        
        // Do any additional setup after loading the view.
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
        // #warning Incomplete implementation, return the number of sections
        if currentUser.servicesOffered.count != 0{
            return 4
        }
        return 3
    }


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        
        if currentUser.servicesOffered.count != 0{
            switch section{
            case 0:
                return 1
            case 1:
                return 2
            case 2:
                return currentUser.schedule.count+1
            case 3:
                return currentUser.servicesOffered.count
            default:
                return 0
            }
        }else{
            switch section{
            case 0:
                return 1
            case 1:
                return 2
            case 2:
                return currentUser.schedule.count
            default:
                return 0
            }
        }
        
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        if currentUser.servicesOffered.count != 0{
            switch indexPath.section {
            case 0:
                let bioCell = collectionView.dequeueReusableCellWithReuseIdentifier(bioIdentifier, forIndexPath: indexPath) as! BioCell
                return bioCell
            case 1:
                let statCell = collectionView.dequeueReusableCellWithReuseIdentifier(statIdentifier, forIndexPath: indexPath) as! StatCell
                switch indexPath.row{
                case 0:
                    statCell.titleLabel.text = "Rating"
                    statCell.valueLabel.text = "\(self.rating)"
                case 1:
                    statCell.titleLabel.text = "Completed"
                    statCell.valueLabel.text = "\(self.numJobsCompleted)"
                default:
                    assert(true)
                }
                statCell.layer.borderWidth = 1
                statCell.layer.cornerRadius = statCell.frame.width/2
                statCell.clipsToBounds = true
                statCell.layer.borderColor = UIColor.whiteColor().CGColor
                return statCell
            case 2:
                let scheduleCell = collectionView.dequeueReusableCellWithReuseIdentifier(scheduleIdentifier, forIndexPath: indexPath) as! ScheduleItemCell
                //checks to make sure schedule exists
                if Array(currentUser.schedule.keys).count != 0{
                    if indexPath.row == 0{
                        scheduleCell.scheduleLabel.text = "Working schedule"
                        scheduleCell.scheduleLabel.font = UIFont(name: "Avenir Next Medium", size: 17)
                    }else{
                        let day = Array(currentUser.schedule.keys)[indexPath.row-1]
                        let start = (currentUser.schedule[day])!["start"]
                        let end = (currentUser.schedule[day])!["end"]
                        scheduleCell.scheduleLabel.text = "\(Array(currentUser.schedule.keys)[indexPath.row-1]):   \(start!)-\(end!)"
                        
                        
                    }
                }else{
                    scheduleCell.scheduleLabel.text = "Working schedule"
                    scheduleCell.scheduleLabel.font = UIFont(name: "Avenir Next Medium", size: 17)
                }
                
                
                
                return scheduleCell
            case 3:
                switch Array(currentUser.servicesOffered.keys)[indexPath.row] {
                case "Lawn Mowing":
                    let cell = collectionView.dequeueReusableCellWithReuseIdentifier(mowingIdentifier, forIndexPath: indexPath) as! ChoreCell
                    return cell
                case "Raking Leaves":
                    let cell = collectionView.dequeueReusableCellWithReuseIdentifier(rakingIdentifier, forIndexPath: indexPath) as! ChoreCell
                    return cell
                case "Shoveling Snow":
                    let cell = collectionView.dequeueReusableCellWithReuseIdentifier(shovelingIdentifier, forIndexPath: indexPath) as! ChoreCell
                    return cell
                case "Snow Plowing":
                    let cell = collectionView.dequeueReusableCellWithReuseIdentifier(plowingIdentifier, forIndexPath: indexPath) as! ChoreCell
                    return cell
                default:
                    let cell = collectionView.dequeueReusableCellWithReuseIdentifier(poolIdentifier, forIndexPath: indexPath) as! ChoreCell
                    return cell
                }
            default:
                let cell = UICollectionViewCell()
                return cell
            }
        }else{
            switch indexPath.section {
            case 0:
                let bioCell = collectionView.dequeueReusableCellWithReuseIdentifier(bioIdentifier, forIndexPath: indexPath) as! BioCell
                return bioCell
            case 1:
                let statCell = collectionView.dequeueReusableCellWithReuseIdentifier(statIdentifier, forIndexPath: indexPath) as! StatCell
                switch indexPath.row{
                case 0:
                    statCell.titleLabel.text = "Rating"
                    statCell.valueLabel.text = "\(self.rating)"
                case 1:
                    statCell.titleLabel.text = "Completed"
                    statCell.valueLabel.text = "\(self.numJobsCompleted)"
                default:
                    assert(true)
                }
                statCell.layer.borderWidth = 1
                statCell.layer.cornerRadius = statCell.frame.width/2
                statCell.clipsToBounds = true
                statCell.layer.borderColor = UIColor.whiteColor().CGColor
                return statCell
            case 2:
                let scheduleCell = collectionView.dequeueReusableCellWithReuseIdentifier(scheduleIdentifier, forIndexPath: indexPath) as! ScheduleItemCell
                let day = Array(currentUser.schedule.keys)[indexPath.row]
                let start = (currentUser.schedule[day])!["start"]
                let end = (currentUser.schedule[day])!["end"]
                scheduleCell.scheduleLabel.text = "\(Array(currentUser.schedule.keys)[indexPath.row]) \(start!)-\(end!)"
                return scheduleCell
            default:
                let cell = UICollectionViewCell()
                return cell
            }
        }
        
    }
    
    //Use for size
    func collectionView(collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout,sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        if currentUser.servicesOffered.count != 0{
            switch indexPath.section{
            case 1:
                return CGSize(width: self.view.frame.width/2 - 40, height: 142)
            case 2:
                return CGSize(width: self.view.frame.width - 16, height: 20)
            case 3:
                
                var height: CGFloat!
                switch Array(currentUser.servicesOffered.keys)[indexPath.row] {
                case "Lawn Mowing":
                    height = 189
                    return CGSize(width: collectionView.frame.width-16, height: height)
                case "Raking Leaves":
                    height = 100
                    return CGSize(width: collectionView.frame.width-16, height: height)
                case "Shoveling Snow":
                    height = 157
                    return CGSize(width: collectionView.frame.width-16, height: height)
                case "Snow Plowing":
                    height = 100
                    return CGSize(width: collectionView.frame.width-16, height: height)
                case "Pool Cleaning":
                    height = 129
                    return CGSize(width: collectionView.frame.width-16, height: height)
                default:
                    height = 0
                }
                
                return CGSize(width: collectionView.frame.width-16, height: 150)
            default:
                
                return CGSize(width: self.view.frame.width-16, height: 100.5)
            }
        }else{
            switch indexPath.section{
            case 1:
                return CGSize(width: self.view.frame.width/2 - 40, height: 142)
            case 2:
                return CGSize(width: self.view.frame.width - 16, height: 20)
            default:
                
                return CGSize(width: self.view.frame.width-16, height: 100.5)
            }
        }
        
        
    }
    override func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        switch kind {
        //configures the header
        case UICollectionElementKindSectionHeader:
            let headerView = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: "Header", forIndexPath: indexPath) as! ProfileHeader
            headerView.profilePicture.layer.cornerRadius = headerView.profilePicture.frame.width/2
            headerView.profilePicture.clipsToBounds = true
            headerView.name.text = currentUser.displayName
            let locality = (currentUser.address)["locality"]!
            let administrativeArea = (currentUser.address)["administrativeArea"]!
            headerView.location.text = "\(locality) \(administrativeArea), United States"
            return headerView
            
        //configures the footer
        case UICollectionElementKindSectionFooter:
            return UICollectionReusableView()
            
        default:
            return UICollectionReusableView()
            //assert(false, "Unexpected element kind")
        }

    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        switch section{
        case 0:
            return CGSize(width: collectionView.frame.width, height: 250)
        default:
            return CGSize(width: 0, height: 0)
        }
    }

    func back(){
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func editProfileSheet(){
        let alertController = UIAlertController(title: "Edit Profile", message: "Choose what you wish to edit", preferredStyle: .ActionSheet)
        
        let editProfilePicture = UIAlertAction(title: "Edit Profile Picture", style: .Default, handler: {
            alertAction in
        })
        let editServicesAction = UIAlertAction(title: "Edit Your Profile", style: .Default, handler: {
            alertAction in
            self.performSegueWithIdentifier(self.editProfileSegueIdentifier, sender: self)
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: {
            alertAction in
            
        })
        alertController.addAction(editProfilePicture)
        alertController.addAction(editServicesAction)
        alertController.addAction(cancelAction)
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
}

class StatCell: UICollectionViewCell {
    
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        
    }
}

class BioCell: UICollectionViewCell{
    @IBOutlet weak var textView: UITextView!
    
    override func awakeFromNib() {
        
    }
}

class ChoreCell: UICollectionViewCell{
    @IBOutlet weak var choreTitle: UILabel!
    @IBOutlet weak var recourcesLabel: UILabel!
    @IBOutlet weak var specialRequestLabel: UILabel!
}

class ScheduleItemCell: UICollectionViewCell {
    @IBOutlet weak var scheduleLabel: UILabel!
}

class ProfileHeader: UICollectionReusableView{
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var location: UILabel!
}
