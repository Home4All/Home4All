//
//  T_AfterSignInVC.swift
//  Home4All
//
//  Created by Anuj Patel on 4/18/16.
//  Copyright © 2016 Home4All. All rights reserved.
//

import UIKit

class T_SearchVC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource{

    var chosenApartmentType : String = String()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    
//        GIDSignIn.sharedInstance().uiDelegate = self
    
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    
    
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

