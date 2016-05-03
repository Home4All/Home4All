//
//  T_AfterSignInVC.swift
//  Home4All
//
//  Created by Anuj Patel on 4/18/16.
//  Copyright © 2016 Home4All. All rights reserved.
//

import UIKit
import CoreLocation

class T_SearchVC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, CLLocationManagerDelegate{
 
    @IBOutlet weak var keyword: UITextField!
    @IBOutlet weak var city : UITextField!
    @IBOutlet weak var zipCode: UITextField!
    
    @IBOutlet weak var minPrice: UITextField!
    @IBOutlet weak var maxPrice: UITextField!
    
    
    
    let locationManager = CLLocationManager()
    var chosenApartmentType : String = String()
    var apartmentTypeValue = "Any"
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    
//        GIDSignIn.sharedInstance().uiDelegate = self
        
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
        
        
        
        
    
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        
        CLGeocoder().reverseGeocodeLocation(manager.location!, completionHandler: {(placemarks, error)->Void in
            
            if (error != nil)
            {
                print("Error: " + error!.localizedDescription)
                return
            }
            
            if placemarks!.count > 0
            {
                let pm = placemarks![0] as! CLPlacemark
                self.displayLocationInfo(pm)
            }
            else
            {
                print("Error with the data.")
            }
        })
    }
    
    func displayLocationInfo(placemark: CLPlacemark)
    {
        
        self.locationManager.stopUpdatingLocation()
        print(placemark.locality)
        print(placemark.postalCode)
        print(placemark.administrativeArea)
        print(placemark.country)
        
        city.text = placemark.locality
        zipCode.text = placemark.postalCode
        
    }
    
    
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError)
    {
        print("Error: " + error.localizedDescription)
    }
    
    
    
    
    
    
    @IBAction func signOutButtonPressed(sender: AnyObject) {
        
        GIDSignIn.sharedInstance().signOut()
        
        let signInPage =
            
            self.storyboard?.instantiateInitialViewController() as! ViewController
        
        let signInPageNav = UINavigationController(rootViewController:signInPage)
        
        let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        appDelegate.window?.rootViewController = signInPageNav
        
        print("Sign Out Pressed")
        
    }
    
    
    
    
    
    @IBOutlet weak var apartmentTypePickerView: UIPickerView!
    
    
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
        
        self.chosenApartmentType = apartmentType[row]
        NSLog(self.chosenApartmentType);
        apartmentTypeValue = apartmentType[row]
        
    }
    
    
    @IBAction func searchProperty(sender: AnyObject) {
    
// Setting up Keywords & City for search
        
        let keywordValue:String = (keyword.text?.lowercaseString)!
        let cityValue:String = (city.text?.lowercaseString)!
        
        
// Setting up Price Range Values for search
        
        let minTemp:Int? = Int(minPrice.text!)
        let maxTemp:Int? = Int(maxPrice.text!)
        var minValue = -1
        var maxValue = 10000000000
        
        
        if minTemp != nil {
            minValue = (minTemp! - 1)
        }
        if maxTemp != nil {
            maxValue = (maxTemp! + 1)
        }
        
        
// Setting ZipCode Values for search
        
        let zipCodeValue:Int? = Int(zipCode.text!)
        var zipCodeMinValue:Int
        var zipCodeMaxValue:Int
        
        
        if zipCodeValue ==  nil{
             zipCodeMinValue = -1
             zipCodeMaxValue = 1000000
        } else {
            zipCodeMinValue = (zipCodeValue!-1)
            zipCodeMaxValue = (zipCodeValue!+1)
        }
        
// Setting up Apartment Type for search
        
        if apartmentTypeValue == "Any"{
            apartmentTypeValue = ""
        }
        
        
        print("Keyword: \(keywordValue)")
        print("City: \(cityValue)")
        print("ZipCode: \(zipCodeMinValue+1)-\(zipCodeMaxValue-1)")
        print("Price Range: \(minValue+1)-\(maxValue-1)")
        print("Property Type: \(apartmentTypeValue)")
        
        
        
        
        
        let query = PFQuery(className: "PlacePost")
        // 2
        query.whereKey("title", containsString : keywordValue)
        //query.whereKey("description", containsString : keywordValue)
        query.whereKey("city", containsString: cityValue)
        query.whereKey("zipcode", greaterThan: zipCodeMinValue)
        query.whereKey("zipcode", lessThan: zipCodeMaxValue)
        query.whereKey("price", greaterThan: minValue)
        query.whereKey("price", lessThan: maxValue)
        query.whereKey("housetype", containsString: apartmentTypeValue)
//        
        // 3
        query.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
            if error == nil {
                print("Successfully retrieved: \(objects)")
            } else {
                print("Error: ")
            }
        }
        
        
    }
    
    
}

