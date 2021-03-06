//
//  AppDelegate.swift
//  Home4All
//
//  Created by Anuj Patel on 4/17/16.
//  Copyright © 2016 Home4All. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate {


    var window: UIWindow? 

    func application(application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Initialize sign-in
        Parse.setApplicationId("WS8orT6p2gRNib1BC8fQcJZNjX65QI9Uq4JqctN8", clientKey: "kU9gk9dNguikS51dMtsxtEtOMC0YeZf1ZzJlmv3B")
        var configureError: NSError?
        GGLContext.sharedInstance().configureWithError(&configureError)
        assert(configureError == nil, "Error configuring Google services: \(configureError)")
        
        GIDSignIn.sharedInstance().delegate = self
        
        SavedSearch.registerSubclass()
        PlacePost.registerSubclass()
        
        return true
    }
    
    
    func application(application: UIApplication,
                     openURL url: NSURL, options: [String: AnyObject]) -> Bool {
        return GIDSignIn.sharedInstance().handleURL(url,
                                                    sourceApplication: options[UIApplicationOpenURLOptionsSourceApplicationKey] as? String,
                                                    annotation: options[UIApplicationOpenURLOptionsAnnotationKey])
    }
    
    func signIn(signIn: GIDSignIn!, didSignInForUser user: GIDGoogleUser!,
                withError error: NSError!) {
        if (error == nil) {
            /* Perform any operations on signed in user here.
            let userId = user.userID                  // For client-side use only!
            let idToken = user.authentication.idToken // Safe to send to the server
            
            */
            let email = user.profile.email
            let userid = user.userID
            let givenName = user.profile.givenName
            let familyName = user.profile.familyName
            let fullname = givenName + familyName
            
            let query = PFQuery(className: "AppUser")
            query.whereKey("userid", equalTo: userid)
            query.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
                if let pfObjects : NSArray = objects {
                if pfObjects.count > 0 && error == nil {
                    NSLog("Successfully retrieved: \(objects)")
                } else {
                    self.registerUser(fullname,email: email, userid:userid );
                }
            }
            }
            
            NSUserDefaults.standardUserDefaults().setValue(userid, forKey: "userid");
            NSUserDefaults.standardUserDefaults().setValue(fullname, forKey: "username");
            NSUserDefaults.standardUserDefaults().setValue(email, forKey: "emailid");

            
            let userType : String = NSUserDefaults.standardUserDefaults().valueForKey("usertype") as! String
            
            if userType == UserType.UserTypeLandlord.rawValue {
            
            let myStoryBoard:UIStoryboard = UIStoryboard(name:"Main", bundle:nil)
            
            let afterSignInTabbarController : UITabBarController=myStoryBoard.instantiateViewControllerWithIdentifier("aftersignintabbar") as! UITabBarController
            afterSignInTabbarController.selectedIndex = 0;
            
            self.window?.rootViewController = afterSignInTabbarController
            }
            else {
                
                print("Going towards the T_AfterSignInVC")
                let storyboard:UIStoryboard = UIStoryboard(name:"Main", bundle: nil)
                let vc: UITabBarController = storyboard.instantiateViewControllerWithIdentifier("TTabBarController") as! UITabBarController
                self.window?.rootViewController = vc

            }

        } else {
            print("\(error.localizedDescription)")
        }
    }
    
    func registerUser(userName : NSString, email : NSString, userid: NSString) {
        let user = PFObject(className: "AppUser")
        user.setObject(userid, forKey: "userid")
        user.setObject(email, forKey: "emailid")
        user.setObject(userName, forKey: "username")
        user.saveInBackgroundWithBlock { (succeeded, error) -> Void in
            if succeeded {
                NSLog("Object Uploaded")
            } else {
                NSLog("Error: \(error) \(error!.userInfo)")
            }
        }
    }
    
    func signIn(signIn: GIDSignIn!, didDisconnectWithUser user:GIDGoogleUser!,
                withError error: NSError!) {
        // Perform any operations when the user disconnects from app here.
        // ...
    }
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

