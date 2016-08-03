//
//  HelperSearch.swift
//  ChoreMastr
//
//  Created by Demetri Kostakis on 4/24/16.
//  Copyright © 2016 ChoreMastr. All rights reserved.
//

import UIKit
import MapKit
import Firebase

private let searchRadius = ["Current Location","1","2","3","4","5","10","15"]
private let mapTag = 250
private let tintViewTag = 100
private let distancePickerTag = 150
private let datePickerTag = 50
private let menuTag = 200

class ChoreSearch: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    //search controller
    var resultSearchController:UISearchController? = nil
    
    @IBOutlet weak var navItem: UINavigationItem!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var timeButton: UIButton!
    @IBOutlet weak var locationButton: UIButton!
    @IBOutlet weak var extendedNavBar: UIView!
    
    
    @IBAction func changeSearchRadius(sender: UIButton){
        if self.navItem?.leftBarButtonItem!.title == "Back"{
            self.startDistanceEditing()
        }else{
            self.endDistanceEditing()
        }

    }
    
    @IBAction func changeTime(sender: UIButton){
        if self.navItem?.leftBarButtonItem!.title == "Back"{
            self.startTimeEditing()
        }else{
            self.endTimeEditing()
        }
    }
    
    @IBAction func toggleMap(sender: UIBarButtonItem){
        
        let mapButton = self.navItem.rightBarButtonItems![1]
        if mapButton.title == "Map"{
            self.displayMap()
        }else{
            self.removeMap()
        }
    }
    
    @IBAction func toggleFilterMenu(sender: UIBarButtonItem){
        
        let filterButton = self.navItem.rightBarButtonItems![0]
        if filterButton.title == "Filter"{
            self.displayFilterMenu()
        }else{
            self.removeFilterMenu()
        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.removeNavigationSeparator(self.navigationController!)
    
        self.navItem.leftBarButtonItem?.target = self
        self.navItem.leftBarButtonItem?.action = #selector(self.back)
        
        let formatter = NSDateFormatter()
        formatter.dateFormat = "hh:mm aa, dd MMM"
        
        let date = NSDate()
        
        self.timeButton.setTitle("Chores for \(formatter.stringFromDate(date))", forState: .Normal)
        self.timeButton.titleLabel?.textAlignment = NSTextAlignment.Left
        self.timeButton.titleLabel!.frame.size.width = self.timeButton.frame.size.width
        self.timeButton.layer.cornerRadius = 5
        self.timeButton.clipsToBounds = true
        self.timeButton.autoresizingMask = UIViewAutoresizing.FlexibleWidth
        self.timeButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Left
        self.timeButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        
        self.locationButton.setTitle("Current Location", forState: .Normal)
        self.locationButton.layer.cornerRadius = 5
        self.locationButton.clipsToBounds = true
        
        //sets up window and tableview delegates
        self.tabBarController?.tabBar.hidden = true
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.tableFooterView = UIView()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 3
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if tableView.tag == 10{
            var cell = tableView.dequeueReusableCellWithIdentifier("filterCell")
            if(cell == nil){
                tableView.registerNib(UINib.init(nibName: "FilterCell", bundle: nil), forCellReuseIdentifier: "filterCell")
                cell = tableView.dequeueReusableCellWithIdentifier("filterCell")
                return cell!
            }
        }
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)
        // Configure the cell...
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 114
    }
    
    func back(){
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension ChoreSearch: UIPickerViewDelegate, UIPickerViewDataSource{
    
    // - MARK: Loading Methods
    
    func loadNearbyHelpers(){
        
        //Create loading background
        
        //Get current location
        
            //Get userpermissions
        
        //Determine radius given user search radius
        
        //Fetch Helpers from GeoFire
        
            //Update tableview
    }
    
    // - MARK: Time Methods
    
    func changeTime(){
        print("Time changed")
    }
    
    func startTimeEditing(){
        
        //creates the background tint
        let tintView = self.createBackgroundTint(tintViewTag)
        
        
        //creates the datepicker
        let picker = self.createEditDatePicker(datePickerTag)
        picker.addTarget(self, action: #selector(ChoreSearch.timeDidChange(_:)), forControlEvents: .ValueChanged)
        
        //changes the function of the done button and the title of the button
        self.navItem.leftBarButtonItem?.action = #selector(ChoreSearch.endTimeEditing)
        self.navItem.leftBarButtonItem?.title = "Done"
        //sets other buttons to inactive
        for item in self.navItem.rightBarButtonItems!{
            item.enabled = false
        }
        //adds the tint
        tableView.addSubview(tintView)
        tableView.scrollEnabled = false
        //adds the datePicker
        self.view.addSubview(picker)
        picker.frame.size.height = 0
        UIView.animateWithDuration(0.3, animations: {
            picker.frame.size.height = 250
        })

    }
    
    func endTimeEditing(){
        
        //changes bar button item back to normal functionality
        self.navItem.leftBarButtonItem?.action = #selector(ChoreSearch.back)
        self.navItem.leftBarButtonItem?.title = "Back"
        self.tableView.scrollEnabled = true
        for item in self.navItem.rightBarButtonItems!{
            item.enabled = true
        }
        
        //Checks the tableview for the tintView to remove it
        for subView in tableView.subviews{
            if subView.tag == tintViewTag{
                subView.removeFromSuperview()
            }
        }
        //Checks the view for the datePicker to remove it
        for subView in self.view.subviews{
            if subView.tag == datePickerTag{
                subView.removeFromSuperview()
            }
        }
        
    }
    
    // - MARK: Distance Methods
    
    func startDistanceEditing(){
        
        timeButton.enabled = false
        timeButton.titleLabel?.textColor = UIColor.lightGrayColor()
        
        //creates the background tint
        let tintView = self.createBackgroundTint(tintViewTag)
        
        //creates the datepicker
        let picker = self.createEditDistancePicker(distancePickerTag)
        
        self.navItem.leftBarButtonItem?.action = #selector(ChoreSearch.endDistanceEditing)
        self.navItem.leftBarButtonItem?.title = "Done"
        //sets other buttons to inactive
        for item in self.navItem.rightBarButtonItems!{
            item.enabled = false
        }
        //adds the tint
        tableView.addSubview(tintView)
        tableView.scrollEnabled = false
        //adds the datePicker
        self.view.addSubview(picker)
        picker.frame.size.height = 0
        UIView.animateWithDuration(0.3, animations: {
            picker.frame.size.height = 250
        })

    }
    
    func endDistanceEditing(){
        timeButton.enabled = true
        timeButton.titleLabel?.textColor = UIColor.darkGrayColor()
        //changes bar button item back to normal functionality
        self.navItem.leftBarButtonItem?.action = #selector(ChoreSearch.back)
        self.navItem.leftBarButtonItem?.title = "Back"
        self.tableView.scrollEnabled = true
        for item in self.navItem.rightBarButtonItems!{
            item.enabled = true
        }
        
        //Checks the tableview for the tintView to remove it
        for subView in tableView.subviews{
            if subView.tag == tintViewTag{
                subView.removeFromSuperview()
            }
        }
        //Checks the view for the distancePicker to remove it
        for subView in self.view.subviews{
            if subView.tag == distancePickerTag{
                subView.removeFromSuperview()
            }
        }

    }
    
    // - MARK: Map Methods
    
    func displayMap(){
        let mapButton = self.navItem.rightBarButtonItems![1]
        mapButton.title = "List"
        
        for subview in self.view.subviews{
            if subview.tag == 250{
                self.view.sendSubviewToBack(self.tableView)
                for _subview in self.view.subviews{
                    if _subview.tag == menuTag{
                        self.view.bringSubviewToFront(_subview)
                    }
                }
                break
            }else{
                let map = self.createDisplayMap(mapTag)
                self.view.addSubview(map)
                for _subview in self.view.subviews{
                    if _subview.tag == menuTag{
                        self.view.bringSubviewToFront(_subview)
                    }
                }
                break
            }
        }
    }
    
    func removeMap(){
        let mapButton = self.navItem.rightBarButtonItems![1]
        mapButton.title = "Map"
        for subview in self.view.subviews{
            if subview.tag == mapTag{
                self.view.sendSubviewToBack(subview)
                break
            }
        }
    }
    
    // - MARK: Filter Methods
    
    func displayFilterMenu(){
        
        //removes editing from other UI elements
        self.timeButton.enabled = false
        self.locationButton.enabled = false
        self.tableView.scrollEnabled = false
        self.tableView.userInteractionEnabled = false
        
        let filterButton = self.navItem.rightBarButtonItems![0]
        filterButton.title = "Close"
        
        for subview in self.view.subviews{
            //check to see if menu has already been made
            if subview.tag == menuTag{
                
                UIView.animateWithDuration(0.3, animations: {
                    subview.center.x -= self.view.frame.size.width
                    self.view.bringSubviewToFront(subview)
                })
                return
            }else{
            }
        }
        //if there is no existing menu created
        let menu = self.createFilterMenu(menuTag)
        self.view.addSubview(menu)
        UIView.animateWithDuration(0.3, animations: {
            menu.center.x -= self.view.frame.size.width
        })
    }
    
    func removeFilterMenu(){
        
        //enables editing from other UI elements
        self.timeButton.enabled = true
        self.locationButton.enabled = true
        self.tableView.scrollEnabled = true
        self.tableView.userInteractionEnabled = true
        
        let filterButton = self.navItem.rightBarButtonItems![0]
        filterButton.title = "Filter"
        for subview in self.view.subviews{
            if subview.tag == menuTag{
                UIView.animateWithDuration(0.3, animations: {
                    subview.center.x += self.view.frame.size.width
                })
                break
            }
        }
    }
    
    // - MARK: Create Subview Methods
    
    func createBackgroundTint(tag: Int) -> UIView{
        
        //tints the tableview to show editing
        let tintView = UIView()
        tintView.frame.size = view.frame.size
        tintView.backgroundColor = UIColor.darkGrayColor()
        tintView.alpha = 0.6
        tintView.tag = tag
        
        return tintView
    }
    
    func createEditDatePicker(tag: Int) -> UIDatePicker{
        
        let picker = UIDatePicker()
        picker.frame = CGRect(x: 0.0, y: timeButton.frame.maxY+8, width: extendedNavBar.frame.width, height: 250)
        picker.backgroundColor = UIColor.whiteColor()
        picker.topAnchor
        picker.tag = tag
        picker.minuteInterval = 15
        
        return picker
    }
    
    func createEditDistancePicker(tag: Int) -> UIPickerView{
        
        let picker = UIPickerView()
        picker.frame = CGRect(x: 0.0, y: locationButton.frame.maxY+8, width: extendedNavBar.frame.width, height: 250)
        picker.backgroundColor = UIColor.whiteColor()
        picker.topAnchor
        picker.tag = tag
        picker.showsSelectionIndicator = true
        picker.delegate = self
        picker.dataSource = self
        
        
        return picker
    }
    
    
    func createDisplayMap(tag: Int) -> MKMapView{
        let map = MKMapView(frame: self.tableView.frame)
        map.tag = tag
        return map
    }
    
    func createFilterMenu(tag: Int) -> FilterMenu{
        let superViewWidth = self.view.frame.size.width
        let menuWidth:CGFloat = self.view.frame.size.width*(3/4)
        let menuX = superViewWidth-menuWidth
        let menu = FilterMenu(frame: CGRect(x: menuX, y: 0, width: menuWidth, height: self.view.frame.size.height))
        menu.center.x += self.view.frame.size.width
        menu.tag = menuTag
        menu.tableView.frame = CGRect(x: menuX, y: 0, width: menuWidth, height: self.view.frame.size.height)
        menu.tableView.center.x += self.view.frame.size.width
        menu.tableView.backgroundColor = UIColor.clearColor()
        return menu
    }
    
    // - MARK: Control Methods
    
    func timeDidChange(sender: UIDatePicker){
        let formatter = NSDateFormatter()
        formatter.dateFormat = "hh:mm aa, dd MMM"
        
        self.timeButton.setTitle("Chores for \(formatter.stringFromDate(sender.date))", forState: .Normal)
    }
    
    func distanceDidChange(sender: UIPickerView){
        let distance = searchRadius[sender.selectedRowInComponent(0)]
        self.locationButton.setTitle("Search radius: \(distance) miles", forState: .Normal)
    }
    
    // MARK: - Firebase methods for searching
    
    
    
    // MARK: - PickerViewDataSource implementation
    
    // returns the number of 'columns' to display.
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int{
        return 1
    }
    
    // returns the # of rows in each component..
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        return searchRadius.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return searchRadius[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let distance = searchRadius[row]
        self.locationButton.setTitle("Search radius: \(distance) miles", forState: .Normal)
    }
}



