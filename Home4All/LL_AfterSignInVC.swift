//
//  LL_AfterSignInVC.swift
//  Home4All
//
//  Created by Anuj Patel on 4/24/16.
//  Copyright © 2016 Home4All. All rights reserved.
//

import UIKit

class LL_AfterSignInVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    @IBOutlet weak var profileTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //        GIDSignIn.sharedInstance().uiDelegate = self
        
//        if GIDSignIn.sharedInstance().currentUser.profile.hasImage {
//            var imageUrl = GIDSignIn.sharedInstance().currentUser.profile.imageURLWithDimension(60)
//        }
        
//        if([GIDSignIn sharedInstance].currentUser.profile.hasImage) {
//            
//            NSUInteger imgSize = usrImgV.frame.size.height * 2;
//            NSURL *imgUrl = [[GIDSignIn sharedInstance].currentUser.profile imageURLWithDimension:imgSize];
//            [usrImgV setImageWithURL:imgUrl placeholderImage:placeholderImg];
//            
//        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
        
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return 3
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var   cell = tableView.dequeueReusableCellWithIdentifier("ProfileCell", forIndexPath: indexPath)

//        if indexPath.section == 0 {
//            
//            
//            
//            if GIDSignIn.sharedInstance().currentUser.profile.hasImage {
//                var imageUrl = GIDSignIn.sharedInstance().currentUser.profile.imageURLWithDimension(60)
//            }
//
//        } else 
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                cell.textLabel?.text = "Name"
                cell.detailTextLabel?.text = NSUserDefaults.standardUserDefaults().valueForKey("username") as? String
            }else if indexPath.row == 1 {
                cell.textLabel?.text = "Email"
                 cell.detailTextLabel?.text = NSUserDefaults.standardUserDefaults().valueForKey("emailid") as? String
            } else if indexPath.row == 2 {
                cell.textLabel?.text = "Signout"
                cell.detailTextLabel?.text = ""
            }

        }
        return cell;
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 0 && indexPath.row == 2{
            self.signOutButtonPressed()
        }
    }

//    @IBAction func signOutButtonPressed(sender: AnyObject) {
     func signOutButtonPressed() {

        GIDSignIn.sharedInstance().signOut()
        
        let signInPage =
            
            self.storyboard?.instantiateInitialViewController() as! ViewController
        
        let signInPageNav = UINavigationController(rootViewController:signInPage)
        
        let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        appDelegate.window?.rootViewController = signInPageNav
        
        print("Sign Out Pressed")
        
    }
    
}
