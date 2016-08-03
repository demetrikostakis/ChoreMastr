//
//  FilterCell.swift
//  ChoreMastr
//
//  Created by Demetri Kostakis on 5/8/16.
//  Copyright © 2016 ChoreMastr. All rights reserved.
//

import UIKit

class FilterCell: UITableViewCell {
    
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var leftLabel: UILabel!
    @IBOutlet weak var rightLabel: UILabel!
    @IBOutlet weak var bottomLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
