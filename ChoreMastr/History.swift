//
//  History.swift
//  ChoreMastr
//
//  Created by Demetri Kostakis on 4/12/16.
//  Copyright © 2016 ChoreMastr. All rights reserved.
//

import UIKit
import TBEmptyDataSet

private let reuseIdentifier = "Cell"

class History: UICollectionViewController, TBEmptyDataSetDataSource, TBEmptyDataSetDelegate{

    override func viewDidLoad() {
        super.viewDidLoad()
        
        transparentNavigationBar(self.navigationController!)

        //Assigns the emptyDataSet delegate and data source
        collectionView!.emptyDataSetDataSource = self
        collectionView!.emptyDataSetDelegate = self
        
        //adds blur effect in background
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.Light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        
        self.collectionView?.backgroundView = blurEffectView
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
        return 0
    }


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return 0
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath)
    
        // Configure the cell
    
        return cell
    }

    // MARK: UICollectionViewDelegate
    
    //Size of each cell
    func collectionView(collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout,sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width: self.view.frame.width, height: 100)
        
    }

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */
    
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
    
    // MARK: - TBEmptyDataSet Data Source
    func imageForEmptyDataSet(scrollView: UIScrollView!) -> UIImage? {
        // return the image for EmptyDataSet
        let image = UIImage(named: "icon-empty-events")
        return image
    }
    func titleForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString? {
        // return the title for EmptyDataSet
        var attributes: [String : AnyObject]?
        attributes = [NSFontAttributeName: UIFont.systemFontOfSize(22.0), NSForegroundColorAttributeName: UIColor.grayColor()]
        return NSAttributedString(string: "You don't have any chore requests!", attributes: attributes)
    }
    
    func descriptionForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString? {
        // return the description for EmptyDataSet
        var attributes: [String : AnyObject]?
        attributes = [NSFontAttributeName: UIFont.systemFontOfSize(17.0), NSForegroundColorAttributeName: UIColor(red: 3 / 255, green: 169 / 255, blue: 244 / 255, alpha: 1)]
        return NSAttributedString(string: "Start getting your chores done by selected the category on the home page.", attributes: attributes)
    }
    

    
    @IBAction func back(){
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    

}
