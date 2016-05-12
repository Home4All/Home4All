//
//  T_AfterSignInVC.swift
//  Home4All
//
//  Created by Anuj Patel on 4/18/16.
//  Copyright © 2016 Home4All. All rights reserved.
//

import UIKit
import CoreLocation
import Foundation

class T_SearchVC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, CLLocationManagerDelegate, UITableViewDataSource, UITableViewDelegate, TenantSearchFilterOptionsViewControllerDelegate{
 
    
    @IBOutlet weak var keyword: UITextField!
//    @IBOutlet weak var city : UITextField!
//    @IBOutlet weak var zipCode: UITextField!
//    
//    @IBOutlet weak var minPrice: UITextField!
//    @IBOutlet weak var maxPrice: UITextField!
//
        
    var cityValue:String? = ""
    var zipCodeValue:Int? = 0
    
    // following parameters are  coming from filter search
    
    var location1:String?="a"
    var area_max:String?="a"
    var area_min:String?=""
    var price_max:Int?
    var price_min:Int?
    
    var zipcode1:Int?=0
    //var savedSearchParameters:PlacePost?
//      var savedSearchParameters : SavedSearch = SavedSearch()
    
    
    
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
  
        
        
     //   print ("Saved search parametersrsrsrsrsrsr,\(savedSearchParameters)")
        
        print (location1)
        print (area_max)
        print(zipcode1)
        print(price_max)
        print(price_min)
        print(area_min)
        
        
        
        
        
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
//        self.locationManager.stopUpdatingLocation()
        
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
//        
//        if(location1==nil && zipcode1==0)
//        {
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
                
            self.searchResults = objects!;
            self.tableView.reloadData()
                
            }
            
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }

    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell=self.tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! CustomCell
        
        if  searchResults.count == 0 {
            return cell
        }
        
            let placePost : PlacePost = self.searchResults[indexPath.row] as! PlacePost;
            let cityText:String! = placePost.objectForKey("city") as? String
            let streetText:String! = placePost.objectForKey("street") as? String
            let priceText:Int! = placePost.objectForKey("rent") as? Int
        
  let countText:Int! = placePost.objectForKey("counter") as? Int
        
        if let images = placePost.valueForKey("images") {
            if images.count != 0 {
            let imageFiles = images as! NSArray
            let firstImageFile = imageFiles[0]
            firstImageFile.getDataInBackgroundWithBlock({ (data, error) in
                if let data = data {
                    if let image = UIImage(data: data) {
                        cell.photo.image=image
                        placePost.imageProperty = image
                    }
                }
            })
            }
        }
        
        if countText != nil{
            print("Count is \(countText)")
            cell.viewCount.text="\(countText) Views"
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
                cell.price.text="$ \(priceText) /mo"
        }
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier("pushDetailViewController", sender: indexPath)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "pushDetailViewController"){
            let indexPath = sender as! NSIndexPath
            let row = indexPath.row as Int;
            let postingObject : PlacePost = self.searchResults[row] as! PlacePost;
            let destinationViewController : TenantPostDetailViewController = segue.destinationViewController as! TenantPostDetailViewController
            destinationViewController.placePost = postingObject;
        }
        if(segue.identifier == "SearchOptionSegue"){
            let destinationViewController : TenantSearchFilterOptionsViewController = segue.destinationViewController as! TenantSearchFilterOptionsViewController
            destinationViewController.tenantDelegate = self;
            destinationViewController.cityValue = self.cityValue
            destinationViewController.zipValue = self.zipCodeValue
        }
    }
    
    func didFinishSearch(searchOption : SavedSearch) {
        print(searchOption);
        
        let keyword = searchOption.valueForKey("keyword") as? String
        var city = searchOption.valueForKey("city") as? String
        var zipCode = searchOption.valueForKey("zip") as? NSNumber
        var minrent = searchOption.valueForKey("minrent") as? NSNumber
        var maxrent = searchOption.valueForKey("maxrent") as? NSNumber
        let propertType = searchOption.valueForKey("propertytype") as? String

        
        if (minrent == nil) {
            minrent = NSNumber(int : 0)
        }
        
        if (maxrent == nil) {
            maxrent = NSIntegerMax
        }
        
        
        let query = PlacePost.query()! as PFQuery
        if (city == nil || (city?.isEmpty)!) {
            city = self.cityValue
        } else {
            query.whereKey("citysearch", containsString: city?.lowercaseString)
        }
        
        if (zipCode == nil) {
            zipCode = self.zipCodeValue
        }
        else {
            query.whereKey("zip", equalTo: zipCode!)
        }
        
        if (keyword == nil || (keyword?.isEmpty)!) {
        } else {
            query.whereKey("descriptionsearch", containsString: keyword?.lowercaseString)
        }
        
        query.whereKey("rent", lessThan: maxrent!)
        query.whereKey("rent", greaterThan: minrent!)
        
        if (propertType == nil || (propertType?.isEmpty)!) {
            query.whereKey("housetype", containedIn: apartmentType )
        } else {
            query.whereKey("housetype", containsString: propertType)
        }
        
        query.findObjectsInBackgroundWithBlock {
            (objects, error) -> Void in
            
            if error != nil{
                print(error)
            }else{
                if objects?.count == 0 {
                    self.showAlert("No Data", message: "No results found")
                }
                self.searchResults = objects!;
                self.tableView.reloadData()
            }
        }
    }
    
    func showAlert(title : NSString, message : NSString) {
        let alertController = UIAlertController(title: title as String, message:message as String, preferredStyle: .Alert)
        
        let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alertController.addAction(defaultAction)
        self.presentViewController(alertController, animated: true, completion: nil)
    }
}

