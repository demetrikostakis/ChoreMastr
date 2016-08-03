//
//  FilterMenu.swift
//  ChoreMastr
//
//  Created by Demetri Kostakis on 5/8/16.
//  Copyright © 2016 ChoreMastr. All rights reserved.
//

import UIKit


private let tableViewTag = 10
private let sectionTitles = ["Search Radius","Helper Rating","Hourly Rate"]

class FilterMenu: UIView, UITableViewDelegate, UITableViewDataSource {
    
    var tableView: UITableView = UITableView(frame: CGRect(), style: .Grouped)
    
    override func awakeFromNib() {
        //Incomplete implementation
    }
    
    override func didMoveToSuperview() {
        self.setupTableView()
        //adds a bluring effect to the menu
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.Light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.bounds
        self.addSubview(blurEffectView)
        self.sendSubviewToBack(blurEffectView)
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return sectionTitles.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("filterCell") as? FilterCell
        if(cell == nil){
            tableView.registerNib(UINib.init(nibName: "FilterCell", bundle: nil), forCellReuseIdentifier: "filterCell")
            cell = tableView.dequeueReusableCellWithIdentifier("filterCell") as? FilterCell
            return cell!
        }
        
        switch indexPath.section{
        case 0:
            cell?.leftLabel.text = "No Preference"
            cell?.rightLabel.text = "15 Miles"
            cell?.bottomLabel.text = "7.5 Miles"
        case 1:
            cell?.leftLabel.text = "No Preference"
            cell?.rightLabel.text = "2.5"
            cell?.bottomLabel.text = "5.0"
        case 2:
            cell?.leftLabel.text = "No Preference"
            cell?.rightLabel.text = "$60/hour"
            cell?.bottomLabel.text = "$30/hour"
        default:
            break
        }
        return cell!
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitles[section]
    }
    
    func setupTableView(){
        self.tableView.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height)
        self.tableView.tag = tableViewTag
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.backgroundColor = UIColor.clearColor()
        self.addSubview(self.tableView)
    }
    
    func applyFilters(context: ChoreSearch){
        print("Filter applied")
    }

    
}



