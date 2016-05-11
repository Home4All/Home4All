//
//  TenantFavoriteSearchViewController.swift
//  Home4All
//
//  Created by Ashish Mishra on 5/7/16.
//  Copyright © 2016 Home4All. All rights reserved.
//

import UIKit

class TenantFavoriteSearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tenantFavoriesTableView: UITableView!
    var favoriteSearches : NSArray = NSArray()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(animated: Bool) {
        self.fetchUserFavoritePost()
    }

    func fetchUserFavoritePost() {
        let userId = NSUserDefaults.standardUserDefaults().valueForKey("userid");
        let query = PFQuery(className: "AppUser")
        query.whereKey("userid", equalTo: userId!);
        query.includeKey("favorite")
        query.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
            if error == nil {
            let pfObjects : NSArray = objects!;
            if pfObjects.count > 0 && error == nil {
                
                let currentAppUser = pfObjects[0] as! PFObject;
                
                if let  favorites = currentAppUser.valueForKey("favorite") {
                    self.favoriteSearches = favorites as! NSArray
                    self.tenantFavoriesTableView.reloadData()
                }
 
            } else {
                NSLog("Error Retrieving user for favorite");
            }
        }
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return  self.favoriteSearches.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell=tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! CustomCell
        
        let placePost : PlacePost = self.favoriteSearches[indexPath.row] as! PlacePost;
        let cityText : String! = placePost.objectForKey("city") as? String
        let streetText: String! = placePost.objectForKey("street") as? String
        let priceText: Int! = placePost.objectForKey("rent") as? Int
        
         let counterText: Int! = placePost.objectForKey("counter") as? Int

        
        
        if let images = placePost.valueForKey("images") {
            let imageFiles = images as! NSArray
            let firstImageFile = imageFiles[0]
            firstImageFile.getDataInBackgroundWithBlock({ (data, error) in
                if let data = data {
                    if let image = UIImage(data: data) {
                        cell.photo.image=image
                        placePost.imageProperty = image
                    }
                }
            })
        }
     
        if cityText != nil{
            print("City is \(cityText)")
            cell.city.text=cityText
        }
        
        if streetText != nil{
            cell.street.text=streetText
        }
        
        if priceText != nil{
            print("Price is \(priceText)")
            cell.price.text="$ \(priceText) /mo"
        }
        
        if counterText != nil{
            print("View count is \(counterText)")
            cell.viewCount.text="\(counterText) Views"
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier("FavoriteDetailsegue", sender: indexPath)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "FavoriteDetailsegue"){
            let indexPath = sender as! NSIndexPath
            let row = indexPath.row as Int;
            let postingObject : PlacePost = self.favoriteSearches[row] as! PlacePost;
            let destinationViewController : TenantPostDetailViewController = segue.destinationViewController as! TenantPostDetailViewController
            destinationViewController.placePost = postingObject;
        }
    }

}
