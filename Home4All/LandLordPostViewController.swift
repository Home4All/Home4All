//
//  LandLordPostViewController.swift
//  Home4All
//
//  Created by Ashish Mishra on 4/20/16.
//  Copyright © 2016 Home4All. All rights reserved.
//

import UIKit

enum TextFieldTag : NSInteger {
    case TextFieldTagRent = 0
      case TextFieldTagBath
       case TextFieldTagRoom
       case TextFieldTypeHouse
};

class LandLordPostViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    @IBOutlet weak var propertyType: UITextField!
    @IBOutlet weak var zipCodeField: UITextField!
    @IBOutlet weak var stateField: UITextField!
    var imagesToUpload : NSMutableArray = NSMutableArray();
    var imageToUpload: UIImageView = UIImageView();
    @IBOutlet weak var thumbnailCollectionView : UICollectionView!
    @IBOutlet weak var postTableView : UITableView!
    var tableViewData : NSMutableArray = []

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem?.action = #selector(LandLordPostViewController.postProperty);
        self.arrangeTableView();
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
        self.thumbnailCollectionView.reloadData()
    }
    
    func arrangeTableView() {
        
        let addressData : NSMutableDictionary = NSMutableDictionary();
        let addressarray : NSMutableArray = NSMutableArray();
        addressarray.addObject("Street");
        addressarray.addObject("CityName");
        addressarray.addObject("State");
        addressarray.addObject("ZipCode");
        addressData.setValue(addressarray, forKey: "Address")
        tableViewData.addObject(addressData);
        
        let propertyTypeData : NSMutableDictionary = NSMutableDictionary();
        let propertyTypeArray : NSMutableArray = NSMutableArray();
        propertyTypeArray.addObject("Property Type");
        propertyTypeData.setValue(propertyTypeArray, forKey: "Property Type")
        tableViewData.addObject(propertyTypeData);

        
        let homeinfoData : NSMutableDictionary = NSMutableDictionary();
        let homeinfoArray : NSMutableArray = NSMutableArray();
        homeinfoArray.addObject("No Of Rooms");
        homeinfoArray.addObject("No Of Baths");
        homeinfoArray.addObject("Area(Sq Foot)");
        homeinfoData.setValue(homeinfoArray, forKey: "Home Info")
        tableViewData.addObject(homeinfoData);

        
        let rentInfo : NSMutableDictionary = NSMutableDictionary();
        let rentArray : NSMutableArray = NSMutableArray();
        rentArray.addObject("Rent($)");
        rentInfo.setValue(rentArray, forKey: "Rent")
        tableViewData.addObject(rentInfo);

        
        let contactInfoDic : NSMutableDictionary = NSMutableDictionary();
        let contactInfo : NSMutableArray = NSMutableArray();
        contactInfo.addObject("Contact Info");
        contactInfoDic.setValue(contactInfo, forKey: "Contact Info")
        tableViewData.addObject(contactInfoDic);

    }
    
    
     @IBAction func postProperty(sender: AnyObject) {
        
        let zipCode : NSString = self.zipCodeField.text!;
        let stateField : NSString = self.stateField.text!
        let propertyType : NSString = self.propertyType.text!
        
        let username = NSUserDefaults.standardUserDefaults().objectForKey("username") as! NSString;

        let pictureData = UIImagePNGRepresentation(self.imageToUpload.image!)
        let file = PFFile(name: "image", data: pictureData!)
        
        let placePost = PlacePost(image: file!);
        placePost.setObject(zipCode, forKey: "zipcode")
        placePost.setObject(stateField, forKey: "state")
        placePost.setObject(propertyType, forKey: "propertytype")
        placePost.setObject(username, forKey: "postedby")
        
        placePost.saveInBackgroundWithBlock { (succeeded, error) -> Void in
            if succeeded {
                NSLog("Object Uploaded")
            } else {
                NSLog("Error: \(error) \(error!.userInfo)")
            }
        }
    }
    
    @IBAction func selectPicturePressed(sender: AnyObject) {
        //Open a UIImagePickerController to select the picture
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        presentViewController(imagePicker, animated: true, completion: nil)
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
        return 4
    }
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat{
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let sectionData : NSMutableDictionary = self.tableViewData[section] as! NSMutableDictionary
        let allKeys : NSArray = sectionData.allKeys as NSArray
        let keyForSection : NSString = allKeys[0] as! NSString
        let key : String = keyForSection as String
        let setionDataArray : NSArray = sectionData.valueForKey(key) as! NSArray ;
        return setionDataArray.count;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let postTableViewCell : PostTableViewCell = tableView.dequeueReusableCellWithIdentifier("PostTableViewCell", forIndexPath: indexPath) as! PostTableViewCell
        
        let sectionData : NSMutableDictionary = self.tableViewData[indexPath.section] as! NSMutableDictionary
        let allKeys : NSArray = sectionData.allKeys as NSArray
        let keyForSection : NSString = allKeys[0] as! NSString
        let key : String = keyForSection as String
        let setionDataArray : NSArray = sectionData.valueForKey(key) as! NSArray ;
        
        let rowLabel : String = (setionDataArray[indexPath.row] as? String)!
        postTableViewCell.propertyMetricLabel?.text = rowLabel;
        
        if(rowLabel == "No Of Rooms"){
            postTableViewCell.propertyMetricLabel?.tag = TextFieldTag.TextFieldTagRoom.rawValue
        } else if (rowLabel == "No Of Baths") {
            postTableViewCell.propertyMetricLabel?.tag = TextFieldTag.TextFieldTagBath.rawValue
        }else if(rowLabel == "Rent"){
           postTableViewCell.propertyMetricLabel?.tag = TextFieldTag.TextFieldTagRent.rawValue
        }else if(rowLabel == "Property Type") {
            postTableViewCell.propertyMetricLabel?.tag = TextFieldTag.TextFieldTypeHouse.rawValue
        }
        postTableViewCell.propertyMetricLabelValue?.placeholder = "Enter"+(setionDataArray[indexPath.row] as! String) as? String;

        return postTableViewCell;
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.tableViewData.count;
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let sectionData : NSMutableDictionary = self.tableViewData[section] as! NSMutableDictionary
        let allKeys : NSArray = sectionData.allKeys as NSArray
        let sectionHeader : NSString = allKeys[0] as! NSString
        return sectionHeader as String;
    }
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        if textField.tag == TextFieldTag.TextFieldTypeHouse.rawValue {
            
            
        } else if (textField.tag == TextFieldTag.TextFieldTagRoom.rawValue){
            
        }
        return false;
    }
    
}

extension LandLordPostViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        //Place the image in the imageview
//        self.imageToUpload.image = image
        if(self.imagesToUpload.count >= 5) {
          showAlert()
        }
        self.imagesToUpload.addObject(image);
        picker.dismissViewControllerAnimated(true, completion: nil)
}
    
     func showAlert() {
        let alertController = UIAlertController(title: "HEllo", message: "Exceeding limit", preferredStyle: .Alert)
        
        let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alertController.addAction(defaultAction)
        
        presentViewController(alertController, animated: true, completion: nil)
    }
}
