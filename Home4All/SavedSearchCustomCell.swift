//
//  SavedSearchCustomCell.swift
//  Home4All
//
//  Created by Ashish Mishra on 5/8/16.
//  Copyright © 2016 Home4All. All rights reserved.
//

import UIKit

class SavedSearchCustomCell: UITableViewCell {
    @IBOutlet weak var propertyType: UILabel!
    @IBOutlet weak var deleteSavedSearchButton: UIButton!
    
    @IBOutlet weak var zipcode: UILabel!
    
    @IBOutlet weak var keywordsearch: UILabel!
    @IBOutlet weak var priceMinLabel: UILabel!
    @IBOutlet weak var cityName: UILabel!
    @IBOutlet weak var priceMaxLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}
