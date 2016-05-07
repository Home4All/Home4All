//
//  CustomCell.swift
//  Home4All
//
//  Created by Pawan Kumar on 5/5/16.
//  Copyright © 2016 Home4All. All rights reserved.
//

import UIKit

class CustomCell: UITableViewCell {

  
    @IBOutlet weak var street: UILabel!
  
  
    @IBOutlet weak var city: UILabel!
  
  
    @IBOutlet weak var price: UILabel!
  
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
