//
//  T_AfterSignInVC.swift
//  Home4All
//
//  Created by Anuj Patel on 4/18/16.
//  Copyright © 2016 Home4All. All rights reserved.
//

import UIKit
import CoreLocation

class T_SearchVC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, CLLocationManagerDelegate, UITableViewDataSource, UITableViewDelegate{
 
    
    @IBOutlet weak var keyword: UITextField!
//    @IBOutlet weak var city : UITextField!
//    @IBOutlet weak var zipCode: UITextField!
//    
//    @IBOutlet weak var minPrice: UITextField!
//    @IBOutlet weak var maxPrice: UITextField!
//
    
    
    
    var cityValue:String? = ""
    var zipCodeValue:Int? = 0
    
    
    @IBOutlet weak var tableView: UITableView!
    
    
    
    var cityArray:[String] = [String]()
    var streetArray:[String] = [String]()
    var priceArray :NSMutableArray? = NSMutableArray()
    var imageArray:[UIImage] = [UIImage]()
    
    var searchResults : NSArray = NSArray()
    
    
    
    let locationManager = CLLocationManager()
    var chosenApartmentType : String = String()
    var apartmentTypeValue = "Any"
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    
        
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
        self.locationManager.stopUpdatingLocation()
        
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
                self.locationManager.stopUpdatingLocation()
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
        
        cityValue = placemark.locality
        zipCodeValue = Int(placemark.postalCode!)
       defaultSearch()
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

     func defaultSearch() {
        
        print("City: \(cityValue!)")
        print("ZipCode: \(zipCodeValue!)")
        
        let query = PlacePost.query()! as PFQuery
        
        // 2
        query.whereKey("city", containsString: cityValue!)
        query.whereKey("zip", equalTo: zipCodeValue!)
        
        //
        
        query.findObjectsInBackgroundWithBlock {
            (objects, error) -> Void in
            
            
            if error != nil{
                print(error)
                
                
            }else{
                
                
                
                print(objects)
                self.cityArray = [String]()
                self.streetArray = [String]()
//                self.priceArray = [Int]()
                self.imageArray = [UIImage]()
                
                for object in objects!{
                    var placePost : PlacePost = object as! PlacePost;
                    let cityText:String! = placePost.objectForKey("city") as? String
                    let streetText:String! = placePost.objectForKey("street") as? String
                    let priceText:Int! = placePost.objectForKey("price") as? Int
           //         let x: PFFile=placePost.objectForKey("image") as! PFFile
                    //                let imageText:UIImage! = (object as! PlacePost)["image"] as! UIImage
                    
                    
                    (object as! PlacePost).image.getDataInBackgroundWithBlock { (data, error) in
                        if let data = data {
                            if let image = UIImage(data: data) {
                                //                            allpostingTableCell.propertyImageView.image = image;
                                print("City is \(image)")
                                //postingObject.imageProperty = image
                                
                            }
                        }
                    }
                    
                    
                    
                    
                    if cityText != nil{
                        print("City is \(cityText)")
                        self.cityArray.append(cityText!)
                    }
                    
                    if streetText != nil{
                        print("Street is \(streetText)")
                        self.streetArray.append(streetText!)
                    }
                    
                    if priceText != nil{
                        print("Price is \(priceText)")
                        self.priceArray?.addObject(priceText!)
                    }
                    //                
                    //                if x != nil{
                    //                    print("Image is \(x)")
                    //                 //   self.imageArray.append(x!)
                    //                }
                    
                    
                }
            self.tableView.reloadData()
                
            }
            
        }
        
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }

    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell=self.tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! CustomCell
        
        
            let placePost : PlacePost = self.searchResults[indexPath.row] as! PlacePost;
            let cityText:String! = placePost.objectForKey("city") as? String
            let streetText:String! = placePost.objectForKey("street") as? String
            let priceText:Int! = placePost.objectForKey("rent") as? Int

    
                                placePost.image.getDataInBackgroundWithBlock { (data, error) in
                                    
                                    if((error) != nil){
                                        NSLog((error?.description)!);
                                    }
                                    if let data = data {
                                        if let image = UIImage(data: data) {
                                            //                            allpostingTableCell.propertyImageView.image = image;
                                            print("image  check is is \(image)")
                                            //postingObject.imageProperty = image
                                            cell.photo.image=image
                                        }
                                    }
                                }
        
            if cityText != nil{
                print("City is \(cityText)")
                cell.city.text=cityText
            }
        
        
            if streetText != nil{
                cell.street.text=streetText
            }
        
            if priceText != nil{
                print("Price is \(priceText)")
                cell.price.text="\(priceText)"
        }
        
        return cell
    }
    

}

