 //
//  TenantSearchFilterOptionsViewController.swift
//  Home4All
//
//  Created by Ashish Mishra on 5/8/16.
//  Copyright © 2016 Home4All. All rights reserved.
//

import UIKit
 protocol TenantSearchFilterOptionsViewControllerDelegate: class {
    func didFinishSearch(searchOption : SavedSearch)
 }
class TenantSearchFilterOptionsViewController: UIViewController, UITextFieldDelegate {

   
    @IBOutlet weak var location: UITextField!
    
//    @IBOutlet weak var area_min: UITextField!
//    @IBOutlet weak var area_max: UITextField!
    @IBOutlet weak var price_max: UITextField!
    @IBOutlet weak var price_min: UITextField!
    @IBOutlet weak var zipcode: UITextField!
    @IBOutlet weak var propertyType: UITextField!
    @IBOutlet weak var searchkeyword: UITextField!
    @IBOutlet weak var typePickerView: UIPickerView!
    weak var tenantDelegate : TenantSearchFilterOptionsViewControllerDelegate?
    var currentTextField: UITextField = UITextField()
    var cityValue : String?
    var zipValue :Int?
    
    var savedSearch : SavedSearch = SavedSearch()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if cityValue != nil {
            self.location.text = cityValue!
        } else {
            self.location.text = ""
        }
        
        if zipValue != nil{
            self.zipcode.text = "\(zipValue!)"
        }else {
            zipValue = nil
            self.zipcode.text = ""
        }
        
    

        // Do any additional setup after loading the view.
    }
    
    @IBAction func searchFilter(sender: AnyObject) {
        self.currentTextField.resignFirstResponder()
        
        let city = self.savedSearch.valueForKey("city") as? String
        let zipCode = self.savedSearch.valueForKey("zip") as? NSNumber
        if (city == nil || (city?.isEmpty)!) && zipCode == nil && (self.location.text == nil || (self.location.text?.isEmpty)!) && (self.zipcode.text == nil || (self.zipcode.text?.isEmpty)!) {
            self.showAlert("Location Missing", message: "Please enter city or zip code to search")
        }else {
        self.navigationController?.popViewControllerAnimated(true)
        self.tenantDelegate?.didFinishSearch(self.savedSearch)
        }
    }
    
    func showAlert(title : NSString, message : NSString) {
        let alertController = UIAlertController(title: title as String, message:message as String, preferredStyle: .Alert)
        
        let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alertController.addAction(defaultAction)
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        if textField.tag == 600 {
            self.currentTextField.resignFirstResponder()
            self.typePickerView.hidden = false
            self.currentTextField = textField;
            return false
        }else {
            self.typePickerView.hidden = true
            self.currentTextField = textField;

        }
        return true
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        self.currentTextField = textField;
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        
        let numberFormatter : NSNumberFormatter = NSNumberFormatter()
        numberFormatter.numberStyle = NSNumberFormatterStyle.DecimalStyle
        if (textField.tag == 100){
            if let textValue = textField.text{
                self.savedSearch.setObject(textValue, forKey: "keyword");

            }
        }else if (textField.tag == 200){
            if let textValue = textField.text{
                self.savedSearch.setObject(textValue, forKey: "city");
            }
            
        }else if (textField.tag == 300){
            if let textValue = textField.text{
                if let numberFromString = numberFormatter.numberFromString(textValue) {
            self.savedSearch.setObject(numberFromString, forKey: "zip");
                }
            }
            
        }else if (textField.tag == 400){
            if let textValue = textField.text{
                if let numberFromString = numberFormatter.numberFromString(textValue) {
                    self.savedSearch.setObject(numberFromString, forKey: "minrent");
                }
            }
            
        }else if (textField.tag == 500){
            if let textValue = textField.text{
                if let numberFromString = numberFormatter.numberFromString(textValue) {
                    self.savedSearch.setObject(numberFromString, forKey: "maxrent");
                }
            }
        }
    }
    
    var apartmentType = ["Any","Apartment","House","Condo"]
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int
    {
        return 1;
    }
    
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return apartmentType.count
    }
    
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?{
        
        return apartmentType[row]
        
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    
        self.currentTextField.text = apartmentType[row]
        self.savedSearch.setObject(self.currentTextField.text!, forKey: "propertytype");
        self.typePickerView.hidden = true
    }


    @IBAction func saveThisSearch(sender: AnyObject) {
        
        let savedSearch : SavedSearch = SavedSearch()
        savedSearch.setObject(propertyType.text!, forKey: "propertytype")
        savedSearch.setObject(location.text!, forKey: "city")
        
        var min:Int? = Int(price_min.text!)
        var max:Int? = Int(price_max.text!)
        var zip:Int? = Int(zipcode.text!)
        
        if (zip == nil) {
            zip = 0
        }
        
        
        if (min == nil) {
            min = 0
        }
        
        if (max == nil) {
             max = NSIntegerMax
        }
        
        savedSearch.setObject(searchkeyword.text!, forKey: "keywordsearch")
        
        savedSearch.setObject(min!, forKey: "minrent")
        savedSearch.setObject(max!, forKey: "maxrent")
           savedSearch.setObject(zip!, forKey: "zipcode")
       
        
        let userId = NSUserDefaults.standardUserDefaults().valueForKey("userid");
        let query = PFQuery(className: "AppUser")
        
        query.whereKey("userid", equalTo: userId!);
        query.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
            let pfObjects : NSArray = objects!;
            if pfObjects.count > 0 && error == nil {
                
                let currentAppUser = pfObjects[0] as! PFObject;
                
                if let  savedSearches = currentAppUser.valueForKey("savedsearches") {
                    let savedSearchesArray : NSMutableArray = savedSearches.mutableCopy() as! NSMutableArray
                    savedSearchesArray.addObject(savedSearch)
                    currentAppUser.setObject(savedSearchesArray.copy() as! NSArray, forKey: "savedsearches")
                }
                else {
                    let savedSearchArray = NSArray(objects: savedSearch)
                    currentAppUser.setObject(savedSearchArray, forKey: "savedsearches")
                }
                currentAppUser.saveInBackgroundWithBlock({ (success, error) in
                    if (success){
                        self.showAlert("Successful", message: "Search Options Saved.")
                    } else {
                        NSLog("error in  saving searches")
                    }
                })
            } else {
                NSLog("Error Retrieving user for favorite");
            }
        }
    }
}
