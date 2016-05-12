 //
//  ImageUploadViewController.swift
//  Home4All
//
//  Created by Ashish Mishra on 4/23/16.
//  Copyright © 2016 Home4All. All rights reserved.
//

import UIKit

class ImageUploadViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UITextViewDelegate {

    @IBOutlet weak var descriptiontextView: UITextView!
    @IBOutlet weak var imageCollectionView : UICollectionView!;
    var imagesToUpload : NSMutableArray = NSMutableArray();
    var placePost : PlacePost = PlacePost()
    
    var username: String?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
            }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1;
    }
    
    
    //UICollectionViewDataSource Methods (Remove the "!" on variables in the function prototype)
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return self.imagesToUpload.count;
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell{
        let cell: PhotoUploadThumbnailCell = collectionView.dequeueReusableCellWithReuseIdentifier("PhotoThumbnailCell", forIndexPath: indexPath) as! PhotoUploadThumbnailCell
        let image = self.imagesToUpload[indexPath.item] as! UIImage
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
    
      func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
//    func textViewDidEndEditing(textView: UITextView) {
//        if let descriptionText = textView.text {
//        self.placePost.setObject(descriptionText, forKey: "description");
//        }
//    }
//    
    func textViewDidChange(textView: UITextView) {
        if let descriptionText = textView.text {
            self.placePost.setObject(descriptionText, forKey: "postdescription");
            self.placePost.setObject(descriptionText.lowercaseString, forKey: "descriptionsearch");
        }
    }
    func textViewShouldEndEditing(textView: UITextView) -> Bool {
        return true
    }
    
    @IBAction func selectPicturePressed(sender: AnyObject) {
        //Open a UIImagePickerController to select the picture
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func postProperty(sender: AnyObject) {
        let userid = NSUserDefaults.standardUserDefaults().objectForKey("userid") as! NSString;
        let username = NSUserDefaults.standardUserDefaults().objectForKey("username") as! NSString;
        let emailid = NSUserDefaults.standardUserDefaults().objectForKey("emailid") as! NSString;
        
        var imageFiles : NSMutableArray = NSMutableArray()
        
        for anImage in self.imagesToUpload {
            let pictureData = UIImageJPEGRepresentation(anImage as! UIImage, 0.25)
            let file = PFFile(name: "image", data: pictureData!)
            imageFiles.addObject(file!)
        }
        
        self.placePost.setObject(imageFiles.copy() as! NSArray,forKey: "images");
        self.placePost.setObject(userid, forKey: "postedby")
        self.placePost.setObject(NSNumber(int : 0), forKey: "counter")
        self.placePost.saveInBackgroundWithBlock { (succeeded, error) -> Void in
            if succeeded {
                NSLog("Object Uploaded")
                
                let place = self.placePost.valueForKey("city") as? NSString
                let price = self.placePost.valueForKey("rent") as? NSNumber
                
                if place != nil && price != nil {
                    let postInfo  = "  You have posted a home with:"+"price"+"\(price)"+"at"+"\(place)";
                    
                    let valueObjects : NSArray = [emailid,username,postInfo];
                    let keys : NSArray = ["email","name","message"];
                    let  parameters : NSDictionary = NSDictionary.init(objects: valueObjects as [AnyObject], forKeys: keys as! [NSCopying]);
                    
                    PFCloud.callFunctionInBackground("sendEmail", withParameters: parameters as [NSObject : AnyObject]) {
                        (response: AnyObject?, error: NSError?) -> Void in
                        if (response != nil) {
                            NSLog(response as! String);
                            self.showAlert("Success", message: "Post saved and Mail sent");
                        }
                    }
                }
                
            } else {
                NSLog("Error: \(error) \(error!.userInfo)")
            }
        }
    }
}

extension ImageUploadViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {

        self.imagesToUpload.addObject(image);
        self.imageCollectionView.reloadData()
        picker.dismissViewControllerAnimated(true, completion: nil)
        if(self.imagesToUpload.count == 5 ) {
            let title : NSString = "Limit Reached";
            let message : NSString = "You can not add more photos";
            showAlert(title, message: message)
        }
    }
    
    func showAlert(title : NSString, message : NSString) {
        let alertController = UIAlertController(title: title as String, message:message as String, preferredStyle: .Alert)
        
        let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alertController.addAction(defaultAction)
        self.presentViewController(alertController, animated: true, completion: nil)
    }
}
