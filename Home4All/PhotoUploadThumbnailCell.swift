//
//  PhotoUploadThumbnailCell.swift
//  Home4All
//
//  Created by Ashish Mishra on 4/25/16.
//  Copyright © 2016 Home4All. All rights reserved.
//

import UIKit

class PhotoUploadThumbnailCell: UICollectionViewCell {
    
    @IBOutlet var imgView : UIImageView!
    
    
    func setThumbnailImage(thumbnailImage: UIImage){
        self.imgView.image = thumbnailImage
    }
}
