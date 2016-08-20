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
            //SM: Post a remove action to the webserver, removing all devices on this account from notifications when a user logs out.
            let pAppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            if(pAppDelegate.m_strAPNSToken != nil)
            {
                let particleToken = SparkCloud.sharedInstance().accessToken
                let params:NSDictionary = ["action" : "remove", "platform" : "apns", "subscriber" : pAppDelegate.m_strAPNSToken, "authtoken" : particleToken!]
                
                self.Post(params, url: "https://www.garadget.com/my/json/pn-signup.php")
            }
            
            //SM: Logout from Spark(particle) after posting remove device call to webserver
            SparkCloud.sharedInstance().logout()
            
            // Access the DoorVC class and remove all door data
            let frontNavigationController = self.revealViewController().frontViewController as? UINavigationController
            if(frontNavigationController != nil)
            {
                if(frontNavigationController!.topViewController!.isKindOfClass(DoorsVC) )
                {
                    let doorVC = frontNavigationController!.topViewController! as! DoorsVC
                    doorVC.removeDoorData()
                }
            }
            
            // Configure the login / register UI to display
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
    
    func Post(params : NSDictionary, url : String)
    {
        //print(params)
        
        let request = NSMutableURLRequest(URL: NSURL(string: url)!)
        let session = NSURLSession.sharedSession()
        request.HTTPMethod = "POST"
        
        let pAppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        let strAction = String(params.valueForKey("action")!)
        let strParticleID = String(params.valueForKey("authtoken")!)
        
        let bodyData = "action=" + strAction + "&platform=apns&subscriber=" + String(pAppDelegate.m_strAPNSToken) + "&authtoken=" + strParticleID
        
        request.HTTPBody = bodyData.dataUsingEncoding(NSUTF8StringEncoding);
        
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        //request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
            // handle error
            guard error == nil else { return }
            
            //print("Response: \(response)")
            let strData = NSString(data: data!, encoding: NSUTF8StringEncoding)
            //print("Body: \(strData)")
            
            let json: NSDictionary?
            do {
                json = try NSJSONSerialization.JSONObjectWithData(data!, options: .MutableLeaves) as? NSDictionary
            } catch let dataError {
                // Did the JSONObjectWithData constructor return an error? If so, log the error to the console
                print(dataError)
                let jsonStr = NSString(data: data!, encoding: NSUTF8StringEncoding)
                print("Error could not parse JSON: '\(jsonStr)'")
                // return or throw?
                return
            }
            
            
            // The JSONObjectWithData constructor didn't return an error. But, we should still
            // check and make sure that json has a value using optional binding.
            if let parseJSON = json {
                // Okay, the parsedJSON is here, let's get the value for 'success' out of it
                let success = parseJSON["success"] as? Int
                //print("Succes: \(success)")
            }
            else {
                // Something went worng. Maybe the server isn't running?
                let jsonStr = NSString(data: data!, encoding: NSUTF8StringEncoding)
                print("Error could not parse JSON: \(jsonStr)")
            }
            
        })
        
        task.resume()
    }
}
