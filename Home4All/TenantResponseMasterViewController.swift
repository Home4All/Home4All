//
//  TenantResponseMasterViewController.swift
//  Home4All
//
//  Created by Pawan Kumar on 5/5/16.
//  Copyright © 2016 Home4All. All rights reserved.
//

import UIKit

class TenantResponseMasterViewController: UITableView, UITableViewDataSource, UITableViewDelegate {
    
    
    

    
    
    //var street:[String] = [String]()
    //var city:[String] = [String]()
    //var price:[Int] = [Int]()
    
    var street = ["Street1","Street2","Street3"]
    var city = ["City1","City2","City3"]
    var price = [100,200,300]
    

    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return street.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
     
        
        
        
        let cell=self.tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! CustomCell
        
 //       cell.photo.image=images[indexPath.row]
        
        cell.street.text=street[indexPath.row]
        cell.city.text=city[indexPath.row]
        cell.price.text = String(price[indexPath.row])
        
        return cell
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
