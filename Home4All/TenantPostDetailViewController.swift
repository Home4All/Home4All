//
//  TenantPostDetailViewController.swift
//  Home4All
//
//  Created by Ashish Mishra on 5/7/16.
//  Copyright © 2016 Home4All. All rights reserved.
//

import UIKit

class TenantPostDetailViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    @IBOutlet weak var contactLabel: UILabel!
    @IBOutlet weak var stateLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var streetLabel: UILabel!
    @IBOutlet weak var descriptionText: UITextView!
    @IBOutlet weak var apartmanetTypeLabel: UILabel!
    
    @IBOutlet weak var noOfBedLabel: UILabel!
    
    @IBOutlet weak var noOfBath: UILabel!
    
    @IBOutlet weak var zipCodeLabel: UILabel!
  
    @IBOutlet weak var rentLabel: UILabel!
    @IBOutlet weak var areaLabel: UILabel!
    var currentObject:String = "";
    var count:Int=0;
    var placePost : PlacePost = PlacePost()
    @IBOutlet weak var favoriteButton: UIBarButtonItem!
    
  
    var imageFiles : NSArray = NSArray()
    
   // @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var detailImageCollectionView: UICollectionView!
    var imagesArray : NSMutableArray = NSMutableArray()

    override func viewDidLoad() {
        super.viewDidLoad()
//            currentObject = (placePost.valueForKey("objectId") as? String)!
//        print(" object id isssss \(currentObject)")
       // let query = PFQuery(className: "PlacePost")
        
//        query.whereKey("objectId", equalTo: placePost.valueForKey("objectId")!)
//       
    
        self.title="Post Details"
         count =  Int(placePost.valueForKey("counter")! as! NSNumber)
    
        print ("dekhne k pehle \(count)")
        count+=1
        
   
        placePost.setObject(count, forKey:"counter")
        placePost.saveInBackgroundWithBlock { (success, error) in
            
            if(success){
             print ("dekhne k baad \(self.count)")
            
            }
            else{
            print (error)
        }
        }
        
       
        

// 3
//        query.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
//            if error == nil {
//              print("Successfully bahaaaaaai   retrieved: \(objects)")
//                
//    //let thisQuestion: AnyObject! = objects!.valueForKey("question")
//   // print (objects!["street"] as! String )
//                
//                
//            }
//            else {
//                print("Error: \(error) \(error!.userInfo)")
//            }
//        }
        
        
        
//        
//        let player = PFObject(className: "PlacePost")
//        player.setObject("John", forKey: "counter")
//        
//        player.saveInBackgroundWithBlock { (succeeded, error) -> Void in
//            if succeeded {
//                print("Object Uploaded")
//            } else {
//                print("Error:")
//            }
//        }
        
        
        
        
        
        
        
        
        print(placePost)
        
        self.retrieveImagesForCurrentPost()
        self.streetLabel.text = placePost.valueForKey("street") as? String
        self.cityLabel.text = placePost.valueForKey("city") as? String
        self.stateLabel.text = placePost.valueForKey("state") as? String
        
         self.contactLabel.text = placePost.valueForKey("contact") as? String
        
         
        
        
        self.descriptionText.text = placePost.valueForKey("postdescription") as? String
        self.apartmanetTypeLabel.text = placePost.valueForKey("housetype") as? String
     
        self.areaLabel.text = placePost.valueForKey("area") as? String
    
        let noOfRoomsString = String(placePost.valueForKey("noofroom")!)
        self.noOfBedLabel.text = noOfRoomsString
        
        
        let noOfBathsString = String(placePost.valueForKey("noofbath")!)
        self.noOfBath.text = noOfBathsString

        let areaLabelString = String("\(placePost.valueForKey("area")!)")
        self.areaLabel.text = areaLabelString

        let rentLabelString = String("$ \(placePost.valueForKey("rent")!) /mo")
        self.rentLabel.text = rentLabelString
        
        let zipCodeLabelString = String("\(placePost.valueForKey("zip")!)")
        self.zipCodeLabel.text = zipCodeLabelString
        
    }
    
    func retrieveImagesForCurrentPost() {
        if let images = self.placePost.valueForKey("images") {
        self.imageFiles = images as! NSArray
        let counter : Int = 0;
        for imageFile in self.imageFiles {
            imageFile.getDataInBackgroundWithBlock({ (data, error) in
                if error == nil {
                    if counter == self.imageFiles.count {
                        self.detailImageCollectionView.reloadData()
                    } else {
                        self.imagesArray.addObject(UIImage(data: data!)!)
                        self.detailImageCollectionView.reloadData()
                        
                    }
                }
            })
        }
        }
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
                        self.favoriteButton.tintColor = UIColor.redColor()

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
    
   
    
    //MARK - CollectionView Delegate
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1;
    }
    
    
    //UICollectionViewDataSource Methods (Remove the "!" on variables in the function prototype)
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return self.imagesArray.count;
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell{
        let cell: PhotoUploadThumbnailCell = collectionView.dequeueReusableCellWithReuseIdentifier("detailcell", forIndexPath: indexPath) as! PhotoUploadThumbnailCell
        let image = self.imagesArray[indexPath.item] as! UIImage
        cell.imgView.image = image;
        return cell
    }
    
    //UICollectionViewDelegateFlowLayout methods
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat{
        return 1
    }
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat{
        return 1
    }
    
    func showAlert(title : NSString, message : NSString) {
        let alertController = UIAlertController(title: title as String, message:message as String, preferredStyle: .Alert)
        
        let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alertController.addAction(defaultAction)
        self.presentViewController(alertController, animated: true, completion: nil)
    }
}
