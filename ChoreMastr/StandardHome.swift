//
//  StandardHome.swift
//  ChoreMastr
//
//  Created by Demetri Kostakis on 4/10/16.
//  Copyright © 2016 ChoreMastr. All rights reserved.
//
//  This is the home page for a standard user

import UIKit
import Firebase

private let reuseIdentifier = "Cell"

class StandardHome: UICollectionViewController {
    
    //segue Identifiers
    let messagesSegueIdentifier = "presentMessages"
    let historySegueIdentifier = "presentHistory"
    let profileSegueIdentifier = "presentProfile"
    
    //optimal ratio for images to fit in cells
    let imageRatio = 0.71
    
    //chores and images for the grid of jobs
    let allChores = ["Lawn Mowing", "Raking Leaves","Shoveling/Snowblowing","Plowing","Pool Cleaning"]
    let images = [UIImage(named: "LawnMower_White"),UIImage(named: "Leaves_White"),UIImage(named: "SnowShovel_White"),UIImage(named: "SnowPlow_White"),UIImage(named: "PoolCleaning_White")]

    @IBOutlet weak var navItem: UINavigationItem!
    
    //viewWillAppear checks if there is userData persisted
    
    override func viewWillAppear(animated: Bool) {
        self.tabBarController!.tabBar.hidden = false
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadUser(FIRAuth.auth()!.currentUser!.uid)
        
        //defines navbar buttons
        let messagesButton: UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "Chat"), style: .Plain, target: self, action: #selector(StandardHome.showMessages))
        //messagesButton.tintColor = appThemeColor
        let historyButton: UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "History"), style: .Plain, target: self, action: #selector(StandardHome.showHistory))
        //historyButton.tintColor = appThemeColor
        let profileButton: UIBarButtonItem = UIBarButtonItem(title: "Profile", style: .Plain, target: self, action: #selector(StandardHome.showProfile))
        //profileButton.tintColor = appThemeColor
        
        //Checks if the user is standard or not to display the profile button
        if currentUser.userType == .Standard{
            navItem.rightBarButtonItem = historyButton
        }else{
            //creates an array of buttons to go on the right side of the nav bar
            let rightSideButtons = [historyButton,profileButton]
            navItem.rightBarButtonItems = rightSideButtons
        }
        
        let rightSideButtons = [historyButton,profileButton]
        navItem.rightBarButtonItems = rightSideButtons

        
        navItem.leftBarButtonItem = messagesButton
        
        
        removeNavigationSeparator(self.navigationController!)
        
        //makes the view slightly transparent over the home page
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.Light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        self.view.addSubview(blurEffectView)
        self.view.sendSubviewToBack(blurEffectView)
        
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
        return 1
    }


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return allChores.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! ChoreSelectionCell
        
        //Adds a border to each cell
        cell.layer.borderWidth = 0.5
        cell.layer.borderColor = UIColor.lightGrayColor().CGColor
 
        cell.choreName.text = allChores[indexPath.row]
        cell.iconImage.image = images[indexPath.row]
        
        return cell
    }

    // MARK: UICollectionViewDelegate
    
    //Use for size
    func collectionView(collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout,sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let height: Double = (Double(self.view.frame.width/2))*imageRatio+60
        return CGSize(width: self.view.frame.width/2, height: CGFloat(height))
        
    }

    
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    //Sets the reusable View at the top of the section
    override func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        
        switch kind {
        //configures the header
        case UICollectionElementKindSectionHeader:
            
            let headerView = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: "Header", forIndexPath: indexPath)
            
            return headerView
        //configures the footer
        case UICollectionElementKindSectionFooter:
            let footerView = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: "Footer", forIndexPath: indexPath)
            
            return footerView
            
        default:
            return UICollectionReusableView()
            //assert(false, "Unexpected element kind")
        }
    }

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(collectionView: UICollectionView, shouldShowMenuForItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, canPerformAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, performAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) {
    
    }
    */
    
    // Mark: BarButtonItem actions
    
    //shows messages page
    func showMessages(){
        performSegueWithIdentifier(messagesSegueIdentifier, sender: self)
    }
    
    //shows history page
    func showHistory(){
        performSegueWithIdentifier(historySegueIdentifier, sender: self)
    }
    
    //shows profile page **note this is only for Helper accounts**
    func showProfile(){
        performSegueWithIdentifier(profileSegueIdentifier, sender: self)
        
        //implimentation incomplete until firebase functions implemented
        
    }

}

class ChoreSelectionCell: UICollectionViewCell {
    
    @IBOutlet weak var choreName: UILabel!
    @IBOutlet weak var iconImage: UIImageView!
    
    override func awakeFromNib() {
        
        //selectedImage.image = UIImage(named: "Selected")
        
        
    }
    
}