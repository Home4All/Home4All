//
//  LandLordPostViewController.swift
//  Home4All
//
//  Created by Ashish Mishra on 4/20/16.
//  Copyright © 2016 Home4All. All rights reserved.
//

import UIKit

class LandLordPostViewController: UIViewController {

    @IBOutlet weak var propertyType: UITextField!
    @IBOutlet weak var zipCodeField: UITextField!
    @IBOutlet weak var stateField: UITextField!
    var imageToUpload: UIImageView = UIImageView();

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem?.action = #selector(LandLordPostViewController.postProperty);

        // Do any additional setup after loading the view.
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
     @IBAction func postProperty(sender: AnyObject) {
        
        let zipCode : NSString = self.zipCodeField.text!;
        let stateField : NSString = self.stateField.text!
        let propertyType : NSString = self.propertyType.text!
        
        let username = NSUserDefaults.standardUserDefaults().objectForKey("username") as! NSString;

        let pictureData = UIImagePNGRepresentation(self.imageToUpload.image!)
        let file = PFFile(name: "image", data: pictureData!)
        
        let placePost = PlacePost(image: file!);
        placePost.setObject(zipCode, forKey: "zipcode")
        placePost.setObject(stateField, forKey: "state")
        placePost.setObject(propertyType, forKey: "propertytype")
        placePost.setObject(username, forKey: "postedby")
        
        placePost.saveInBackgroundWithBlock { (succeeded, error) -> Void in
            if succeeded {
                NSLog("Object Uploaded")
            } else {
                NSLog("Error: \(error) \(error!.userInfo)")
            }
        }
    }
    
    @IBAction func selectPicturePressed(sender: AnyObject) {
        //Open a UIImagePickerController to select the picture
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        presentViewController(imagePicker, animated: true, completion: nil)
    }
}

extension LandLordPostViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        //Place the image in the imageview
        self.imageToUpload.image = image
        picker.dismissViewControllerAnimated(true, completion: nil)
}
}
