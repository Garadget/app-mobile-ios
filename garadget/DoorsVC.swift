//
//  DoorsVC.swift
//  garadget
//
//  Created by Stephen Madsen on 2/24/16.
//  Copyright © 2016 SynapticSwitch,LLC. All rights reserved.
//

import UIKit

class DoorsVC: UIViewController, SparkSetupMainControllerDelegate
{
    @IBOutlet weak var loginButtonOutlet: UIButton!
    
    @IBOutlet weak var currentDoor: UIButton!
    
    weak var currentDoorSelected : UIButton!
    
    @IBOutlet weak var barButton : UIBarButtonItem!
    
    var doorDeviceList : [DoorModel?] = []
    
    var currentDoorModel: DoorModel?
    
    @IBOutlet weak var m_activity_indicator: UIActivityIndicatorView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        //SM: Setup the hamburger (Door Icon) button on the header to reveal our side panel
        if self.revealViewController() != nil {
            barButton.target = self.revealViewController()
            barButton.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: "pullDownRefresh")
        swipeDown.direction = UISwipeGestureRecognizerDirection.Down
        self.view.addGestureRecognizer(swipeDown)
        
        loginButtonOutlet.backgroundColor = UIColor.clearColor()
        loginButtonOutlet.layer.cornerRadius = 5
        loginButtonOutlet.layer.borderWidth = 1
        loginButtonOutlet.layer.borderColor = UIColor.whiteColor().CGColor                
        
        //SM: The the app delegate's DoorVC ref
        let pAppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        pAppDelegate.SetDoorVC(self)
    }
    
    override func viewDidAppear(animated: Bool)
    {
        self.navigationController?.toolbarHidden = true
        
        if SparkCloud.sharedInstance().isLoggedIn
        {
            if( doorDeviceList.count == 0 )
            {
                self.removeDoorData()
                self.loadDoorsData()
            }
        }
        else
        {
            self.particleLogin()
            //self.manualLogin()
        }
        
        // Activity Indicator
        self.m_activity_indicator.hidesWhenStopped = true
    }
    
    func pullDownRefresh()
    {
        self.m_activity_indicator.startAnimating()
        self.m_activity_indicator.hidden = false
    
        self.removeDoorData()
        self.loadDoorsData()
    }
    
    @IBAction func unwindToMainMenu(sender: UIStoryboardSegue)
    {
        let sourceViewController = sender.sourceViewController
        // Pull any data from the view controller which initiated the unwind segue.
    }
    
    func manualLogin()
    {
        let c = SparkSetupCustomization.sharedInstance()
        c.brandImage = UIImage(named: "logo")
        c.brandName = "Garadget"
        c.brandImageBackgroundColor = UIColor(red: 0.88, green: 0.96, blue: 0.96, alpha: 0.9)
        
        // check organization setup mode
        c.allowSkipAuthentication = false
        
        c.organization = true
        c.organizationName = "Softcomplex Inc"
        c.organizationSlug = "softcomplex-inc"
        c.productSlug = "garadget-v13"
        SparkCloud.sharedInstance().loginWithUser("user_email", password: "password") { (error:NSError?) -> Void in
            
            if let e=error
            {
                print("Login Error " + e.description)
            }
            else
            {
                //print("Logged in")
                
                self.removeDoorData()
                self.loadDoorsData()
            }
        }
    }
    
    func particleLogin()
    {
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
    
    func createDoorButtonChildren(p_pButton : UIButton, p_pDoorModel : DoorModel)
    {
        // Name Label
        let label = UILabel()
        label.font = label.font.fontWithSize(30)
        label.frame = CGRectMake(-50, 200, 300, 75)
        label.textAlignment = NSTextAlignment.Center
        label.text = p_pDoorModel.m_strName
        
        p_pButton.addSubview(label)
        p_pDoorModel.m_pDoorNameUILabel = label
        
        // Signal Image
        //Create the signal image
        var imageName : String
        
        if p_pDoorModel.m_bConnected == true
        {
            imageName = "signal-06.png"
        }
        else
        {
            imageName = "signal-01.png"
        }
        
        let image = UIImage(named: imageName)
        let imageView = UIImageView(image: image!)
        imageView.frame = CGRect(x: -2.5, y: 0, width: 225, height: 200)
        p_pButton.addSubview(imageView)
        p_pDoorModel.m_pDoorSignalUIImage = imageView
        
        let constX:NSLayoutConstraint = NSLayoutConstraint(item: imageView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: imageView, attribute: NSLayoutAttribute.Width, multiplier: 1.66, constant: 0);
        imageView.addConstraint(constX);
        
        // Status Label
        let status = UILabel()
        status.font = status.font.fontWithSize(20)
        status.frame = CGRectMake(-50, 240, 300, 50)
        status.textAlignment = NSTextAlignment.Center
        status.text = "offline"
        status.textColor = UIColor.grayColor()
        
        p_pButton.addSubview(status)
        p_pDoorModel.m_pDoorStatusUILabel = status
    }
    
    func loadDoorsData()
    {
        SparkCloud.sharedInstance().getDevices { (sparkDevices:[AnyObject]?, error:NSError?) -> Void in
            
            if let e = error
            {
                if e.code == 401
                {
                    print("invalid access token - logging out")
                    
                    SparkCloud.sharedInstance().logout()
                    self.particleLogin()
                }
                else
                {
                    let errorAlertView = UIAlertView(title: "Error", message:e.localizedDescription, delegate:self, cancelButtonTitle: "ok")
                    errorAlertView.show()
                }
            }
            else
            {                
                if let devices = sparkDevices as? [SparkDevice]
                {
                    let screenSize: CGRect = UIScreen.mainScreen().bounds
                    let screenWidth = screenSize.width
                    let screenHeight = screenSize.height
                    
                    var index = 0
                    var xPos = CGFloat()
                    let padding = CGFloat(75.0)
                    let startingX = CGFloat( (screenWidth * 0.95) - (padding*CGFloat(devices.count-1)))
                    
                    for device in devices
                    {
                        // SM: Create UI Button for door
                        if index < devices.count - 1
                        {
                            xPos = startingX + (padding * CGFloat(index))
                            
                            //Create the UIButton
                            let button   = UIButton()
                            button.adjustsImageWhenHighlighted = false
                            button.frame = CGRectMake(xPos, screenHeight * 0.6, 50, 50)
                            button.setImage( UIImage(named: "door-01.png"), forState: UIControlState.Normal)
                            button.setTitle(device.name, forState: UIControlState.Normal)
                            button.addTarget(self, action: "doorSelectedAction:", forControlEvents: UIControlEvents.TouchUpInside)
                            self.view.addSubview(button)
                            
                            var constX:NSLayoutConstraint = NSLayoutConstraint(item: button, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: button, attribute: NSLayoutAttribute.Width, multiplier: 1.66, constant: 0);
                            button.addConstraint(constX);
                            
                            //Create the door name label
                            let label = UILabel()
                            label.font = label.font.fontWithSize(10)
                            label.frame = CGRectMake(0, 40, 50, 50)
                            label.textAlignment = NSTextAlignment.Center
                            button.addSubview(label)
                            
                            //Create the signal image
                            var imageName = "signal-06.png"
                            
                            if device.connected
                            {
                                imageName = "signal-06.png"
                            }
                            else
                            {
                                imageName = "signal-01.png"
                            }
                            
                            let image = UIImage(named: imageName)
                            let imageView = UIImageView(image: image!)
                            imageView.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
                            button.addSubview(imageView)
                            
                            constX = NSLayoutConstraint(item: imageView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: imageView, attribute: NSLayoutAttribute.Width, multiplier: 1.66, constant: 0);
                            button.addConstraint(constX);
                            
                            imageView.addConstraint(constX);
                            
                            // Status Label
                            let status = UILabel()
                            status.font = status.font.fontWithSize(8)
                            status.frame = CGRectMake(0, 50, 50, 50)
                            status.textAlignment = NSTextAlignment.Center
                            status.text = "offline"
                            status.textColor = UIColor.grayColor()
                            button.addSubview(status)
                            
                            //Create the DoorModel object
                            let pDoor = self.createDoorFromServer(device, p_pUIButton: button)
                            pDoor!.m_pDoorNameUILabel = label
                            pDoor!.m_pDoorStatusUILabel = status
                            pDoor!.m_pDoorSignalUIImage = imageView
                            
                            //SM: Set the device name label after creating the DoorModel object
                            label.text = pDoor!.m_strName
                            
                            pDoor!.createProgressBar(button)
                        }
                        else
                        {
                            self.currentDoor.hidden = true;
                            
                            let pNewButton = UIButton()
                            pNewButton.adjustsImageWhenHighlighted = false
                            self.currentDoorSelected = pNewButton
                            self.currentDoorSelected.frame = self.currentDoor.frame //CGRectMake(85, 60, 200, 200)
                            self.currentDoorSelected.setImage( UIImage(named: "door-01.png"), forState: UIControlState.Normal)
                            self.currentDoorSelected.setTitle(device.name, forState: UIControlState.Normal)
                            self.currentDoorSelected.addTarget(self, action: "doorSelectedAction:", forControlEvents: UIControlEvents.TouchUpInside)
                            self.view.addSubview(self.currentDoorSelected)
                            
                            let constX:NSLayoutConstraint = NSLayoutConstraint(item: pNewButton, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: pNewButton, attribute: NSLayoutAttribute.Width, multiplier: 1.66, constant: 0);
                            pNewButton.addConstraint(constX);
                            
                            let pDoorModel = self.createDoorFromServer(device, p_pUIButton: self.currentDoorSelected)
                            self.createDoorButtonChildren(self.currentDoorSelected, p_pDoorModel: pDoorModel!)
                            self.currentDoorModel = pDoorModel;
                            self.currentDoorSelected.hidden = false
                            
                            self.currentDoorModel!.createProgressBar(self.currentDoorSelected)
                        }
                        
                        index++
                    }
                    
                    self.view.bringSubviewToFront(self.m_activity_indicator)
                    self.m_activity_indicator.stopAnimating()
                    
                    // OMEG self.postAllDoorsLoaded()
                }
                else
                {
                    self.m_activity_indicator.stopAnimating()
                    
                    self.currentDoor.hidden = true
                    
                    let errorAlertView = UIAlertView(title: "No Doors", message:"You have no doors connected to this account", delegate:self, cancelButtonTitle: "ok")
                    errorAlertView.show()
                }
            }}
    }
    
    func createDoorFromServer(device: SparkDevice, p_pUIButton : UIButton ) -> DoorModel?
    {
        let pDoorModel = DoorModel()
        
        pDoorModel.m_pDevice = device
        pDoorModel.m_pDoorUIButton = p_pUIButton
        pDoorModel.m_strID = device.id
        pDoorModel.m_strName = device.name
        pDoorModel.m_strName = pDoorModel.m_strName!.stringByReplacingOccurrencesOfString("_", withString: " ", options: NSStringCompareOptions.LiteralSearch, range: nil)
        pDoorModel.m_bConnected = device.connected
        pDoorModel.m_pLastContact = device.lastHeard
        pDoorModel.m_strFirmwareVersion = device.version
        
        pDoorModel.loadAndSyncDoorData(self)
        
        if( device.connected == true)
        {
            pDoorModel.SetupEventHandlerForState()
            // OMEGA pDoorModel.SetupEventHandlerForTime()
        }
        
        self.doorDeviceList.append(pDoorModel)
        
        return pDoorModel
    }
    
    func sparkSetupNewDevice()
    {
        if let vc = SparkSetupMainController(setupOnly: true)
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
            vc.modalPresentationStyle = .FormSheet
            self.presentViewController(vc, animated: true, completion: nil)
        }
    }
    
    func sparkSetupViewController(controller: SparkSetupMainController!, didFinishWithResult result: SparkSetupMainControllerResult, device: SparkDevice!)
    {
        //print("sparkSetupViewController")
        
        switch result
        {
        case .Success:
            //print("Setup completed successfully")
            
            self.removeDoorData()
            self.loadDoorsData()
        
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
    
    func postAllDoorsLoaded()
    {
        let pAppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        if(pAppDelegate.m_strAPNSToken != nil)
        {
            for device in doorDeviceList
            {
                device?.PostDoorDataToWebserver(pAppDelegate.m_strAPNSToken!)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func doorAnimComplete()
    {
    
    }
    
    func getLabelsInView(view: UIView) -> [UILabel] {
        var results = [UILabel]()
        for subview in view.subviews as [UIView] {
            if let labelView = subview as? UILabel {
                results += [labelView]
            } else {
                results += getLabelsInView(subview)
            }
        }
        return results
    }
    
    func updateSelectedDoor(doorButton : UIButton)
    {
        for device in self.doorDeviceList
        {
            if device!.m_pDoorUIButton == doorButton
            {
                //SM: Swap the frames
                let myFrame = device!.m_pDoorUIButton!.frame
                let progressBGFrame = device!.m_pProgressBGShape!.frame
                let progressBarFrame = device!.m_pProgressBarShape!.frame
                let progressLabelFrame = device!.m_pProgressBarLabel!.frame
                
                device!.m_pDoorUIButton!.frame = (currentDoorModel?.m_pDoorUIButton!.frame)!
                
                currentDoorModel?.m_pDoorUIButton!.frame = myFrame

                currentDoorModel?.m_pDoorNameUILabel!.font = currentDoorModel?.m_pDoorNameUILabel!.font.fontWithSize(10)
                currentDoorModel?.m_pDoorNameUILabel!.sizeToFit()
                currentDoorModel?.m_pDoorNameUILabel!.frame = CGRectMake(5, 50, 40, 25)
                currentDoorModel?.m_pDoorSignalUIImage!.frame = CGRectMake(0, 0, 50, 50)
                currentDoorModel?.m_pDoorStatusUILabel!.font = currentDoorModel?.m_pDoorNameUILabel!.font.fontWithSize(8)
                currentDoorModel?.m_pDoorStatusUILabel!.sizeToFit()
                currentDoorModel?.m_pDoorStatusUILabel!.frame = CGRectMake(5, 60, 40, 25)
                
                currentDoorModel?.m_pProgressBarShape!.frame = device!.m_pProgressBarShape!.frame
                currentDoorModel?.m_pProgressBarShape!.lineWidth = 3
                currentDoorModel?.m_pProgressBGShape!.frame = device!.m_pProgressBGShape!.frame
                currentDoorModel?.m_pProgressBGShape!.lineWidth = 5
                currentDoorModel?.m_pProgressBarLabel!.font = currentDoorModel?.m_pProgressBarLabel!.font.fontWithSize(10)
                currentDoorModel?.m_pProgressBarLabel!.sizeToFit()
                currentDoorModel?.m_pProgressBarLabel!.frame = CGRectMake(5, 5, 40, 40)//device!.m_pProgressBarLabel!.frame
                currentDoorModel?.m_dProgressBarRadius = 10
                currentDoorModel?.m_dProgressX = 25
                currentDoorModel?.m_dProgressY = 25
                
                device?.m_pDoorNameUILabel!.font = currentDoorModel?.m_pDoorNameUILabel!.font.fontWithSize(30)
                device?.m_pDoorNameUILabel!.sizeToFit()
                device?.m_pDoorNameUILabel!.frame = CGRectMake(-50, 200, 300, 75)
                device?.m_pDoorSignalUIImage!.frame = CGRectMake(-2.5, 0, 225, 200)
                device?.m_pDoorStatusUILabel!.font = currentDoorModel?.m_pDoorNameUILabel!.font.fontWithSize(25)
                device?.m_pDoorStatusUILabel!.sizeToFit()
                device?.m_pDoorStatusUILabel!.frame = CGRectMake(-50, 240, 300, 50)
                
                device?.m_pProgressBarShape!.frame = progressBarFrame
                device?.m_pProgressBarShape!.lineWidth = 10
                device?.m_pProgressBGShape!.frame = progressBGFrame
                device?.m_pProgressBGShape!.lineWidth = 12
                device?.m_pProgressBarLabel!.font = currentDoorModel?.m_pProgressBarLabel!.font.fontWithSize(25)
                device?.m_pProgressBarLabel!.sizeToFit()
                device?.m_pProgressBarLabel!.frame = CGRectMake(40, 50, 100, 100)
                device?.m_dProgressBarRadius = 35
                device?.m_dProgressX = 90
                device?.m_dProgressY = 100
                
                //SM: Set the current door to the selected door
                self.currentDoorSelected = doorButton
                self.currentDoorModel = device
                
                break
            }
        }
    }
    
    func CurrentDoorSelected()
    {
        if( currentDoorModel!.m_bConnected == true )
        {
            if (self.currentDoorModel?.m_strStatus == "closed")
            {
                currentDoorModel!.callOpenDoorFunction()
                self.playDoorOpeningAnimation()
            }
            else if (self.currentDoorModel?.m_strStatus == "open")
            {
                currentDoorModel!.callCloseDoorFunction()
                self.playDoorClosingAnimation()
            }
        }
    }
    
    func removeDoorData()
    {
        for door in doorDeviceList
        {
            for view in door!.m_pDoorUIButton!.subviews {
                view.removeFromSuperview()
            }
            door!.m_pDoorUIButton!.removeFromSuperview()
            
            for view in door!.m_pDoorNameUILabel!.subviews {
                view.removeFromSuperview()
            }
            door!.m_pDoorNameUILabel!.removeFromSuperview()
            
            for view in door!.m_pDoorSignalUIImage!.subviews {
                view.removeFromSuperview()
            }
            door!.m_pDoorSignalUIImage!.removeFromSuperview()
            
            for view in door!.m_pDoorStatusUILabel!.subviews {
                view.removeFromSuperview()
            }
            door!.m_pDoorStatusUILabel!.removeFromSuperview()
        }
        self.doorDeviceList.removeAll()
        
        self.currentDoorSelected = nil
        self.currentDoorModel = nil
    }
    
    @IBAction func doorSelectedAction(sender: AnyObject)
    {
        let button = sender as! UIButton
        
        if( button == self.currentDoorSelected )
        {
            self.CurrentDoorSelected()
        }
        else
        {
            updateSelectedDoor(button)
        }
    }
    
    @IBAction func openSettingsAction(sender: AnyObject)
    {
        if( self.currentDoorModel == nil )
        {
            let errorAlertView = UIAlertView(title: "Alert", message:"You have no doors. Add a door from the panel below.", delegate:self, cancelButtonTitle: "ok")
            errorAlertView.show()
        }
        else
        {
            if( self.currentDoorModel!.m_bConnected == true )
            {
                performSegueWithIdentifier("show_online_settings", sender: nil)
            }
            else
            {
                performSegueWithIdentifier("show_offline_settings", sender: nil)
            }
        }
    }
    
    @IBAction func openAlertsAction(sender: AnyObject)
    {
        if( self.currentDoorModel == nil )
        {
            let errorAlertView = UIAlertView(title: "Alert", message:"You have no doors. Add a door from the panel below.", delegate:self, cancelButtonTitle: "ok")
            errorAlertView.show()
        }
        else
        {
            if( self.currentDoorModel!.m_bConnected == true )
            {
                performSegueWithIdentifier("show_notifications", sender: nil)
            }
            else
            {
                let errorAlertView = UIAlertView(title: "Alert", message:(self.currentDoorModel!.m_strName! + " is offline"), delegate:self, cancelButtonTitle: "ok")
                errorAlertView.show()
            }
        }
    }
    
    @IBAction func addDoorAction(sender: AnyObject)
    {
        self.sparkSetupNewDevice()
    }    

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if(segue.identifier != nil)
        {
            //print(segue.identifier!)
            
            if( segue.identifier! == "show_offline_settings" || segue.identifier! == "show_online_settings" )
            {
                let vc = segue.destinationViewController as! SettingsTVC
                
                vc.m_pDoorModel = currentDoorModel
            }
            else if( segue.identifier! == "show_notifications" )
            {
                let vc = segue.destinationViewController as! NotificationsTVC
                
                vc.m_pDoorModel = self.currentDoorModel
            }
        }
    }
    
    func deviceNameSyncCallback(name: String)
    {
        //self.currentDoorLabelOutlet.text = name
    }
    
    func deviceSyncCallback(sender: DoorModel)
    {
    
    }
    
    func playDoorOpeningAnimation()
    {
        // Load images
        let imageNames = [
            "door-01.png", "door-02.png", "door-03.png", "door-04.png",
            "door-05.png", "door-06.png", "door-07.png", "door-08.png",
            "door-09.png", "door-10.png", "door-11.png", "door-12.png",
            "door-13.png", "door-14.png", "door-15.png"]
        
        var images: [UIImage] = []
        
        var pImage = UIImage();
        
        for var i = 0; i < imageNames.count; i++
        {
            pImage = UIImage(	named: imageNames[i])!
            images.append(pImage)
        }
        
        currentDoorSelected.setImage(pImage, forState: .Normal)
        currentDoorSelected.imageView?.animationImages = images
        currentDoorSelected.imageView?.animationDuration = currentDoorModel!.m_dTimerMotion!;
        currentDoorSelected.imageView?.animationRepeatCount = 1;
        currentDoorSelected.imageView?.startAnimating()
        
        self.performSelector(#selector(DoorsVC.doorAnimComplete), withObject:nil, afterDelay:currentDoorModel!.m_dTimerMotion!)
        
        currentDoorModel!.startProgressBar()
    }
    
    func playDoorClosingAnimation()
    {
        // Load images
        let imageNames = [
            "door-15.png", "door-14.png", "door-13.png", "door-12.png",
            "door-11.png", "door-10.png", "door-09.png", "door-08.png",
            "door-07.png", "door-06.png", "door-05.png", "door-04.png",
            "door-03.png", "door-02.png", "door-01.png"]
        
        var images: [UIImage] = []
        
        var pImage = UIImage();
        
        for i in 0 ..< imageNames.count
        {
            pImage = UIImage(	named: imageNames[i])!
            images.append(pImage)
        }
        
        currentDoorSelected.setImage(pImage, forState: .Normal)
        currentDoorSelected.imageView?.animationImages = images
        currentDoorSelected.imageView?.animationDuration = currentDoorModel!.m_dTimerMotion!;
        currentDoorSelected.imageView?.animationRepeatCount = 1;
        currentDoorSelected.imageView?.startAnimating()
        
        self.performSelector(#selector(DoorsVC.doorAnimComplete), withObject:nil, afterDelay:currentDoorModel!.m_dTimerMotion!)

        currentDoorModel!.startProgressBar()
    }
}
