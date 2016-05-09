//
//  TenantSearchFilterOptionsViewController.swift
//  Home4All
//
//  Created by Ashish Mishra on 5/8/16.
//  Copyright © 2016 Home4All. All rights reserved.
//

import UIKit

class TenantSearchFilterOptionsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func saveThisSearch(sender: AnyObject) {
        
        let savedSearch : SavedSearch = SavedSearch()
        savedSearch.setObject("House", forKey: "propertytype")
        savedSearch.setObject("San Francisco", forKey: "city")
        savedSearch.setObject(NSNumber(int:1000), forKey: "minrent")
        savedSearch.setObject(NSNumber(int:10000), forKey: "maxrent")
                
        let userId = NSUserDefaults.standardUserDefaults().valueForKey("userid");
        let query = PFQuery(className: "AppUser")
        query.whereKey("userid", equalTo: userId!);
        query.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
            let pfObjects : NSArray = objects!;
            if pfObjects.count > 0 && error == nil {
                
                let currentAppUser = pfObjects[0] as! PFObject;
                
                if let  savedSearches = currentAppUser.valueForKey("savedsearches") {
                    let savedSearchesArray : NSMutableArray = savedSearches.mutableCopy() as! NSMutableArray
                    savedSearchesArray.addObject(savedSearch)
             
                    currentAppUser.setObject(savedSearchesArray.copy() as! NSArray, forKey: "savedsearches")
                    
                }
                else {
                    let savedSearchArray = NSArray(objects: savedSearch)
                    currentAppUser.setObject(savedSearchArray, forKey: "savedsearches")
                }
                currentAppUser.saveInBackgroundWithBlock({ (success, error) in
                    if (success){
                       NSLog("Successfully saved searches")
                    } else {
                        NSLog("error in  saving searches")

                    }
                })
            } else {
                NSLog("Error Retrieving user for favorite");
            }
        }
        
    }

}
