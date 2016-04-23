//
//  PlacePost.swift
//  Home4All
//
//  Created by Ashish Mishra on 4/23/16.
//  Copyright © 2016 Home4All. All rights reserved.
//

import UIKit

class PlacePost: PFObject, PFSubclassing {
    
    @NSManaged var image: PFFile
    @NSManaged var zipcode: NSString
    @NSManaged var state: NSString
    @NSManaged var propertytype: NSString
    @NSManaged var postedby: NSString
    //1
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
    
    override init() {
        super.init()
    }

}
