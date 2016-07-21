//
//  AppDelegate.swift
//  garadget
//
//  Created by Stephen Madsen on 2/23/16.
//  Copyright © 2016 SynapticSwitch,LLC. All rights reserved.
//

import UIKit
import CoreLocation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, CLLocationManagerDelegate {

    var window: UIWindow?
    
    //.. Background Tasks
    var backgroundUpdateTask: UIBackgroundTaskIdentifier = 0
    var m_pNotificationTimer : NSTimer?
    
    var m_pDoorVC: DoorsVC?
    
    let locationManager: CLLocationManager = CLLocationManager()
    let authorizationStatus = CLLocationManager.authorizationStatus()
    var m_pCurrentLocation: CLLocation = CLLocation()
    
    var m_strAPNSToken: String!
    
    var m_bIsUpdatingLocation : Bool! = false
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool
    {
        //print(SparkCloud.sharedInstance().OAuthClientId!)
        //print(SparkCloud.sharedInstance().OAuthClientSecret!)
        
        SparkCloud.sharedInstance().OAuthClientId = GaradgetKeys().oAuthClientId()
        SparkCloud.sharedInstance().OAuthClientSecret = GaradgetKeys().oAuthSecret()
        
        self.registerForPushNotifications(application)
        
        /* Add this so we can see logging to calls to AWS
        options:
        AWSLogLevelNone
        AWSLogLevelError (default. Only error logs are printed to the console.)
        AWSLogLevelWarn
        AWSLogLevelInfo
        AWSLogLevelDebug
        AWSLogLevelVerbose
        */
        AWSLogger.defaultLogger().logLevel = AWSLogLevel.Verbose;
        
        UIApplication.sharedApplication().applicationIconBadgeNumber = 0
        
        return true
    }
    
    func SetDoorVC(p_pDoorsVC : DoorsVC)
    {
        self.m_pDoorVC = p_pDoorsVC
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication)
    {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        
        /* Reduce the accuracy to ease the strain on iOS while we are in the background */
        //__locationManager!.desiredAccuracy = kCLLocationAccuracyHundredMeters
        
        //self.__insideApp = false
        
        if self.m_pDoorVC != nil && self.m_pDoorVC?.doorDeviceList.count > 0
        {
            //self.StartBackgroundTask()
            
            var bDoorRequiresLocatoinMonitoring = false
            for door in (m_pDoorVC?.doorDeviceList)!
            {
                if( door?.m_bNotifyOnDepartureEnabled != nil && door?.m_bNotifyOnDepartureEnabled == true )
                {
                    bDoorRequiresLocatoinMonitoring = true
                    
                    let __distance = ((door?.m_pDoorLocation!.distanceFromLocation(self.m_pCurrentLocation))!)
                    
                    //print("LOCATION ALERT DISTANCE: " + String(__distance))
                
                    if  __distance > door?.m_dDepartureRadius!
                    {
                        door?.m_bInsideRadius = false
                        
                        let defaults = NSUserDefaults.standardUserDefaults()
                        defaults.setValue(false, forKey: (door?.m_strName!)! + "_inside_radius")
                    }
                    else
                    {
                        door?.m_bInsideRadius = true
                        
                        let defaults = NSUserDefaults.standardUserDefaults()
                        defaults.setValue(true, forKey: (door?.m_strName!)! + "_inside_radius")
                    }
                    
                    break;
                }
            }
            
            if( bDoorRequiresLocatoinMonitoring == true )
            {
                //print("Starting location significant change monitoring")
                //locationManager.stopUpdatingLocation()
                locationManager.startMonitoringSignificantLocationChanges()
            }
        }
    }

    func applicationWillEnterForeground(application: UIApplication)
    {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication)
    {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        
        locationManager.stopMonitoringSignificantLocationChanges()
        
        //SM: Update the door status each time the app enters the foreground
        if( m_pDoorVC != nil )
        {
            for door in (m_pDoorVC?.doorDeviceList)!
            {
                door?.getDoorStatus()
            }
        }
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    func registerForPushNotifications(application: UIApplication)
    {
        let notificationSettings = UIUserNotificationSettings(
            forTypes: [.Badge, .Sound, .Alert], categories: nil)
        application.registerUserNotificationSettings(notificationSettings)
    }
    
    func application(application: UIApplication, didRegisterUserNotificationSettings notificationSettings: UIUserNotificationSettings)
    {
        //print("didRegisterNotificationSettings")
        
        if notificationSettings.types != .None {
            application.registerForRemoteNotifications()
        }
    }
    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData)
    {
        let tokenChars = UnsafePointer<CChar>(deviceToken.bytes)
        var tokenString = ""
        
        for i in 0..<deviceToken.length {
            tokenString += String(format: "%02.2hhx", arguments: [tokenChars[i]])
        }
        
        //print("Device Token:", tokenString)
        
        // Initialize the Amazon Cognito credentials provider
//        let credentialsProvider = AWSCognitoCredentialsProvider(regionType:.USEast1,
//            identityPoolId:"us-east-1:711f2deb-7212-47e4-8493-fa36fd22412d")
//        let configuration = AWSServiceConfiguration(region:.USEast1, credentialsProvider:credentialsProvider)
//        AWSServiceManager.defaultServiceManager().defaultServiceConfiguration = configuration
//        
//        /* Register the device with Amazon SNS Mobile Push based on the token received */
//        let myArn = "arn:aws:sns:us-east-1:932795040918:app/APNS_SANDBOX/Garadget"
//        
//        let platformEndpointRequest = AWSSNSCreatePlatformEndpointInput()
//        platformEndpointRequest.customUserData = "MyUserID;iPhone"
//        platformEndpointRequest.token = tokenString
//        platformEndpointRequest.platformApplicationArn = myArn;
//        
//        let snsManager = AWSSNS.defaultSNS()
//        snsManager.createPlatformEndpoint(platformEndpointRequest)
        /* End Amazon SNS Mobile Push self registration */
        
        self.m_strAPNSToken = tokenString        
    }
    
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError)
    {
        print("Failed to register:", error)
    }
    
    func PushLocalNotification(p_strMessage: String)
    {
        let localNotification:UILocalNotification = UILocalNotification()
        
        localNotification.alertAction = "Garadget Alert"
        
        localNotification.alertBody = p_strMessage
        
        localNotification.timeZone = NSTimeZone.localTimeZone()
        
        localNotification.fireDate = NSDate(timeIntervalSinceNow: 0.2)
        
        //        localNotification.repeatInterval = NSCalendarUnit.Second
        
        localNotification.applicationIconBadgeNumber = UIApplication.sharedApplication().applicationIconBadgeNumber + 1
        
        localNotification.soundName = UILocalNotificationDefaultSoundName
        
        UIApplication.sharedApplication().scheduleLocalNotification(localNotification)
    }
    
    func BeginBackgroundUpdateTask() {
        self.backgroundUpdateTask = UIApplication.sharedApplication().beginBackgroundTaskWithExpirationHandler({
            self.EndBackgroundUpdateTask()
        })
    }
    
    func EndBackgroundUpdateTask() {
        
        UIApplication.sharedApplication().endBackgroundTask(self.backgroundUpdateTask)
        self.backgroundUpdateTask = UIBackgroundTaskInvalid
    }
    
    func StartBackgroundTask() {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),
            {
            self.BeginBackgroundUpdateTask()
                
            self.CheckForLocationNotifications()

            self.m_pNotificationTimer = NSTimer.scheduledTimerWithTimeInterval(30, target: self, selector: "CheckForLocationNotifications", userInfo: nil, repeats: true)
            NSRunLoop.currentRunLoop().addTimer(self.m_pNotificationTimer!, forMode: NSDefaultRunLoopMode)
            NSRunLoop.currentRunLoop().run()
            
            // End the background task.
            self.EndBackgroundUpdateTask()
        })
    }
    
    func CheckForLocationNotifications()
    {
        if( self.m_pDoorVC != nil )
        {
            for var i = 0; i < self.m_pDoorVC!.doorDeviceList.count; i += 1
            {
                let pCurrentDoor  = (m_pDoorVC!.doorDeviceList[i]!) as? DoorModel
                
                pCurrentDoor?.getDoorStatus()
                pCurrentDoor?.CheckForUserLocationNotification()
            }
        }
    }
    
    func AuthorizeLocationTracking()
    {
        if(m_bIsUpdatingLocation == false)
        {
            //CoreLocation Data - Authorize location tracking
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.pausesLocationUpdatesAutomatically = true
            
            if(authorizationStatus == .AuthorizedAlways)
            {
                locationManager.startUpdatingLocation()
                m_bIsUpdatingLocation = true
            }
            else
            {
                //locationManager.requestWhenInUseAuthorization()
                locationManager.requestAlwaysAuthorization()
            }
        }
    }
    
    func locationManager(manager: CLLocationManager,
                           didChangeAuthorizationStatus status: CLAuthorizationStatus)
    {
        if(status == .AuthorizedWhenInUse || status == .AuthorizedAlways)
        {
            locationManager.startUpdatingLocation()
            m_bIsUpdatingLocation = true
        }
    }
    
    func locationManager(pManager: CLLocationManager,
        didUpdateLocations locations: [CLLocation])
    {
        //SM: This list always contains at least a single location
        m_pCurrentLocation = locations[0]
        
        //print("New Location Recieved : " + String(m_pCurrentLocation))
        if(UIApplication.sharedApplication().applicationState == .Background)
        {
            self.CheckForLocationNotifications()
        }
    }
}

