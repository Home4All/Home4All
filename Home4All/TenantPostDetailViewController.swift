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
    
    @IBOutlet weak var favoriteButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.streetLabel.text = placePost.valueForKey("street") as? String
        self.detailImageView.image = placePost.imageProperty

        // Do any additional setup after loading the view.
    }

    @IBAction func markfavoriteproperty(sender: AnyObject) {
        
        let userId = NSUserDefaults.standardUserDefaults().valueForKey("userid");
        let query = PFQuery(className: "AppUser")
        query.whereKey("userid", equalTo: userId!);
        query.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
            let pfObjects : NSArray = objects!;
            if pfObjects.count > 0 && error == nil {
                
                let currentAppUser = pfObjects[0] as! PFObject;
                var isAlreadyMarked = false;

                if let  favorites = currentAppUser.valueForKey("favorite") {
                    let favouritesArray : NSMutableArray = favorites.mutableCopy() as! NSMutableArray
                    for aPlacePost in favouritesArray  {
                        let currentPlacePost = aPlacePost as! PlacePost;
                        if(currentPlacePost.objectId! == self.placePost.objectId) {
                            isAlreadyMarked = true;
                        }
                    }
                    if isAlreadyMarked {
                        favouritesArray.removeObject(self.placePost)
                        self.favoriteButton.tintColor = UIColor.blueColor()

                    } else {
                        favouritesArray.addObject(self.placePost)
                        self.favoriteButton.tintColor = UIColor.blueColor()

                    }
                    currentAppUser.setObject(favouritesArray.copy() as! NSArray, forKey: "favorite")
                    
                }
                else {
                    let favorites = NSArray(objects: self.placePost)
                    currentAppUser.setObject(favorites, forKey: "favorite")
                }
                currentAppUser.saveInBackgroundWithBlock({ (success, error) in
                    if (success){
                        if isAlreadyMarked {
                            self.showAlert("Succesful", message: "Favorite removed.")
                        } else {
                            self.showAlert("Succesful", message: "Favorite Saved.")
                        }
                    } else {

                    }
                })
            } else {
                NSLog("Error Retrieving user for favorite");
            }
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showAlert(title : NSString, message : NSString) {
        let alertController = UIAlertController(title: title as String, message:message as String, preferredStyle: .Alert)
        
        let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alertController.addAction(defaultAction)
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    


}
