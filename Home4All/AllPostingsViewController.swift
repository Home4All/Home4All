//
//  AllPostingsViewController.swift
//  Home4All
//
//  Created by Ashish Mishra on 4/20/16.
//  Copyright © 2016 Home4All. All rights reserved.
//

import UIKit

class AllPostingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var allpostingsTableView: UITableView!
    var allPostings : NSArray = NSArray();

    override func viewDidLoad() {
        super.viewDidLoad()
        retrieveAllPostings();

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
        retrieveAllPostings();

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func retrieveAllPostings() {
        
        let username : NSString = NSUserDefaults.standardUserDefaults().objectForKey("userid") as! NSString;
        
        let query = PlacePost.query()! as PFQuery
        query.whereKey("postedby", equalTo: username)
        query.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
            if error == nil {
            let pfObjects : NSArray = objects!;
            if pfObjects.count >= 0 && error == nil {
                NSLog("Successfully retrieved: \(objects)")
            self.allPostings = objects!;
            self.allpostingsTableView.reloadData()
            } else {
                NSLog("Call failed");
            }
        }
        }
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.allPostings.count;
    }
//    
//    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//        let allpostingTableCell = tableView.dequeueReusableCellWithIdentifier("AllPostingTableCell", forIndexPath: indexPath) as! AllPostingsTableViewCell
//        
//        let row = indexPath.row as Int;
//        let postingObject : PlacePost = self.allPostings[row] as! PlacePost;
//        let stateText = postingObject.objectForKey("state") as? String
//        let zipCode = postingObject.objectForKey("zip") as? NSInteger
//        if stateText != nil && zipCode != nil {
//            allpostingTableCell.state.text = stateText! + "\(zipCode!)";
//        }
//        let houseType = postingObject.objectForKey("housetype") as? String;
//        if houseType != nil {
//              allpostingTableCell.propertyType.text = houseType;
//        }
//        
//        if let images = postingObject.valueForKey("images") {
//            if images.count == 0 {
//                return allpostingTableCell
//            }
//            let imageFiles = images as! NSArray
//            let firstImageFile = imageFiles[0]
//            firstImageFile.getDataInBackgroundWithBlock({ (data, error) in
//                if let data = data {
//                    if let image = UIImage(data: data) {
//                        allpostingTableCell.propertyImageView.image = image;
//                        postingObject.imageProperty = image
//                    }
//                }
//            })
//        }
//      
//        return allpostingTableCell;
//        }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
     let cell = tableView.dequeueReusableCellWithIdentifier("AllPostingTableCell", forIndexPath: indexPath) as! AllPostingsTableViewCell
        
        if  self.allPostings.count == 0 {
            return cell
        }
        
        let placePost : PlacePost = self.allPostings[indexPath.row] as! PlacePost;
        let cityText:String! = placePost.objectForKey("city") as? String
        let streetText:String! = placePost.objectForKey("street") as? String
        let priceText:Int! = placePost.objectForKey("rent") as? Int
        
        let countText:Int! = placePost.objectForKey("counter") as? Int
        
        if let images = placePost.valueForKey("images") {
            if images.count != 0 {
                let imageFiles = images as! NSArray
                let firstImageFile = imageFiles[0]
                firstImageFile.getDataInBackgroundWithBlock({ (data, error) in
                    if let data = data {
                        if let image = UIImage(data: data) {
                            cell.propertyImageView.image=image
                            placePost.imageProperty = image
                        }
                    }
                })
            }
        }
        
        if countText != nil{
            print("Count is \(countText)")
            cell.viewCounter.text = "\(countText) Views"
        }
        
        if cityText != nil{
            print("City is \(cityText)")
            cell.cityLabel.text=cityText
        }
        
        if streetText != nil{
            cell.streetLabel.text=streetText
        }
        
        if priceText != nil{
            print("Price is \(priceText)")
            cell.rentLabel.text="$ \(priceText) /mo"
        }
        return cell
    }
    
    
    
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        // you need to implement this method too or you can't swipe to display the actions
    }
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .Normal, title: "Delete") { action, index in
            
            self.deleteCurrentpost(indexPath)
        }
        delete.backgroundColor = UIColor.lightGrayColor()
        
        let edit = UITableViewRowAction(style: .Normal, title: "Edit") { action, index in
            
            self.performSegueWithIdentifier("PostAdViewController", sender: indexPath)
            
        }
        edit.backgroundColor = UIColor.orangeColor()
        
        return [delete, edit]
    }
    
    func deleteCurrentpost(indexPath : NSIndexPath) {
        let row = indexPath.row as Int;
        let postingObject : PlacePost = self.allPostings[row] as! PlacePost;
        postingObject.deleteInBackgroundWithBlock { (success, errors) in
            if(success){
                self.showAlert("Successful", message: "Posting Deleted.")
                self.retrieveAllPostings()
            }
        }
    }
    
    func showAlert(title : NSString, message : NSString) {
        let alertController = UIAlertController(title: title as String, message:message as String, preferredStyle: .Alert)
        
        let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alertController.addAction(defaultAction)
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "PostAdViewController"){
            let indexPath = sender as! NSIndexPath
            let row = indexPath.row as Int;
            let postingObject : PlacePost = self.allPostings[row] as! PlacePost;
            let destinationViewController : LandLordPostViewController = segue.destinationViewController as! LandLordPostViewController
            destinationViewController.editInAction = true;
            destinationViewController.placePost = postingObject;
        }
    }

}
