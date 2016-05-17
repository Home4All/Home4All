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
    case TextFieldTypeEmail
};

class LandLordPostViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UITabBarDelegate{
    
    @IBOutlet weak var uploadImage: UIButton!
    @IBOutlet weak var propertyPickerView: UIPickerView!
    var imagesToUpload : NSMutableArray = NSMutableArray();
    var imageToUpload: UIImageView = UIImageView();
    @IBOutlet weak var thumbnailCollectionView : UICollectionView!
    @IBOutlet weak var postTableView : UITableView!
    var tableViewData : NSMutableArray = []
    var propertyTypes = ["Apartment","House","Condo"];
    var availableNumberOfRooms = ["1","2","3", "4","5","6"];
    var availableNumberOfBaths = ["1","1.5","2", "2.5","3"];
    var currentTextField : UITextField = UITextField()
    var allTextFields : NSMutableArray = NSMutableArray()

    var pickerDataSource : NSArray = NSArray()
    var placePost : PlacePost = PlacePost()
    var editInAction : Bool = false

    // MARK- View Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.navigationItem.rightBarButtonItem?.action = #selector(LandLordPostViewController.postProperty);
        self.arrangeTableView();
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(LandLordPostViewController.keyboardWillShow(_:)), name:UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(LandLordPostViewController.keyboardWillHide(_:)), name:UIKeyboardWillHideNotification, object: nil)
        
        if editInAction {
            self.imageToUpload.image = placePost.imageProperty
            self.imagesToUpload.addObject(self.imageToUpload.image!)
           // self.thumbnailCollectionView.reloadData()
        }
    }
    
     override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    override func viewDidAppear(animated: Bool) {
     // self.thumbnailCollectionView.reloadData()
        self.propertyPickerView.reloadAllComponents()
        self.emptyAllTextFileds()
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
        contactInfo.addObject("Email");
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
        
//        let contentInset:UIEdgeInsets = UIEdgeInsetsZero
//        self.postTableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
    }

    
    func emptyAllTextFileds() {
        for textfield in self.allTextFields {
            var tempTextField : UITextField;
            tempTextField = textfield as! UITextField;
            tempTextField.text = ""
    }
//        self.imageToUpload.image = nil;
        self.imagesToUpload = [];

//        self.uploadImage.enabled = true;
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

    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // the cells you would like the actions to appear needs to be editable
        return true
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
                if editInAction == true {
                    if let  noOfRoom = placePost.valueForKey("noofroom") as? NSNumber {
                          postTableViewCell.propertyMetricLabelValue?.text = "\(noOfRoom)"
                    }
                  
                }
            } else if (rowLabel == "No Of Baths") {
                postTableViewCell.propertyMetricLabelValue?.tag = TextFieldTag.TextFieldTagBath.rawValue
                if editInAction == true {
                    if let  noofbath = placePost.valueForKey("noofbath") as? NSNumber {
                        postTableViewCell.propertyMetricLabelValue?.text = "\(noofbath)"
                    }
      
                }
            }else if(rowLabel == "Property Type") {
                postTableViewCell.propertyMetricLabelValue?.tag = TextFieldTag.TextFieldTypeHouse.rawValue
                if editInAction == true {
                    if let housetype = placePost.valueForKey("housetype") as? String {
                        postTableViewCell.propertyMetricLabelValue?.text = housetype
                    }
                }
            } else if (rowLabel == "Area(Sq Foot)") {
                postTableViewCell.propertyMetricLabelValue?.tag = TextFieldTag.TextFieldTypeArea.rawValue
                if editInAction == true {
                    if let  area = placePost.valueForKey("area") as? NSNumber {
                        postTableViewCell.propertyMetricLabelValue?.text = "\(area)"
                    }
                    
                }
            }
            else if (rowLabel == "Street") {
                postTableViewCell.propertyMetricLabelValue?.tag = TextFieldTag.TextFieldTypeStreet.rawValue
                if editInAction == true {
                    if let street = placePost.valueForKey("street") as? String {
                        postTableViewCell.propertyMetricLabelValue?.text = street
                    }                 }
            }else if (rowLabel == "CityName") {
                postTableViewCell.propertyMetricLabelValue?.tag = TextFieldTag.TextFieldTypeCityName.rawValue
                if editInAction == true {
                    if let city = placePost.valueForKey("city") as? String {
                        postTableViewCell.propertyMetricLabelValue?.text = city
                    }                }
            }else if (rowLabel == "State") {
                postTableViewCell.propertyMetricLabelValue?.tag = TextFieldTag.TextFieldTypeState.rawValue
                if editInAction == true {
                    if let state = placePost.valueForKey("state") as? String {
                        postTableViewCell.propertyMetricLabelValue?.text = state
                    }
                }
            }else if (rowLabel == "Contact Info") {
                postTableViewCell.propertyMetricLabelValue?.tag = TextFieldTag.TextFieldTypeContactInfo.rawValue
                if editInAction == true {
                    if let  contact = placePost.valueForKey("contact") as? NSNumber {
                        postTableViewCell.propertyMetricLabelValue?.text = "\(contact)"
                    }
         
                }
                
            }else if (rowLabel == "ZipCode") {
                postTableViewCell.propertyMetricLabelValue?.tag = TextFieldTag.TextFieldTypeZip.rawValue
                if editInAction == true {
                    if let  zip = placePost.valueForKey("zip") as? NSNumber {
                        postTableViewCell.propertyMetricLabelValue?.text = "\(zip)"
                    }
                }
            }
                
            else if (rowLabel == "Rent($)") {
                postTableViewCell.propertyMetricLabelValue?.tag = TextFieldTag.TextFieldTypeRent.rawValue
                if editInAction == true {
                    if let  rent = placePost.valueForKey("rent") as? NSNumber {
                        postTableViewCell.propertyMetricLabelValue?.text = "\(rent)"
                    }
                }
            }
            else if (rowLabel == "Email") {
                postTableViewCell.propertyMetricLabelValue?.tag = TextFieldTag.TextFieldTypeEmail.rawValue
                if editInAction == true {
                    if let  email = placePost.valueForKey("email") as? String {
                        postTableViewCell.propertyMetricLabelValue?.text = email
                    }
                }
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
        if(textField.tag == (TextFieldTag.TextFieldTypeZip.rawValue) || textField.tag == (TextFieldTag.TextFieldTypeArea.rawValue) || textField.tag == (TextFieldTag.TextFieldTypeRent.rawValue) || textField.tag == (TextFieldTag.TextFieldTypeContactInfo.rawValue)) {
            
            // Create a button bar for the number pad
            let keyboardDoneButtonView = UIToolbar()
            keyboardDoneButtonView.sizeToFit()
            
            // Setup the buttons to be put in the system.
            let item = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(LandLordPostViewController.endEditingNow) )
            let toolbarButtons = [item]
            
            //Put the buttons into the ToolBar and display the tool bar
            keyboardDoneButtonView.setItems(toolbarButtons, animated: false)
            textField.inputAccessoryView = keyboardDoneButtonView

            textField.keyboardType = UIKeyboardType.NumberPad;
        }
    }
    
    func endEditingNow(){
        self.view.endEditing(true)
    }
    
 
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        var alreadyPresented = false;
        self.propertyPickerView.hidden = true

        for textFieldObj in self.allTextFields {
            if(textFieldObj.tag == textField.tag) {
                alreadyPresented = true;
                break;
            }
        }
        if alreadyPresented == false {
            self.allTextFields.addObject(textField);
        }
        
        self.allTextFields.addObject(textField);
        if textField.tag == TextFieldTag.TextFieldTypeHouse.rawValue {
            self.propertyPickerView.hidden = false
            self.propertyPickerView.becomeFirstResponder()
            self.pickerDataSource = self.propertyTypes
            self.propertyPickerView.reloadAllComponents()
            self.propertyPickerView.tag = textField.tag
            currentTextField = textField;
            return false;

        } else if (textField.tag == TextFieldTag.TextFieldTagRoom.rawValue){
            self.propertyPickerView.hidden = false
            self.propertyPickerView.becomeFirstResponder()

            self.pickerDataSource = self.availableNumberOfRooms
            self.propertyPickerView.reloadAllComponents()
            self.propertyPickerView.tag = textField.tag
            currentTextField = textField;
            return false;

        }else if (textField.tag == TextFieldTag.TextFieldTagBath.rawValue){
            self.propertyPickerView.hidden = false
            self.propertyPickerView.becomeFirstResponder()

            self.pickerDataSource = self.availableNumberOfBaths
            self.propertyPickerView.reloadAllComponents()
            self.propertyPickerView.tag = textField.tag
            currentTextField = textField;
            return false;

        }
        return true;
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        
        let numberFormatter : NSNumberFormatter = NSNumberFormatter()
        numberFormatter.numberStyle = NSNumberFormatterStyle.DecimalStyle
        if (textField.tag == TextFieldTag.TextFieldTypeArea.rawValue){
            if let textValue = textField.text {
                if let numberFromString = numberFormatter.numberFromString(textValue) {
                    self.placePost.setObject(numberFromString, forKey: "area");
                } else {
                    self.placePost.setObject(NSNumber(int : 0), forKey: "area");
                }
            }
            
        }else if (textField.tag == TextFieldTag.TextFieldTypeRent.rawValue){
            if let textValue = textField.text {
                if let numberFromString = numberFormatter.numberFromString(textValue) {
                self.placePost.setObject(numberFromString, forKey: "rent");
                } else {
                    self.placePost.setObject(NSNumber(int : 0), forKey: "rent");
                }
            }

        }else if (textField.tag == TextFieldTag.TextFieldTypeContactInfo.rawValue){
            if let textValue = textField.text {
                if let numberFromString = numberFormatter.numberFromString(textValue) {
                    if !validateContact(textValue) {
                        self.placePost.setObject(numberFromString, forKey: "contact");

                    } else {
                        self.placePost.setObject(numberFromString, forKey: "contact");
                    }
                    
                }
            }

        }else if (textField.tag == TextFieldTag.TextFieldTypeState.rawValue){
            
            if let textValue = textField.text {
                self.placePost.setObject(textValue, forKey: "state");
            }

        }else if (textField.tag == TextFieldTag.TextFieldTypeCityName.rawValue){
            
            if let textValue = textField.text {
                self.placePost.setObject(textValue, forKey: "city");
                self.placePost.setObject(textValue.lowercaseString, forKey: "citysearch");
            }

        }else if (textField.tag == TextFieldTag.TextFieldTypeStreet.rawValue){
            if let textValue = textField.text {
                self.placePost.setObject(textValue, forKey: "street");
            }
            
        }else if (textField.tag == TextFieldTag.TextFieldTypeZip.rawValue){
            if let textValue = textField.text {
                if let numberFromString = numberFormatter.numberFromString(textValue) {
                    self.placePost.setObject(numberFromString, forKey: "zip");
                }
            }
        }else if (textField.tag == TextFieldTag.TextFieldTypeEmail.rawValue){
            if let textValue = textField.text {
                if self.isValidEmail(textValue) {
                    self.placePost.setObject(textValue, forKey: "email");
                } else {
                    self.placePost.setObject(textValue, forKey: "email");
                }
            }
        }
    }
    
    func validateContact(value: String) -> Bool {
        let PHONE_REGEX = "^\\d{3}-\\d{3}-\\d{4}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
        let result =  phoneTest.evaluateWithObject(value)
        return result
    }
    
    func isValidEmail(testStr:String) -> Bool {
        // println("validate calendar: \(testStr)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluateWithObject(testStr)
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
        let numberFormatter : NSNumberFormatter = NSNumberFormatter()
        numberFormatter.numberStyle = NSNumberFormatterStyle.DecimalStyle
        
        if (pickerView.tag == TextFieldTag.TextFieldTagBath.rawValue) {
            let numberFromString = numberFormatter.numberFromString((self.pickerDataSource[row] as? String)!)
            self.placePost.setObject(numberFromString!, forKey: "noofbath");
            currentTextField.text = self.pickerDataSource[row] as? String;

        }else if (pickerView.tag == TextFieldTag.TextFieldTagRoom.rawValue) {
            let numberFromString = numberFormatter.numberFromString((self.pickerDataSource[row] as? String)!)
            self.placePost.setObject(numberFromString!, forKey: "noofroom");
            currentTextField.text = self.pickerDataSource[row] as? String;

        } else if (pickerView.tag == TextFieldTag.TextFieldTypeHouse.rawValue) {
            self.placePost.setObject(self.pickerDataSource[row], forKey: "housetype");
            currentTextField.text = self.pickerDataSource[row] as? String;
        }
        pickerView.hidden = true;
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "PhotoUpload"){
            if isRequiredValuesPresent() {
                let destinationViewController : ImageUploadViewController = segue.destinationViewController as! ImageUploadViewController
                destinationViewController.placePost = self.placePost;
                destinationViewController.editInAction = self.editInAction;
            }
        }
    }
    
    func isRequiredValuesPresent() -> Bool {
        
         let streetValue = placePost.valueForKey("street")
         let cityValue = placePost.valueForKey("city")
         let stateValue = placePost.valueForKey("state")
        let houseType = placePost.valueForKey("housetype")
        let noOfRoom = placePost.valueForKey("noofroom")
        
        let noOfBath = placePost.valueForKey("noofbath")
        let areaValue = placePost.valueForKey("area")
        let rentValue = placePost.valueForKey("rent")
        let zipCodeValue = placePost.valueForKey("zip")
        let contactValue = placePost.valueForKey("contact")
        let email = placePost.valueForKey("email")
        
        if (streetValue == nil || cityValue == nil || stateValue == nil ||  houseType == nil || noOfRoom == nil || noOfBath == nil || areaValue == nil || rentValue == nil || zipCodeValue == nil || contactValue == nil || email == nil) {
            
            self.showAlert("Insufficient Information", message: "Please provide all the values before posting");
            return false;
        }
        
        return true;
    }
}


extension LandLordPostViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
//    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
//        if self.imagesToUpload.count > 0 {
//            self.imagesToUpload = []
//        }
//        
//        self.imageToUpload.image = image;
//        self.imagesToUpload.addObject(image);
////        self.thumbnailCollectionView.reloadData()
//        picker.dismissViewControllerAnimated(true, completion: nil)
//        if(self.imagesToUpload.count == 1 ) {
//            let title : NSString = "Limit Reached";
//            let message : NSString = "You can not add more photos";
//            showAlert(title, message: message)
//            self.uploadImage.enabled = false
//        }
//}
    
    func showAlert(title : NSString, message : NSString) {
        let alertController = UIAlertController(title: title as String, message:message as String, preferredStyle: .Alert)
        
        let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alertController.addAction(defaultAction)
        self.presentViewController(alertController, animated: true, completion: nil)
    }
}
