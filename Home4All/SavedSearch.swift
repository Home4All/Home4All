//
//  SavedSearch.swift
//  Home4All
//
//  Created by Ashish Mishra on 5/8/16.
//  Copyright © 2016 Home4All. All rights reserved.
//

import UIKit

class SavedSearch: PFObject, PFSubclassing {
    
    
//    @NSManaged var propertytype: NSString
//    @NSManaged var cityName: NSString
//    @NSManaged var zipcode: NSNumber
//    @NSManaged var minRent: NSNumber
//    @NSManaged var maxRent: NSNumber
//    

    class func parseClassName() -> String {
        return "SavedSearch"
    }
    
    //2
    override class func initialize() {
        var onceToken: dispatch_once_t = 0
        dispatch_once(&onceToken) {
            self.registerSubclass()
        }
    }
    
    override class func query() -> PFQuery? {
        let query = PFQuery(className: SavedSearch.parseClassName()) //1
        query.orderByDescending("createdAt") //3
        return query
    }
    
//    init(image: PFFile) {
//        super.init()
//        self.image = image
//    }
    
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
