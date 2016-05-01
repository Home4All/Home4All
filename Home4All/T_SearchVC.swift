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

    let locationManager = CLLocationManager()
    var chosenApartmentType : String = String()
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
    
    
    var apartmentType = ["Apartment","House","Condo"]
    
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
    
    }
    
    
}

