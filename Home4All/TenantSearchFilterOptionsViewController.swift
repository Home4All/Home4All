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
    
    var savedSearch : SavedSearch = SavedSearch()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func searchFilter(sender: AnyObject) {
        self.currentTextField.resignFirstResponder()
        self.navigationController?.popViewControllerAnimated(true)
        self.tenantDelegate?.didFinishSearch(self.savedSearch)
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        self.currentTextField = textField;
        if textField.tag == 600 {
            self.typePickerView.hidden = false
        } else {
            self.typePickerView.hidden = true
        }
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
            self.savedSearch.setObject(numberFromString, forKey: "zipcode");
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
        savedSearch.setObject("House", forKey: "propertytype")
        savedSearch.setObject("San Francisco", forKey: "city")
        savedSearch.setObject(NSNumber(int:1000), forKey: "minrent")
        savedSearch.setObject(NSNumber(int:10000), forKey: "maxrent")
                
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
                       NSLog("Successfully saved searches")
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
