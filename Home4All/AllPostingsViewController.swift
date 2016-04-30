//
//  AllPostingsViewController.swift
//  Home4All
//
//  Created by Ashish Mishra on 4/20/16.
//  Copyright © 2016 Home4All. All rights reserved.
//

import UIKit

class AllPostingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var allpostingsTableView: UITableView!
    var allPostings : NSArray = NSArray();

    override func viewDidLoad() {
        super.viewDidLoad()
        retrieveAllPostings();

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
        retrieveAllPostings();

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func retrieveAllPostings() {
        
        let username : NSString = NSUserDefaults.standardUserDefaults().objectForKey("username") as! NSString;
        
        let query = PlacePost.query()! as PFQuery
        query.whereKey("postedby", equalTo: username)
        query.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
            let pfObjects : NSArray = objects!;
            if pfObjects.count > 0 && error == nil {
                NSLog("Successfully retrieved: \(objects)")
            self.allPostings = objects!;
            self.allpostingsTableView.reloadData()
            } else {
                NSLog("Call failed");
            }
        }
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.allPostings.count;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let allpostingTableCell = tableView.dequeueReusableCellWithIdentifier("AllPostingTableCell", forIndexPath: indexPath) as! AllPostingsTableViewCell
        
        let row = indexPath.row as Int;
        let postingObject : PlacePost = self.allPostings[row] as! PlacePost;
        let stateText = postingObject.objectForKey("state") as? String
        let zipCode = postingObject.objectForKey("zip") as? String
        if stateText != nil && zipCode != nil {
            allpostingTableCell.state.text = stateText! + zipCode!;
        }
        let houseType = postingObject.objectForKey("housetype") as? String;
        if houseType != nil {
              allpostingTableCell.propertyType.text = houseType;
        }
      
        postingObject.image.getDataInBackgroundWithBlock { (data, error) in
            if let data = data {
                if let image = UIImage(data: data) {
                    allpostingTableCell.propertyImageView.image = image;
                        }
            }
            }
        return allpostingTableCell;
        }
}
