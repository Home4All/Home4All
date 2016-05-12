//
//  TenantSavedSearchViewController.swift
//  Home4All
//
//  Created by Ashish Mishra on 5/8/16.
//  Copyright © 2016 Home4All. All rights reserved.
//

import UIKit

class TenantSavedSearchViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var savedSearchTableView: UITableView!
    var savedSearchedResults : NSArray = NSArray()
    var savedSearch : SavedSearch = SavedSearch()
  
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
        self.fetchSavedSearchResults()
    }
    
    func fetchSavedSearchResults() {
        let userId = NSUserDefaults.standardUserDefaults().valueForKey("userid");
        let query = PFQuery(className: "AppUser")
        query.whereKey("userid", equalTo: userId!);
        query.includeKey("savedsearches")
        query.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
            if error == nil {
            let pfObjects : NSArray = objects!;
            if pfObjects.count > 0 && error == nil {
                
                let currentAppUser = pfObjects[0] as! PFObject;
                
                if let  savedSearches = currentAppUser.valueForKey("savedsearches") {
                    self.savedSearchedResults = savedSearches as! NSArray
                    self.savedSearchTableView.reloadData()
                }
            } else {
                NSLog("Error Retrieving user for favorite");
            }
        }
        }
    }

    @IBAction func removeSavedSearch(sender: AnyObject) {
        
        let deleteButton : UIButton = sender as! UIButton;
        let currentIndex = deleteButton.tag;
        
        let userId = NSUserDefaults.standardUserDefaults().valueForKey("userid");
        let query = PFQuery(className: "AppUser")
        query.whereKey("userid", equalTo: userId!);
        query.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
            let pfObjects : NSArray = objects!;
            if pfObjects.count > 0 && error == nil {
                
                let currentAppUser = pfObjects[0] as! PFObject;
                
                if let  savedSearches = currentAppUser.valueForKey("savedsearches") {
                    let savedSearchesArray : NSMutableArray = savedSearches.mutableCopy() as! NSMutableArray
                    let currentsavedSearch : SavedSearch = self.savedSearchedResults[currentIndex] as! SavedSearch;
                    savedSearchesArray.removeObject(currentsavedSearch)
                    
                    currentAppUser.setObject(savedSearchesArray.copy() as! NSArray, forKey: "savedsearches")
                    
                }
            currentAppUser.saveInBackgroundWithBlock({ (success, error) in
                    if (success){
                        NSLog("Successfully saved searches")
                        self.fetchSavedSearchResults()
                    } else {
                        NSLog("error in  saving searches")
                        
                    }
                })
            } else {
                NSLog("Error Retrieving user for favorite");
            }
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.savedSearchedResults.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell=tableView.dequeueReusableCellWithIdentifier("SavedSearchCustomCell", forIndexPath: indexPath) as! SavedSearchCustomCell
        
        let savedSearch : SavedSearch = self.savedSearchedResults[indexPath.row] as! SavedSearch;
        
        let propertyType : String! = savedSearch.objectForKey("propertytype") as? String
        let city : String! = savedSearch.objectForKey("city") as? String
        let minRent: Int! = savedSearch.objectForKey("minrent") as? Int
        let maxRent: Int! = savedSearch.objectForKey("maxrent") as? Int
         let keyword : String! = savedSearch.objectForKey("keywordsearch") as? String
              let zipcode: Int! = savedSearch.objectForKey("zipcode") as? Int


        

        if propertyType != nil{
            cell.propertyType.text=propertyType
        }
        
        if city != nil{
            cell.cityName.text=city
        }
        
        if minRent != nil && maxRent != nil{
            cell.priceMinLabel.text="$\(minRent)"
        }
        
        if maxRent != nil{
            cell.priceMaxLabel.text="$\(maxRent)"
        }
        
        
        if keyword != nil{
            cell.keywordsearch.text=keyword
        }
        if zipcode != nil{
            cell.zipcode.text="\(zipcode)"
        }
        
        
        
        return cell

    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier("SavedSearchSegue", sender: indexPath)
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "SavedSearchSegue"){
           
            
            let indexPath = sender as! NSIndexPath
            let row = indexPath.row as Int;
            let postingObject : SavedSearch = self.savedSearchedResults[row] as! SavedSearch;
            let destinationViewController : TenantFavoriteSearchViewController = segue.destinationViewController as! TenantFavoriteSearchViewController
            destinationViewController.savedSearchParameters = postingObject;
            destinationViewController.iSComingFrmSavedsearch = true;
            
        }
    }
    
    
}
