//
//  LandLordPostViewController.swift
//  Home4All
//
//  Created by Ashish Mishra on 4/20/16.
//  Copyright © 2016 Home4All. All rights reserved.
//

import UIKit

enum TextFieldTag : NSInteger {
    case TextFieldTagBath = 100
    case TextFieldTagRoom
    case TextFieldTypeHouse
    case TextFieldTypeArea
    case TextFieldTypeStreet
    case TextFieldTypeCityName
    case TextFieldTypeState
    case TextFieldTypeRent
    case TextFieldTypeContactInfo
    case TextFieldTypeZip

};

class LandLordPostViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource{
    
    @IBOutlet weak var uploadImage: UIButton!
    @IBOutlet weak var propertyPickerView: UIPickerView!
    var imagesToUpload : NSMutableArray = NSMutableArray();
    var imageToUpload: UIImageView = UIImageView();
    @IBOutlet weak var thumbnailCollectionView : UICollectionView!
    @IBOutlet weak var postTableView : UITableView!
    var tableViewData : NSMutableArray = []
    var propertyTypes = ["House","Townhose","Condo", "Apartment"];
    var availableNumberOfRooms = ["1","2","3", "4","5","6"];
    var availableNumberOfBaths = ["1","1.5","2", "2.5","3"];
    var currentTextField : UITextField = UITextField()

    var pickerDataSource : NSArray = NSArray()
    var placePost : PlacePost = PlacePost()

    // MARK- View Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem?.action = #selector(LandLordPostViewController.postProperty);
        self.arrangeTableView();
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(LandLordPostViewController.keyboardWillShow(_:)), name:UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(LandLordPostViewController.keyboardWillHide(_:)), name:UIKeyboardWillHideNotification, object: nil)
    }
    
    
    override func viewDidAppear(animated: Bool) {
        self.thumbnailCollectionView.reloadData()
        self.propertyPickerView.reloadAllComponents()
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
    
    //MARK - Keyboard Notification Delegate
    
    func keyboardWillShow(notification:NSNotification){
        
        var userInfo = notification.userInfo!
        var keyboardFrame:CGRect = (userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue).CGRectValue()
        keyboardFrame = self.view.convertRect(keyboardFrame, fromView: nil)
        
        
        var contentInset:UIEdgeInsets = self.postTableView.contentInset
        contentInset.bottom = keyboardFrame.size.height
        self.postTableView.contentInset = contentInset
    }
    
    func keyboardWillHide(notification:NSNotification){
        
        let contentInset:UIEdgeInsets = UIEdgeInsetsZero
        self.postTableView.contentInset = contentInset
    }
    
    // Post property
     @IBAction func postProperty(sender: AnyObject) {
        let username = NSUserDefaults.standardUserDefaults().objectForKey("username") as! NSString;
        if(self.imageToUpload.image != nil){
            
            let pictureData = UIImagePNGRepresentation(self.imageToUpload.image!)
            let file = PFFile(name: "image", data: pictureData!)
            
            file?.saveInBackgroundWithBlock({ (success, error) in
                if((error == nil)){
                    self.placePost.setObject(username, forKey: "postedby")
                    self.placePost.setObject(file!, forKey: "image")
                    self.placePost.saveInBackgroundWithBlock { (succeeded, error) -> Void in
                        if succeeded {
                            NSLog("Object Uploaded")
                            
                        } else {
                            NSLog("Error: \(error) \(error!.userInfo)")
                        }
                    }
                }
            })
        }
    }
    
    @IBAction func selectPicturePressed(sender: AnyObject) {
        //Open a UIImagePickerController to select the picture
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    //MARK - CollectionView Delegate
    
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
    
    //MARK - TableViewDelegate
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let sectionData : NSMutableDictionary = self.tableViewData[section] as! NSMutableDictionary
        let allKeys : NSArray = sectionData.allKeys as NSArray
        let keyForSection : NSString = allKeys[0] as! NSString
        let key : String = keyForSection as String
        let setionDataArray : NSArray = sectionData.valueForKey(key) as! NSArray ;
        return setionDataArray.count;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
         let postTableViewCell : PostTableViewCell = (tableView.dequeueReusableCellWithIdentifier("PostTableViewCell", forIndexPath: indexPath) as? PostTableViewCell)!

            
            let sectionData : NSMutableDictionary = self.tableViewData[indexPath.section] as! NSMutableDictionary
            let allKeys : NSArray = sectionData.allKeys as NSArray
            let keyForSection : NSString = allKeys[0] as! NSString
            let key : String = keyForSection as String
            let setionDataArray : NSArray = sectionData.valueForKey(key) as! NSArray ;
            
            let rowLabel : String = (setionDataArray[indexPath.row] as? String)!
            postTableViewCell.propertyMetricLabel?.text = rowLabel;
            
            if(rowLabel == "No Of Rooms"){
                postTableViewCell.propertyMetricLabelValue?.tag = TextFieldTag.TextFieldTagRoom.rawValue
            } else if (rowLabel == "No Of Baths") {
                postTableViewCell.propertyMetricLabelValue?.tag = TextFieldTag.TextFieldTagBath.rawValue
            }else if(rowLabel == "Property Type") {
                postTableViewCell.propertyMetricLabelValue?.tag = TextFieldTag.TextFieldTypeHouse.rawValue
            } else if (rowLabel == "Area(Sq Foot)") {
                postTableViewCell.propertyMetricLabelValue?.tag = TextFieldTag.TextFieldTypeArea.rawValue
            }
            else if (rowLabel == "Street") {
                postTableViewCell.propertyMetricLabelValue?.tag = TextFieldTag.TextFieldTypeStreet.rawValue
            }else if (rowLabel == "CityName") {
                postTableViewCell.propertyMetricLabelValue?.tag = TextFieldTag.TextFieldTypeCityName.rawValue
            }else if (rowLabel == "State") {
                postTableViewCell.propertyMetricLabelValue?.tag = TextFieldTag.TextFieldTypeState.rawValue
            }else if (rowLabel == "ContactInfo") {
                postTableViewCell.propertyMetricLabelValue?.tag = TextFieldTag.TextFieldTypeContactInfo.rawValue
            }else if (rowLabel == "ZipCode") {
                postTableViewCell.propertyMetricLabelValue?.tag = TextFieldTag.TextFieldTypeZip.rawValue
            }
                
            else if (rowLabel == "Rent($)") {
                postTableViewCell.propertyMetricLabelValue?.tag = TextFieldTag.TextFieldTypeRent.rawValue
            }
            
            postTableViewCell.propertyMetricLabelValue?.placeholder = "Enter"+(setionDataArray[indexPath.row] as! String);

        
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
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
    }
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        if textField.tag == TextFieldTag.TextFieldTypeHouse.rawValue {
            self.propertyPickerView.hidden = false
            self.propertyPickerView.becomeFirstResponder()
            self.pickerDataSource = self.propertyTypes
            self.propertyPickerView.reloadAllComponents()
            self.propertyPickerView.tag = textField.tag
            currentTextField = textField;
            textField.resignFirstResponder()
            return false;

        } else if (textField.tag == TextFieldTag.TextFieldTagRoom.rawValue){
            self.propertyPickerView.hidden = false
            self.propertyPickerView.becomeFirstResponder()

            self.pickerDataSource = self.availableNumberOfRooms
            self.propertyPickerView.reloadAllComponents()
            self.propertyPickerView.tag = textField.tag
            currentTextField = textField;
            textField.resignFirstResponder()
            return false;

        }else if (textField.tag == TextFieldTag.TextFieldTagBath.rawValue){
            self.propertyPickerView.hidden = false
            self.propertyPickerView.becomeFirstResponder()

            self.pickerDataSource = self.availableNumberOfBaths
            self.propertyPickerView.reloadAllComponents()
            self.propertyPickerView.tag = textField.tag
            currentTextField = textField;
            textField.resignFirstResponder()
            return false;

        }
        return true;
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        if (textField.tag == TextFieldTag.TextFieldTypeArea.rawValue){
            self.placePost.setObject(textField.text!, forKey: "area");
        }else if (textField.tag == TextFieldTag.TextFieldTypeRent.rawValue){
            self.placePost.setObject(textField.text!, forKey: "rent");

        }else if (textField.tag == TextFieldTag.TextFieldTypeContactInfo.rawValue){
            self.placePost.setObject(textField.text!, forKey: "contact");

        }else if (textField.tag == TextFieldTag.TextFieldTypeState.rawValue){
            self.placePost.setObject(textField.text!, forKey: "state");

        }else if (textField.tag == TextFieldTag.TextFieldTypeCityName.rawValue){
            self.placePost.setObject(textField.text!, forKey: "city");

        }else if (textField.tag == TextFieldTag.TextFieldTypeStreet.rawValue){
            self.placePost.setObject(textField.text!, forKey: "street");
        }else if (textField.tag == TextFieldTag.TextFieldTypeZip.rawValue){
            self.placePost.setObject(textField.text!, forKey: "zip");
        }
    }
    
    //MARK - PickerView Methods
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1;
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.pickerDataSource.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.pickerDataSource[row] as? String
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if (pickerView.tag == TextFieldTag.TextFieldTagBath.rawValue) {
            self.placePost.setObject(self.pickerDataSource[row], forKey: "noofbath");
            currentTextField.text = self.pickerDataSource[row] as? String;

        }else if (pickerView.tag == TextFieldTag.TextFieldTagRoom.rawValue) {
            self.placePost.setObject(self.pickerDataSource[row], forKey: "noofroom");
            currentTextField.text = self.pickerDataSource[row] as? String;

        } else if (pickerView.tag == TextFieldTag.TextFieldTypeHouse.rawValue) {
            self.placePost.setObject(self.pickerDataSource[row], forKey: "housetype");
            currentTextField.text = self.pickerDataSource[row] as? String;

        }
        pickerView.hidden = true;
    }
}

extension LandLordPostViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        self.imageToUpload.image = image;
        self.imagesToUpload.addObject(image);
        picker.dismissViewControllerAnimated(true, completion: nil)
        if(self.imagesToUpload.count == 1 ) {
            showAlert()
            self.uploadImage.enabled = false
        }
}
    
     func showAlert() {
        let alertController = UIAlertController(title: "Limit Reached", message: "You can not add more photos", preferredStyle: .Alert)
        
        let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alertController.addAction(defaultAction)
        self.presentViewController(alertController, animated: true, completion: nil)
    }
}
