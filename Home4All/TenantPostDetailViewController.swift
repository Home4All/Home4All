//
//  TenantPostDetailViewController.swift
//  Home4All
//
//  Created by Ashish Mishra on 5/7/16.
//  Copyright © 2016 Home4All. All rights reserved.
//

import UIKit

class TenantPostDetailViewController: UIViewController {

    @IBOutlet weak var detailImageView: UIImageView!

    @IBOutlet weak var contactLabel: UILabel!
    @IBOutlet weak var stateLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var streetLabel: UILabel!
    @IBOutlet weak var descriptionText: UITextView!
    @IBOutlet weak var apartmanetTypeLabel: UILabel!
    
    @IBOutlet weak var noOfBedLabel: UILabel!
    
    @IBOutlet weak var noOfBath: UILabel!
    
    @IBOutlet weak var rentLabel: UILabel!
    @IBOutlet weak var areaLabel: UILabel!
    
    var placePost : PlacePost = PlacePost()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.streetLabel.text = placePost.valueForKey("street") as? String
        self.detailImageView.image = placePost.imageProperty

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
