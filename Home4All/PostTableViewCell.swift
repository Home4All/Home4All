//
//  PostTableViewCell.swift
//  Home4All
//
//  Created by Ashish Mishra on 4/25/16.
//  Copyright © 2016 Home4All. All rights reserved.
//

import UIKit

class PostTableViewCell: UITableViewCell {

    @IBOutlet var propertyMetricLabel : UILabel!
    @IBOutlet var propertyMetricLabelValue : UITextField!

    func setpropertymetricLabel(propertyLabel: NSString){
        self.propertyMetricLabel.text = propertyLabel as String
        self.propertyMetricLabel.textColor = UIColor.blueColor()
    }
    
    func setPropertyLabelValue(propertyLabelvalue : NSString) {
        self.propertyMetricLabelValue.text = propertyLabelvalue  as String
    }

}
