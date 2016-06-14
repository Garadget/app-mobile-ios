//
//  SidePanelTVC.swift
//  garadget
//
//  Created by Stephen Madsen on 5/1/16.
//  Copyright © 2016 Stephen Madsen. All rights reserved.
//


class SidePanelTVC: UITableViewController, SparkSetupMainControllerDelegate
{
    //#pragma mark - Table view data source
    
    var menu = ["Account Name", "Logout"]
    
    var account_name_cell : UITableViewCell?
    
    override func viewDidAppear(animated: Bool)
    {
        super.viewDidAppear(animated)
        
        if(account_name_cell != nil)
        {
            account_name_cell!.textLabel!.text = SparkCloud.sharedInstance().loggedInUsername
            account_name_cell!.textLabel!.textColor = UIColor.whiteColor()
        }
        
        self.tableView.backgroundColor = UIColor(red:0.0, green:0.5, blue:0.0, alpha:1)
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 1
    }
    
    override func tableView(tableView: UITableView,
        numberOfRowsInSection section: Int) -> Int
    {
        return menu.count
    }
    
    override func tableView(tableView: UITableView,
        cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cellIdentifier = menu[indexPath.row]
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath)
        
        if(indexPath.row == 0)
        {
            account_name_cell = cell
            cell.textLabel!.text = SparkCloud.sharedInstance().loggedInUsername
            cell.textLabel!.textColor = UIColor.grayColor()
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView,
        didSelectRowAtIndexPath indexPath: NSIndexPath) -> Void
    {
        if( menu[indexPath.row] == "Logout" )
        {
            //self.revealViewController().revealToggle(nil)
            
            SparkCloud.sharedInstance().logout()
            
            let frontNavigationController = self.revealViewController().frontViewController as? UINavigationController
            if(frontNavigationController != nil)
            {
                if(frontNavigationController!.topViewController!.isKindOfClass(DoorsVC) )
                {
                    let doorVC = frontNavigationController!.topViewController! as! DoorsVC
                    doorVC.removeDoorData()
                }
            }
            
            if let vc = SparkSetupMainController(authenticationOnly: true)
            {
                SparkSetupCustomization.sharedInstance().deviceName = "Garadget"
                SparkSetupCustomization.sharedInstance().productImage = UIImage(named:"GARADGET-27.png")
                SparkSetupCustomization.sharedInstance().brandImage = UIImage(named:"header_icon_black.png")
                SparkSetupCustomization.sharedInstance().brandName = "Garadget"
                SparkSetupCustomization.sharedInstance().productName = "Garadget"
                SparkSetupCustomization.sharedInstance().organization = true
                SparkSetupCustomization.sharedInstance().organizationName = "Softcomplex Inc"
                SparkSetupCustomization.sharedInstance().organizationSlug = "softcomplex-inc"
                SparkSetupCustomization.sharedInstance().productSlug = "garadget-v13"
                
                SparkSetupCustomization.sharedInstance().brandImageBackgroundColor = UIColor.whiteColor()
                SparkSetupCustomization.sharedInstance().pageBackgroundColor = UIColor.whiteColor()
                
                SparkSetupCustomization.sharedInstance().linkTextColor = UIColor.blackColor()
                
                // check organization setup mode
                let c = SparkSetupCustomization.sharedInstance()
                c.allowSkipAuthentication = false
                
                vc.delegate = self
                vc.modalPresentationStyle = .FormSheet  // use that for iPad
                self.presentViewController(vc, animated: true, completion: nil)
            }
        }
    }
    
    func sparkSetupViewController(controller: SparkSetupMainController!, didFinishWithResult result: SparkSetupMainControllerResult, device: SparkDevice!)
    {
        //print("sparkSetupViewController")
        
        switch result
        {
        case .Success:
            print("Setup completed successfully")
            
        case .Failure:
            print("Setup failed")
        case .UserCancel :
            print("User cancelled setup")
        case .LoggedIn :
            print("User is logged in")
        default:
            print("Uknown setup error")
            
        }
    }
}
