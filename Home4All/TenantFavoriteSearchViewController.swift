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
 var savedSearchParameters : SavedSearch = SavedSearch()
    var iSComingFrmSavedsearch = false
    override func viewDidLoad() {
        
        super.viewDidLoad()
    
    // Do any additional setup after loading the view.
    }
    
    func fetchDataForsavedSearch () {
        
        print ("Saved search parametersrsrsrsrsrsr,\(savedSearchParameters)")
        let query = PlacePost.query()! as PFQuery
        
        // 2
        //            query.whereKey("city", containsString: cityValue!)
        //            query.whereKey("zip", equalTo: zipCodeValue!)
        //
        //
//        let cityText:String! = savedSearchParameters.objectForKey("city") as? String
//        let max:Int! = savedSearchParameters.objectForKey("maxrent") as? Int
//        let zip:Int! = savedSearchParameters.objectForKey("zipcode") as? Int
//        
//        let min:Int! = savedSearchParameters.objectForKey("minrent") as? Int
//        
//        var propertytype:String! = savedSearchParameters.objectForKey("propertytype") as? String
//        
//        let keywordesarch:String! = savedSearchParameters.objectForKey("keywordsearch") as? String
//       
//        if zip==nil
//        {
//        }
//        else
//        {
//            query.whereKey("zip", equalTo: zip!)
//        }
//
//        if cityText==nil {
//        }
//        else{
//        query.whereKey("citysearch", containsString: cityText?.lowercaseString)
//        }
////
////        if min == nil{
////        } else {
////            query.whereKey("rent", greaterThan: min!)
////        }
////
////        if max == nil{
////        } else {
////            query.whereKey("rent", lessThan: max!)
////        }
////        
////        
//////        if (propertytype == nil) {
//////        } else {
//////            query.whereKey("housetype", containsString: propertytype!)
//////        }
//////        
////
////        
////        if (keywordesarch == nil) {
////        } else {
////            query.whereKey("descriptionsearch", containsString: keywordesarch?.lowercaseString)
////        }
        
        
        let keyword = savedSearchParameters.valueForKey("keyword") as? String
        let city = savedSearchParameters.valueForKey("city") as? String
        let zipCode = savedSearchParameters.valueForKey("zip") as? NSNumber
        var minrent = savedSearchParameters.valueForKey("minrent") as? NSNumber
        var maxrent = savedSearchParameters.valueForKey("maxrent") as? NSNumber
        let propertType = savedSearchParameters.valueForKey("propertytype") as? String
        let apartmentType = ["Any","Apartment","House","Condo"]

        
        if (minrent == nil) {
            minrent = NSNumber(int : 0)
        }
        
        if (maxrent == nil) {
            maxrent = NSIntegerMax
        }
        
    
        
      //  let query = PlacePost.query()! as PFQuery
        if (city == nil || (city?.isEmpty)!) {
            
        } else {
            query.whereKey("citysearch", containsString: city?.lowercaseString)
        }
        
        if (zipCode == nil) {
            
        }
        else {
            query.whereKey("zip", equalTo: zipCode!)
        }
        
        if (keyword == nil || (keyword?.isEmpty)!) {
        } else {
            query.whereKey("descriptionsearch", containsString: keyword?.lowercaseString)
        }
        
        query.whereKey("rent", lessThan: maxrent!)
        query.whereKey("rent", greaterThan: minrent!)
        
        if (propertType == nil || (propertType?.isEmpty)!) {
            query.whereKey("housetype", containedIn: apartmentType )
        } else {
            query.whereKey("housetype", containsString: propertType)
        }
        
        
        
        
        query.findObjectsInBackgroundWithBlock {
            (objects, error) -> Void in
            
            
            if error != nil{
                print(error)
                
                
            }else{
                print("aaaa gayaayyayayaya \(objects)")
                self.favoriteSearches = objects!;
                self.tenantFavoriesTableView.reloadData()
                
            }
        }
    }
    override func viewDidAppear(animated: Bool) {
        if iSComingFrmSavedsearch {
            self.fetchDataForsavedSearch()
        } else {
            self.fetchUserFavoritePost()
        }
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
            if imageFiles.count != 0 {
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
