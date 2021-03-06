//
//  PlacePost.swift
//  Home4All
//
//  Created by Ashish Mishra on 4/23/16.
//  Copyright © 2016 Home4All. All rights reserved.
//

import UIKit

struct PlacePostKey {
    static let placePostStreetKey = "area";
    static let placePostCityKey = "city";
    static let placePostStateKey = "state";
    static let placePostZipKey = "zip";
}

class PlacePost: PFObject, PFSubclassing {
    
    @NSManaged var image: PFFile
    
    @NSManaged var propertyImages : NSArray
   
    @NSManaged var propertytype: NSString
    @NSManaged var postedby: NSString
    @NSManaged var cityName: NSString
    @NSManaged var streetName: NSString
    @NSManaged var zipcode: NSNumber
    @NSManaged var state: NSString
    @NSManaged var noOfRooms: NSNumber
    @NSManaged var noOfBaths: NSNumber
    @NSManaged var area: NSNumber
    @NSManaged var rent: NSNumber
    @NSManaged var contactInfo: NSNumber
    
    var imageProperty : UIImage = UIImage()
    //1
    
    
    var totalSteps: Int = 0 {
        willSet(newTotalSteps) {
            
        }
    }
    
    class func parseClassName() -> String {
        return "PlacePost"
    }
    
    //2
    override class func initialize() {
        var onceToken: dispatch_once_t = 0
        dispatch_once(&onceToken) {
            self.registerSubclass()
        }
    }
    
    override class func query() -> PFQuery? {
        let query = PFQuery(className: PlacePost.parseClassName()) //1
        query.orderByDescending("createdAt") //3
        return query
    }
    
    init(image: PFFile) {
        super.init()
        self.image = image
    }
    
    override func isEqual(object: AnyObject?) -> Bool {
        if (object as? PFObject)?.objectId == self.objectId {
            return true
        } else {
            return super.isEqual(object)
        }
    }
    
    override init() {
        super.init()
    }

}
