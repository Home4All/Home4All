//
//  ImageUploadViewController.swift
//  Home4All
//
//  Created by Ashish Mishra on 4/23/16.
//  Copyright © 2016 Home4All. All rights reserved.
//

import UIKit

class ImageUploadViewController: UIViewController {

    @IBOutlet weak var imageToUpload: UIImageView!
    @IBOutlet weak var commentTextField: UITextField!
    @IBOutlet weak var loadingSpinner: UIActivityIndicatorView!
    
    var username: String?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    // MARK: - Actions
    @IBAction func selectPicturePressed(sender: AnyObject) {
        //Open a UIImagePickerController to select the picture
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func sendPressed(sender: AnyObject) {

    }
    
    func saveWallPost(file: PFFile)
    {
}
}

extension ImageUploadViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        //Place the image in the imageview
        imageToUpload.image = image
//        picker.dismissViewControllerAnimated(true, completion: nil)
    }
}
