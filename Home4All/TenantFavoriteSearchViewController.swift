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
        self.fetchUserFavoritePost()

        // Do any additional setup after loading the view.
    }

    func fetchUserFavoritePost() {
        let userId = NSUserDefaults.standardUserDefaults().valueForKey("userid");
        let query = PFQuery(className: "AppUser")
        query.whereKey("userid", equalTo: userId!);
        query.includeKey("favorite")
        query.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
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
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return  self.favoriteSearches.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell=tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! CustomCell
        
        let placePost : PlacePost = self.favoriteSearches[indexPath.row] as! PlacePost;
        let cityText : String! = placePost.objectForKey("city") as? String
        let streetText: String! = placePost.objectForKey("street") as? String
        let priceText: Int! = placePost.objectForKey("rent") as? Int
        
        
        placePost.image.getDataInBackgroundWithBlock { (data, error) in
            
            if((error) != nil){
                NSLog((error?.description)!);
            }
            if let data = data {
                if let image = UIImage(data: data) {
                    //                            allpostingTableCell.propertyImageView.image = image;
                    print("image  check is is \(image)")
                    placePost.imageProperty = image
                    cell.photo.image=image
                }
            }
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
            cell.price.text="\(priceText)"
        }
        return cell
    }

}
