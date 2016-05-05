//
//  ViewController.swift
//  Home4All
//
//  Created by Anuj Patel on 4/17/16.
//  Copyright © 2016 Home4All. All rights reserved.
//

enum UserType: String {
    case UserTypeLandlord = "LandLord"
    case UserTypeTenant = "Tenant"
}

import UIKit

class ViewController: UIViewController,GIDSignInUIDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func landLordLoginClicked() {
        NSUserDefaults.standardUserDefaults().setValue(UserType.UserTypeLandlord.rawValue, forKey: "usertype")
        
        let LL_LoginViewControllerObj = self.storyboard?.instantiateViewControllerWithIdentifier("LLSignInViewController") as? LLSignInViewController
        
        self.presentViewController(LL_LoginViewControllerObj!, animated: true, completion: nil)
    }
    
    @IBAction func TenantLoginClicked() {
        NSUserDefaults.standardUserDefaults().setValue(UserType.UserTypeTenant.rawValue, forKey: "usertype")
        
       let T_LoginViewControllerObj = self.storyboard?.instantiateViewControllerWithIdentifier("TSignInViewController") as? TSignInViewController
        
       self.presentViewController(T_LoginViewControllerObj!, animated: true, completion: nil)
    }
}

