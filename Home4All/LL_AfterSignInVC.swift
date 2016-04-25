//
//  LL_AfterSignInVC.swift
//  Home4All
//
//  Created by Anuj Patel on 4/24/16.
//  Copyright © 2016 Home4All. All rights reserved.
//

import UIKit

class LL_AfterSignInVC: UIViewController {

    
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
    
}