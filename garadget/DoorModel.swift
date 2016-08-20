//
//  DoorModel.swift
//  garadget
//
//  Created by Stephen Madsen on 3/10/16.
//  Copyright © 2016 SynapticSwitch,LLC. All rights reserved.
//

import Foundation
import CoreLocation

class DoorModel : NSObject
{
    // Particle Data
    var m_pDevice : SparkDevice?
    
    /////////////////////////////////////
    // UI Data
    /////////////////////////////////////
    var m_pDoorsVC : DoorsVC?
    
    var m_pDoorUIButton : UIButton!
    var m_pDoorNameUILabel : UILabel?
    var m_pDoorStatusUILabel : UILabel?
    var m_pDoorSignalUIImage : UIImageView?
    
    var m_pProgressBarCircle : UIBezierPath?
    var m_pProgressBGShape : CAShapeLayer?
    var m_pProgressBarShape : CAShapeLayer?
    var m_pProgressBarLabel : UILabel?
    var m_pProgressTimer : NSTimer?
    var m_dProgressMod : Double? = 0.0
    var m_dProgressX : Double? = 90.0
    var m_dProgressY : Double? = 100.0
    var m_dProgressBarRadius : Double? = 35
    
    /////////////////////////////////////
    // Device Data
    /////////////////////////////////////
    var m_strLoggedInUsername : String? = ""
    var m_strID : String? = ""
    var m_strName : String? = ""
    var m_bConnected : Bool? = false
    var m_pLastContact : NSDate?
    var m_strStatus : String? = ""
    var m_strStatusTime : String? = ""
    var m_bVisibility : Bool? = true
    var m_strFirmwareVersion : String? = ""
    var m_strConnectionTimeOut : String? = ""
    var m_strWarmUpTime : String? = ""
    var m_strWifiSsid : String? = ""
    var m_strWifiSignal : String? = ""
    var m_strWifiIp : String? = ""
    var m_strWifiGateway : String? = ""
    var m_strWifiNetmask : String? = ""
    var m_strWifiMac : String? = ""
    var m_strSensorRate : String? = ""
    var m_strSensorScanPeriod : String? = ""
    var m_strSensorReads : String? = ""
    var m_strSensorThreshhold : String? = ""
    var m_strTimerMotion : String? = ""
    var m_dTimerMotion : Double? = 0.0
    var m_strTimerStartDelay : String? = ""
    var m_strTimerRelayOn : String? = ""
    var m_strTimerRelayOff : String? = ""
    var m_strTimerWifiReconnect : String? = ""
    
    /////////////////////////////////////
    // Event Notifications
    /////////////////////////////////////
    var strAlertsBitmap : UInt8?
    var m_bNotifyOnRebootEnabled : Bool? = false
    var m_bNotifyWhenOnlineEnabled : Bool? = false
    var m_bNotifyOnOpenEnabled : Bool? = false
    var m_bNotifyOnCloseEnabled : Bool? = false
    var m_bNotifyOnStoppedEnabled : Bool? = false
    var m_bNotifyOnDisconnectEnabled : Bool? = false
    
    /////////////////////////////////////
    // Timeout Notification
    /////////////////////////////////////
    var m_fTimeoutValue : Double? = 0.0 // 0 = Inactive
    
    /////////////////////////////////////
    //Location Notifications
    /////////////////////////////////////
    var m_bNotifyOnDepartureEnabled : Bool? = false
    var m_pDoorLocation : CLLocation?
    var m_dDepartureRadius : Double? = 0.0
    var m_bInsideRadius : Bool?
    var m_bIsRenaming : Bool? = false
    var m_bIsSetDeviceConfig : Bool? = false
    var m_iSetDeviceConfigCounter : Int = 0
    var m_iSetDeviceConfigCompleteCounter : Int = 0

    /////////////////////////////////////
    // Night Notifications
    /////////////////////////////////////
    var m_iNightAlertStartValue : Int = 0
    var m_iNightAlertEndValue : Int = 0
    var m_pNightAlertStartTime : NSDate!
    var m_pNightAlertEndTime : NSDate!
    var m_pNightAlertTimeZone : NSTimeZone!
    
    /////////////////////////////////////
    //MISC Variables
    /////////////////////////////////////
    var m_dDelayTime : Double = 10.0
    var doorOpenTimer : NSTimer?
    
    
    
    func callOpenDoorFunction ()
    {
        let funcArgs = ["open"]
        let task = m_pDevice!.callFunction("setState", withArguments: funcArgs) { (resultCode : NSNumber?, error : NSError?) -> Void in
            if (error == nil)
            {
                //print("Open door message sent")
                
                self.m_strStatus = "opening"
                self.m_pDoorStatusUILabel!.text = "opening" + " 0s"
            }
        }
        
        let bytesToReceive : Int64 = task.countOfBytesExpectedToReceive
        //print(bytesToReceive)
    }

    
    func callCloseDoorFunction ()
    {
        let funcArgs = ["closed"]
        let task = m_pDevice!.callFunction("setState", withArguments: funcArgs) { (resultCode : NSNumber?, error : NSError?) -> Void in
            if (error == nil)
            {
                //print("Closed door message sent")
                
                self.m_strStatus = "closing"
                self.m_pDoorStatusUILabel!.text = "closing" + " 0s"
            }
        }
        
        let bytesToReceive : Int64 = task.countOfBytesExpectedToReceive
        //print(bytesToReceive)
    }
    
    
    func ToggleRebootAlerts(p_bEnabled : Bool)
    {
        if( p_bEnabled )
        {
            self.m_bNotifyOnDisconnectEnabled = true
            
            if (self.strAlertsBitmap! & 32 != 32)
            {
                self.strAlertsBitmap! += 32
            }
        }
        else
        {
            self.m_bNotifyOnDisconnectEnabled = false
            
            if (self.strAlertsBitmap! & 32 == 32)
            {
                self.strAlertsBitmap! -= 32
            }
        }
        
        let __params = "aev=" + String(self.strAlertsBitmap!)
        
        //print("__params == ",__params)
        self.setDeviceConfig(__params)
    }
    
    
    func ToggleOnlineAlerts(p_bEnabled : Bool)
    {
        if( p_bEnabled )
        {
            self.m_bNotifyOnRebootEnabled = true
            
            if (self.strAlertsBitmap! & 64 != 64)
            {
                self.strAlertsBitmap! += 64
            }
        }
        else
        {
            self.m_bNotifyOnRebootEnabled = false
            
            if (self.strAlertsBitmap! & 64 == 64)
            {
                self.strAlertsBitmap! -= 64
            }
        }
        
        let __params = "aev=" + String(self.strAlertsBitmap!)
        
        //print("__params == ",__params)
        self.setDeviceConfig(__params)
    }
    
    
    func ToggleOpenAlerts(p_bEnabled : Bool)
    {
        if( p_bEnabled )
        {
            self.m_bNotifyOnOpenEnabled = true
            
            if (self.strAlertsBitmap! & 8 != 8)
            {
                self.strAlertsBitmap! += 8
            }
        }
        else
        {
            self.m_bNotifyOnOpenEnabled = false
            
            if (self.strAlertsBitmap! & 8 == 8)
            {
                self.strAlertsBitmap! -= 8
            }
        }
        
        let __params = "aev=" + String(self.strAlertsBitmap!)

        //print("__params == ",__params)
        self.setDeviceConfig(__params)
    }

    func ToggleClosedAlerts(p_bEnabled : Bool)
    {
        if( p_bEnabled )
        {
            self.m_bNotifyOnCloseEnabled = true
            
            if (self.strAlertsBitmap! & 1 != 1)
            {
                self.strAlertsBitmap! += 1
            }
        }
        else
        {
            self.m_bNotifyOnCloseEnabled = false
            
            if (self.strAlertsBitmap! & 1 == 1)
            {
                self.strAlertsBitmap! -= 1
            }
        }
        
        let __params = "aev=" + String(self.strAlertsBitmap!)
        
        //print("__params == ",__params)
        self.setDeviceConfig(__params)
    }
    
    func ToggleStoppedAlerts(p_bEnabled : Bool)
    {
        if( p_bEnabled )
        {
            self.m_bNotifyOnStoppedEnabled = true
            
            if (self.strAlertsBitmap! & 16 != 16)
            {
                self.strAlertsBitmap! += 16
            }
        }
        else
        {
            self.m_bNotifyOnStoppedEnabled = false
            
            if (self.strAlertsBitmap! & 16 == 16)
            {
                self.strAlertsBitmap! -= 16
            }
        }
        
        let __params = "aev=" + String(self.strAlertsBitmap!)
        
        //print("__params == ",__params)
        self.setDeviceConfig(__params)
    }
    
    func ToggleDisconnectedAlerts(p_bEnabled : Bool)
    {
        if( p_bEnabled )
        {
            self.m_bNotifyOnDisconnectEnabled = true
            
            if (self.strAlertsBitmap! & 128 != 128)
            {
                self.strAlertsBitmap! += 128
            }
        }
        else
        {
            self.m_bNotifyOnDisconnectEnabled = false
            
            if (self.strAlertsBitmap! & 128 == 128)
            {
                self.strAlertsBitmap! -= 128
            }
        }
        
        let __params = "aev=" + String(self.strAlertsBitmap!)
        
        //print("__params == ",__params)
        self.setDeviceConfig(__params)
    }
    
    func SetTimeoutAlert(p_fValue : Double)
    {
        self.m_fTimeoutValue = p_fValue
        self.m_strTimerMotion = String(p_fValue)
        
        let __params = "aot=" + self.m_strTimerMotion!
        
        //print("__params == ",__params)
        self.setDeviceConfig(__params)
    }
    
    func SetNightAlerts(p_iStart : Int, p_iEnd : Int)
    {
        self.m_iNightAlertStartValue = p_iStart
        self.m_iNightAlertEndValue = p_iEnd
        
        let __params = "ans=" + String(self.m_iNightAlertStartValue) + "|ane=" + String(self.m_iNightAlertEndValue)
        
        //print("__params == ",__params)
        self.setDeviceConfig(__params)
    }
    
    func SetNightAlertStart(p_pStart : NSDate)
    {
        let dateFormatter = NSDateFormatter()
        dateFormatter.locale = NSLocale(localeIdentifier: "us-en")
        dateFormatter.dateFormat = "HH"
        var strFormattedDate = dateFormatter.stringFromDate(p_pStart)
        
        self.m_pNightAlertStartTime = p_pStart
        self.m_iNightAlertStartValue = (Int(strFormattedDate)! * 60)
        
        dateFormatter.dateFormat = "mm"
        strFormattedDate = dateFormatter.stringFromDate(p_pStart)
        self.m_iNightAlertStartValue += (Int(strFormattedDate)!)
        
        let __params = "ans=" + String(self.m_iNightAlertStartValue)
        
        //print("__params == ",__params)
        self.setDeviceConfig(__params)
    }
    
    func SetNightAlertEnd(p_pEnd : NSDate)
    {
        let dateFormatter = NSDateFormatter()
        dateFormatter.locale = NSLocale(localeIdentifier: "us-en")
        dateFormatter.dateFormat = "HH"
        var strFormattedDate = dateFormatter.stringFromDate(p_pEnd)
        
        self.m_pNightAlertEndTime = p_pEnd
        self.m_iNightAlertEndValue = (Int(strFormattedDate)! * 60)
        
        dateFormatter.dateFormat = "mm"
        strFormattedDate = dateFormatter.stringFromDate(p_pEnd)
        self.m_iNightAlertEndValue += (Int(strFormattedDate)!)
        
        let __params = "ane=" + String(self.m_iNightAlertEndValue)
        
        //print("__params == ",__params)
        self.setDeviceConfig(__params)
    }
    
    func SetNightAlertsTimeZone(p_pTimeZone : NSTimeZone)
    {
        self.m_pNightAlertTimeZone = p_pTimeZone
        
        let fServerString = String( (p_pTimeZone.secondsFromGMT / 60 / 60))
        
        let __params = "tzo=" + fServerString
        
        //print("__params == ",__params)
        self.setDeviceConfig(__params)
    }

    func EnabledLocationRadiusForDoor(p_bEnabled : Bool)
    {        
        self.m_bNotifyOnDepartureEnabled = p_bEnabled

        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setBool(p_bEnabled, forKey: self.m_strName! + "doorNotifyOnDepartureEnabled")
    }
    
    func getDoorStatus(p_bCheckForLocalNotifications : Bool = false)
    {
        if self.m_pDevice!.connected
        {
            self.m_pDevice!.getVariable("doorStatus", completion: { (result:AnyObject?, error:NSError?) -> Void in
                if let _=error {
                    print("Failed reading doorStatus from device")
                }
                else
                {
                    let resultArr = result!.componentsSeparatedByString("|")
                    for val in resultArr
                    {
                        let valArr = val.componentsSeparatedByString("=")
                        //.. Door Status
                        if valArr[0] == "status"
                        {
                            self.m_strStatus = valArr[1]
                            
                            if( self.m_strStatus == "open" /*|| self.m_strStatus == "opening"*/ )
                            {
                                dispatch_async(dispatch_get_main_queue()) { [unowned self] in
                                    
                                    self.m_pDoorUIButton!.imageView!.stopAnimating()
                                    self.m_pDoorUIButton!.setImage(UIImage(	named: "door-15.png"), forState: .Normal)
                                    self.m_pDoorStatusUILabel!.text = "open" + " " + self.m_strStatusTime!
                                    self.m_strStatus = "open"
                                    
                                    self.m_pProgressBGShape!.hidden = true
                                    self.m_pProgressBarShape!.hidden = true
                                    self.m_pProgressBarLabel!.hidden = true
                                    self.m_dProgressMod = 0.0
                                    
                                    self.m_pProgressTimer?.invalidate()
                                }
                            }
                            else if( self.m_strStatus == "closed" /*|| self.m_strStatus == "closing"*/ )
                            {
                                dispatch_async(dispatch_get_main_queue()) { [unowned self] in
                                    
                                    self.m_pDoorUIButton!.imageView!.stopAnimating()
                                    self.m_pDoorUIButton!.setImage(UIImage(	named: "door-01.png"), forState: .Normal)
                                    self.m_pDoorStatusUILabel!.text = "closed" + " " + self.m_strStatusTime!
                                    self.m_strStatus = "closed"
                                    
                                    self.m_pProgressBGShape!.hidden = true
                                    self.m_pProgressBarShape!.hidden = true
                                    self.m_pProgressBarLabel!.hidden = true
                                    self.m_dProgressMod = 0.0
                                    
                                    self.m_pProgressTimer?.invalidate()
                                }
                            }
                            
                            if( p_bCheckForLocalNotifications == true && self.m_strStatus! != "closed")
                            {
                                self.CheckForUserLocationNotification()
                            }
                        }
                        //.. Door time
                        if valArr[0] == "time"
                        {
                            self.m_strStatusTime = valArr[1]
                            
                            if( self.m_pDoorStatusUILabel != nil )
                            {
                                self.m_pDoorStatusUILabel!.text = self.m_strStatus! + " " + valArr[1]
                            }
                        }
                        //.. Door sensor
                        if valArr[0] == "sensor"
                        {
                            self.m_strSensorRate = valArr[1]
                        }
                        //.. Door Signal
                        if valArr[0] == "signal"
                        {
                            self.m_strWifiSignal = valArr[1]
                            
                            self.UpdateStatusUI(Int(valArr[1])!)
                        }
                    }
                }
            })
        }
    }
    
    func getDoorTime()
    {
        if self.m_pDevice!.connected
        {
            self.m_pDevice!.getVariable("doorStatus", completion: { (result:AnyObject?, error:NSError?) -> Void in
                if let _=error {
                    print("Failed reading doorStatus from device")
                }
                else
                {
                    let resultArr = result!.componentsSeparatedByString("|")
                    for val in resultArr
                    {
                        let valArr = val.componentsSeparatedByString("=")
                        
                        //.. Door time
                        if valArr[0] == "time"
                        {
                            self.m_strStatusTime = valArr[1]
                            
                            if( self.m_pDoorStatusUILabel != nil )
                            {
                                self.m_pDoorStatusUILabel!.text = self.m_strStatus! + " " + valArr[1]
                            }
                        }
                        //.. Door sensor
                        if valArr[0] == "sensor"
                        {
                            self.m_strSensorRate = valArr[1]
                        }
                        //.. Door Signal
                        if valArr[0] == "signal"
                        {
                            self.m_strWifiSignal = valArr[1]
                            
                            self.UpdateStatusUI(Int(valArr[1])!)
                        }
                    }
                }
            })
        }
    }
    
    func loadAndSyncDoorData(senderViewController: DoorsVC)
    {
        self.m_pDoorsVC = senderViewController
        
        self.loadSettingsFromDevice()
        
        self.loadSettingsFromLocal()
        
        if( self.m_bNotifyOnDepartureEnabled != nil && self.m_bNotifyOnDepartureEnabled == true)
        {
            let pAppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            pAppDelegate.AuthorizeLocationTracking()
        }
        
        
        NSTimer.scheduledTimerWithTimeInterval(2.0, target: self, selector:#selector(DoorModel.getDoorTime), userInfo: nil, repeats: true)
    }
    
    func loadSettingsFromDevice()
    {
        let __Photon = self.m_pDevice
        
        //SM: Due to a delay when disconnecting a Garadget device, we need to assume the device is offline and only set to online when the status is recieved from Particle.
        self.m_bConnected = false
        
        //print("Door Device Connected : " + self.m_pDevice!.connected.description)
        
        if self.m_pDevice!.connected == true
        {
            __Photon!.getVariable("doorStatus", completion: { (result:AnyObject?, error:NSError?) -> Void in
                if let _=error
                {
                    print("Failed reading doorStatus from device")

                    self.m_bConnected = false
                }
                else
                {
                    self.m_bConnected = true
                    
                    let resultArr = result!.componentsSeparatedByString("|")
                    for val in resultArr
                    {
                        let valArr = val.componentsSeparatedByString("=")
                        //.. Door Status
                        if valArr[0] == "status"
                        {
                            self.m_strStatus = valArr[1]
                            
                            if( self.m_pDoorStatusUILabel != nil )
                            {
                                self.m_pDoorStatusUILabel!.text = valArr[1] + " " + self.m_strStatusTime!
                            }
                            
                            if self.m_strStatus == "open"
                            {
                                self.m_pDoorUIButton!.setImage(UIImage(	named: "door-15.png"), forState: .Normal)
                            }
                            else
                            {
                                self.m_pDoorUIButton!.setImage(UIImage(	named: "door-01.png"), forState: .Normal)
                            }
                        }
                        //.. Door time
                        if valArr[0] == "time"
                        {
                            self.m_strStatusTime = valArr[1]
                            
                            if( self.m_pDoorStatusUILabel != nil )
                            {
                                self.m_pDoorStatusUILabel!.text = self.m_strStatus! + " " + valArr[1]
                            }
                        }
                        //.. Door sensor
                        if valArr[0] == "sensor"
                        {
                            self.m_strSensorRate = valArr[1]
                        }
                        //.. Door Signal
                        if valArr[0] == "signal"
                        {
                            self.m_strWifiSignal = valArr[1]
                            
                            self.UpdateStatusUI(Int(valArr[1])!)
                        }
                    }
                    
                    //DoorConfig
                    __Photon!.getVariable("doorConfig", completion: { (result:AnyObject?, error:NSError?) -> Void in
                        if let _=error
                        {
                            print("Failed reading doorStatus from device")
                        }
                        else
                        {
                            //print("doorConfig is == ", result)
                            
                            let resultArr = result!.componentsSeparatedByString("|")
                            
                            for val in resultArr
                            {
                                let valArr = val.componentsSeparatedByString("=")
                                
                                //.. Scan Period
                                if valArr[0] == "rdt"
                                {
                                    let fValue = (Double(valArr[1])!/1000)
                                    self.m_strSensorScanPeriod = String(fValue)
                                }
                                    //.. Sensor Reads
                                else if valArr[0] == "srr"
                                {
                                    self.m_strSensorReads = valArr[1]
                                }
                                    //.. Sensor Thresshold
                                else if valArr[0] == "srt"
                                {
                                    self.m_strSensorThreshhold = valArr[1]
                                }
                                    //.. Firmware
                                else if valArr[0] == "ver"
                                {
                                    self.m_strFirmwareVersion = valArr[1]
                                }
                                    //.. Connection Timeout
                                else if valArr[0] == "cnt"
                                {
                                    self.m_strConnectionTimeOut = valArr[1]
                                }
                                    //.. Door Motion Time
                                else if valArr[0] == "mtt"
                                {
                                    self.m_strTimerMotion = String(format: "%.3f", Double(valArr[1])!/1000)
                                    self.m_dTimerMotion = Double(valArr[1])!/1000
                                }
                                    //.. Door Warm up Time
                                else if valArr[0] == "mot"
                                {
                                    self.m_strWarmUpTime = String(format: "%.3f", Double(valArr[1])!/1000)
                                }
                                    //.. Relay On Time
                                else if valArr[0] == "rlt"
                                {
                                    self.m_strTimerRelayOn = String(format: "%.3f", Double(valArr[1])!/1000)
                                }
                                    //.. Relay Off Time
                                else if valArr[0] == "rlp"
                                {
                                    self.m_strTimerRelayOff = String(format: "%.3f", Double(valArr[1])!/1000)
                                }
                                else if valArr[0] == "aot"
                                {
                                    let strTimeoutValue = String(format: "%.3f", Double(valArr[1])!)
                                    self.m_fTimeoutValue = Double(strTimeoutValue)
                                }
                                else if valArr[0] == "ans"
                                {
                                    self.m_iNightAlertStartValue = Int(valArr[1])!
                                    
                                    let convertedValue = Double(self.m_iNightAlertStartValue) / 60.0
                                    let iHours = Int(convertedValue)
                                    let iMinutes = Int((convertedValue - Double(iHours)) * 60.0)
                                    
                                    let dateFormatter = NSDateFormatter()
                                    dateFormatter.locale = NSLocale(localeIdentifier: "us-en")
                                    dateFormatter.dateFormat = "HH:mm"
                                    
                                    var pStartTime : NSDate
                                    if iHours < 10
                                    {
                                        pStartTime = dateFormatter.dateFromString("0" + String(iHours) + ":" + String(iMinutes))!
                                    }
                                    else
                                    {
                                        pStartTime = dateFormatter.dateFromString(String(iHours) + ":" + String(iMinutes))!
                                    }
                                    
                                    self.m_pNightAlertStartTime = pStartTime
                                }
                                else if valArr[0] == "ane"
                                {
                                    self.m_iNightAlertEndValue = Int(valArr[1])!
                                    
                                    let convertedValue = Double(self.m_iNightAlertEndValue) / 60.0
                                    let iHours = Int(convertedValue)
                                    let iMinutes = Int((convertedValue - Double(iHours)) * 60.0)
                                    
                                    let dateFormatter = NSDateFormatter()
                                    dateFormatter.locale = NSLocale(localeIdentifier: "us-en")
                                    dateFormatter.dateFormat = "HH:mm"
                                    
                                    var pEndTime : NSDate
                                    if iHours < 10
                                    {
                                        pEndTime = dateFormatter.dateFromString("0" + String(iHours) + ":" + String(iMinutes))!
                                    }
                                    else
                                    {
                                        pEndTime = dateFormatter.dateFromString(String(iHours) + ":" + String(iMinutes))!
                                    }
                                    
                                    self.m_pNightAlertEndTime = pEndTime
                                }
                                else if valArr[0] == "aev"
                                {
                                    self.strAlertsBitmap = UInt8(valArr[1])
                                    //print(self.strAlertsBitmap)
                                    
                                    // Closed
                                    if (self.strAlertsBitmap! & 1 == 1)
                                    {
                                        self.m_bNotifyOnCloseEnabled = true
                                    }
                                    else
                                    {
                                        self.m_bNotifyOnCloseEnabled = false
                                    }
                                    
                                    // Open
//                                    if (self.strAlertsBitmap! & 2 == 2)
//                                    {
//                                        self.m_bNotifyOnOpenEnabled = true
//                                    }
//                                    else
//                                    {
//                                        self.m_bNotifyOnOpenEnabled = false
//                                    }
                                    
                                    // Closing
//                                    if (self.strAlertsBitmap! & 4 == 4)
//                                    {
//                                        self.m_bNotifyOnCloseEnabled = true
//                                    }
//                                    else
//                                    {
//                                        self.m_bNotifyOnCloseEnabled = false
//                                    }
                                    
                                    // Opening
                                    if (self.strAlertsBitmap! & 8 == 8)
                                    {
                                        self.m_bNotifyOnOpenEnabled = true
                                    }
                                    else
                                    {
                                        self.m_bNotifyOnOpenEnabled = false
                                    }
                                    
                                    // Stopped
                                    if (self.strAlertsBitmap! & 16 == 16)
                                    {
                                        self.m_bNotifyOnStoppedEnabled = true
                                    }
                                    else
                                    {
                                        self.m_bNotifyOnStoppedEnabled = false
                                    }
                                    
                                    // Init 
                                    if (self.strAlertsBitmap! & 32 == 32)
                                    {
                                        self.m_bNotifyOnRebootEnabled = true
                                    }
                                    else
                                    {
                                        self.m_bNotifyOnRebootEnabled = false
                                    }
                                    
                                    // Online 
                                    if (self.strAlertsBitmap! & 64 == 64)
                                    {
                                        self.m_bNotifyWhenOnlineEnabled = true
                                    }
                                    else
                                    {
                                        self.m_bNotifyWhenOnlineEnabled = false
                                    }
                                    
                                    // Offline
                                    if( self.strAlertsBitmap! & 128  == 128 )
                                    {
                                        self.m_bNotifyOnDisconnectEnabled = true
                                    }
                                    else
                                    {
                                        self.m_bNotifyOnDisconnectEnabled = false
                                    }
                                    
                                    // Config Change
//                                    if( value! & 256 == 256 )
//                                    {
//                                        
//                                    }
                                    
                                    self.CheckAlertSettingsStatus()
                                }
                                else if( valArr[0] == "tzo" )
                                {
                                    let strDeviceTimeZoneValue = String(valArr[1])
                                    
                                    let fValue = Double(strDeviceTimeZoneValue)
                                    if( fValue != nil )
                                    {
                                        let arrTimezonesAbbreviations = Array(NSTimeZone.abbreviationDictionary().keys)
                                        
                                        var iIndex = 0
                                        for pAbbreviation in arrTimezonesAbbreviations
                                        {
                                            let timezone = NSTimeZone(abbreviation: pAbbreviation)
                                            
                                            let fGMTOffset = Double( (timezone!.secondsFromGMT / 60 / 60) - 1)
                                            
                                            if( fValue == fGMTOffset )
                                            {
                                                self.m_pNightAlertTimeZone = timezone
                                                break
                                            }
                                            
                                            iIndex += 1
                                        }
                                    }
                                }
                            }
                            
                            // NetConfig
                            __Photon!.getVariable("netConfig", completion: { (result:AnyObject?, error:NSError?) -> Void in
                                if let _=error {
                                    //print("Failed reading doorStatus from device")
                                }
                                else {
                                    //print("netConfig is == ", result)
                                    let resultArr = result!.componentsSeparatedByString("|")
                                    
                                    for val in resultArr
                                    {
                                        let valArr = val.componentsSeparatedByString("=")
                                        
                                        //.. Door ip
                                        if valArr[0] == "ip"
                                        {
                                            self.m_strWifiIp = valArr[1]
                                        }
                                        //.. Door snet
                                        if valArr[0] == "snet"
                                        {
                                            self.m_strWifiNetmask = valArr[1]
                                        }
                                        //.. Door gway
                                        if valArr[0] == "gway"
                                        {
                                            self.m_strWifiGateway = valArr[1]
                                        }
                                        //.. Door mac
                                        if valArr[0] == "mac"
                                        {
                                            self.m_strWifiMac = valArr[1]
                                        }
                                        //.. Door ssid
                                        if valArr[0] == "ssid"
                                        {
                                            self.m_strWifiSsid = valArr[1]
                                        }
                                    }                                                                                                        }
                            })
                        }
                    })
                }
            })
        }
        else
        {
            self.m_strStatus = ""
            self.m_strWifiSignal = ""
            self.m_strSensorRate = ""
            self.m_strSensorScanPeriod = ""
            self.m_strSensorReads = ""
            self.m_strSensorThreshhold = ""
            self.m_strFirmwareVersion = ""
            self.m_strConnectionTimeOut = ""
            self.m_strTimerMotion = ""
            self.m_strWarmUpTime = ""
            self.m_strTimerRelayOn = ""
            self.m_strTimerRelayOff = ""
            self.m_strWifiIp = ""
            self.m_strWifiNetmask = ""
            self.m_strWifiGateway = ""
            self.m_strWifiMac = ""
            self.m_strWifiSsid = ""
            self.m_strStatus = "Offline"
        }
    }
    
    func loadSettingsFromLocal()
    {
        let defaults = NSUserDefaults.standardUserDefaults()
        
        self.m_bInsideRadius = defaults.valueForKey(self.m_strName! + "_inside_radius") as? Bool
        if( self.m_bInsideRadius == nil)
        {
            self.m_bInsideRadius = true
        }
        
        // Location Notifications
        self.m_bNotifyOnDepartureEnabled = defaults.valueForKey(self.m_strName! + "doorNotifyOnDepartureEnabled") as? Bool
        
        self.m_dDepartureRadius = defaults.valueForKey(self.m_strName! + "doorDepartureRadius") as? Double
        if( self.m_dDepartureRadius == nil )
        {
            self.m_dDepartureRadius = 0.0
        }
        
        //SM: Convert location information from dictionary
        if( NSUserDefaults.standardUserDefaults().objectForKey(self.m_strName! + "doorLocation") != nil)
        {
            let userLoc = NSUserDefaults.standardUserDefaults().objectForKey(self.m_strName! + "doorLocation") as! [String : NSNumber]
            
            //Get user location from that Dictionary
            let userLat = userLoc["lat"]
            let userLng = userLoc["lng"]
            
            self.m_pDoorLocation = CLLocation(latitude: userLat as! CLLocationDegrees, longitude: userLng as! CLLocationDegrees)
        }
    }
    
    func SetupEventHandlerForState()
    {
        let myPhoton = self.m_pDevice
        
        //print("subscribing to event...");
        var gotFirstEvent : Bool = false
        
        let myEventId = myPhoton!.subscribeToEventsWithPrefix("state", handler: { (event: SparkEvent?, error:NSError?) -> Void in
            
            if (!gotFirstEvent)
            {
                print("Got first event: "+event!.data!)
                gotFirstEvent = true
            }
            else
            {
                print("Got event: "+event!.data!)
            }
            
            if( event!.data! == "open" )
            {
                dispatch_async(dispatch_get_main_queue()) { [unowned self] in
                    
                    self.m_pDoorUIButton!.imageView!.stopAnimating()
                    self.m_pDoorUIButton!.setImage(UIImage(	named: "door-15.png"), forState: .Normal)
                    self.m_pDoorStatusUILabel!.text = "open" + " " + self.m_strStatusTime!
                    self.m_strStatus = "open"
                    
                    self.m_pProgressBGShape!.hidden = true
                    self.m_pProgressBarShape!.hidden = true
                    self.m_pProgressBarLabel!.hidden = true
                    self.m_dProgressMod = 0.0
                    
                    self.m_pProgressTimer?.invalidate()
                }
            }
            else if( event!.data! == "closed" )
            {
                dispatch_async(dispatch_get_main_queue()) { [unowned self] in
                    
                    self.m_pDoorUIButton!.imageView!.stopAnimating()
                    self.m_pDoorUIButton!.setImage(UIImage(	named: "door-01.png"), forState: .Normal)
                    self.m_pDoorStatusUILabel!.text = "closed" + " " + self.m_strStatusTime!
                    self.m_strStatus = "closed"
                    
                    self.m_pProgressBGShape!.hidden = true
                    self.m_pProgressBarShape!.hidden = true
                    self.m_pProgressBarLabel!.hidden = true
                    self.m_dProgressMod = 0.0
                    
                    self.m_pProgressTimer?.invalidate()
                }
            }
            else if( event!.data! == "stopped" )
            {

            }
        });
    }
    
//    func SetupEventHandlerForTime()
//    {
//        let myPhoton = self.m_pDevice
//        
//        //print("subscribing to event...");
//        
//        let myEventId = myPhoton!.subscribeToEventsWithPrefix("time", handler: { (event: SparkEvent?, error:NSError?) -> Void in
//            
//            self.m_strStatusTime = event!.data!
//            
//            print("EventHandler : Time Event : " + event!.data!)
//            
//            if( self.m_pDoorStatusUILabel != nil )
//            {
//                self.m_pDoorStatusUILabel!.text = self.m_pDoorStatusUILabel!.text! + " " + event!.data!
//            }
//        });
//    }
    
    func renameDevice (p_strName : String)
    {
        self.m_pDevice!.rename(p_strName, completion: { (error:NSError?) -> Void in
            if (error == nil)
            {
                //print("Device successfully renamed")
                self.m_strName = p_strName
                self.m_pDoorsVC?.deviceNameSyncCallback(p_strName)
            }
        })
    }
    
    func setDeviceConfig (__param : AnyObject)
    {
        let funcArgs = [__param]
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),
            {
            self.m_pDevice!.callFunction("setConfig", withArguments: funcArgs) { (resultCode : NSNumber?, error : NSError?) -> Void in
                if (error == nil)
                {
                    //print("SetDeviceConfig : resultCode == ",resultCode)
                }
                else
                {
                    //print("error == ", error)
                }
            }
        })
    }
    
    func CheckForUserLocationNotification ()
    {
        if (self.m_bNotifyOnDepartureEnabled != nil) && (self.m_bNotifyOnDepartureEnabled == true)
        {
            let __appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0))
                {
                if( self.m_pDoorLocation != nil )
                {
                    let __distance = ((self.m_pDoorLocation?.distanceFromLocation(__appDelegate.m_pCurrentLocation))!)
                    
                    //print("LOCATION ALERT DISTANCE: " + String(__distance))
                
                    // Create a weak reference to prevent retain cycle and get nil if self is released before run finishes
                    dispatch_async(dispatch_get_main_queue())
                        {
                        // Return data and update on the main thread, all UI calls should be on the main thread
                        if  __distance > self.m_dDepartureRadius!
                        {
                            //print("Outside Radius: " + String(self.m_dDepartureRadius))
                            
                            if self.m_bInsideRadius == true
                            {
                                self.m_bInsideRadius = false
                                
                                //print("Sending Local Notification for the state of my door")
                                
                                let defaults = NSUserDefaults.standardUserDefaults()
                                defaults.setValue(false, forKey: self.m_strName! + "_inside_radius")
                                
                                var strAlert = self.m_strName! + " is " + self.m_strStatus!
                                
                                strAlert += " and your distance between the garage is " +  String(Int(__distance)) + " meters"
                                
                                __appDelegate.PushLocalNotification(strAlert)
                            }
                        }
                        else
                        {
                            //print("Inside Radius")
                            
                            self.m_bInsideRadius = true
                            
                            let defaults = NSUserDefaults.standardUserDefaults()
                            defaults.setValue(true, forKey: self.m_strName! + "_inside_radius")
                        }
                    }
                }
            }
        }
    }
    
    func CheckAlertSettingsStatus()
    {
        if( self.m_bNotifyOnRebootEnabled == false && self.m_bNotifyOnOpenEnabled == false && self.m_bNotifyOnCloseEnabled == false && self.m_bNotifyWhenOnlineEnabled == false && self.m_bNotifyOnStoppedEnabled == false && self.m_bNotifyOnDisconnectEnabled == false)
        {
            let pAppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            if(pAppDelegate.m_strAPNSToken != nil)
            {
                self.PostDisableDeviceAlertsToWebserver(pAppDelegate.m_strAPNSToken!)
            }
        }
        else
        {
            let pAppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            if(pAppDelegate.m_strAPNSToken != nil)
            {
                self.PostDoorDataToWebserver(pAppDelegate.m_strAPNSToken!)
            }
        }
    }
    
    func SetDoorLocation(p_pLocation : CLLocation)
    {
        m_pDoorLocation = p_pLocation
        
        //First Convert it to NSNumber.
        let lat : NSNumber = NSNumber(double: p_pLocation.coordinate.latitude)
        let lng : NSNumber = NSNumber(double: p_pLocation.coordinate.longitude)
        
        //Store it into Dictionary
        let locationDict = ["lat": lat, "lng": lng]
        
        //Store that Dictionary into NSUserDefaults
        NSUserDefaults.standardUserDefaults().setObject(locationDict, forKey: self.m_strName! + "doorLocation")
    }
    
    func SetDoorRadius(p_dRadius : Double)
    {
        self.m_dDepartureRadius = p_dRadius
        
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setDouble(self.m_dDepartureRadius!, forKey: self.m_strName! + "doorDepartureRadius")
    }
    
    func UpdateStatusUI(p_iValue : Int)
    {
        var imageName : String
        
        if (p_iValue <= -85)
        {
            imageName = "signal-02.png"
        }
        else if (p_iValue <= -70)
        {
            imageName = "signal-03.png"
        }
        else if (p_iValue <= -60)
        {
            imageName = "signal-04.png"
        }
        else if (p_iValue <= -50)
        {
            imageName = "signal-05.png"
        }
        else
        {
            imageName = "signal-06.png"
        }
        
        self.m_pDoorSignalUIImage!.image = UIImage(named: imageName)
    }
    
    func createProgressBar(p_pButton : UIButton)
    {
        // Door Progress Bar
        let bgCircle = UIBezierPath(arcCenter: CGPoint(x: self.m_dProgressX!,y: self.m_dProgressY!), radius: CGFloat(35), startAngle: CGFloat(0), endAngle:CGFloat(M_PI * 2), clockwise: true)
        self.m_pProgressBGShape = CAShapeLayer()
        self.m_pProgressBGShape!.path = bgCircle.CGPath
        self.m_pProgressBGShape!.fillColor = UIColor(red: 200/255, green: 200/255, blue: 200/255, alpha: 0.25).CGColor
        self.m_pProgressBGShape!.strokeColor = UIColor(red: 200/255, green: 200/255, blue: 200/255, alpha: 0.95).CGColor
        self.m_pProgressBGShape!.lineWidth = 12.0
        self.m_pProgressBGShape!.zPosition = 2
        
        p_pButton.layer.addSublayer(self.m_pProgressBGShape!)
        
        self.m_pProgressBarCircle = UIBezierPath(arcCenter: CGPoint(x: self.m_dProgressX!,y: self.m_dProgressX!), radius: CGFloat(self.m_dProgressBarRadius!), startAngle: CGFloat(-M_PI * 0.5), endAngle:CGFloat((M_PI * 1.5) * m_dProgressMod!), clockwise: true)
        self.m_pProgressBarShape = CAShapeLayer()
        m_pProgressBarShape!.path = self.m_pProgressBarCircle!.CGPath
        m_pProgressBarShape!.fillColor = UIColor.clearColor().CGColor
        m_pProgressBarShape!.strokeColor = UIColor(red: 24/255, green: 115/255, blue: 30/255, alpha: 1).CGColor
        m_pProgressBarShape!.lineWidth = 10.0
        m_pProgressBarShape!.zPosition = 2
        
        p_pButton.layer.addSublayer(m_pProgressBarShape!)
        
        self.m_pProgressBarLabel = UILabel()
        self.m_pProgressBarLabel!.font = self.m_pProgressBarLabel!.font.fontWithSize(25)
        self.m_pProgressBarLabel!.frame = CGRectMake(40, 50, 100, 100)
        self.m_pProgressBarLabel!.textAlignment = NSTextAlignment.Center
        self.m_pProgressBarLabel!.textColor = UIColor.whiteColor()
        self.m_pProgressBarLabel!.text = "100%"
        self.m_pProgressBarLabel?.layer.zPosition = 3
        p_pButton.layer.addSublayer((self.m_pProgressBarLabel?.layer)!)
        
        self.m_pProgressBGShape!.hidden = true
        self.m_pProgressBarShape!.hidden = true
        self.m_pProgressBarLabel!.hidden = true
    }
    
    func startProgressBar()
    {
        self.m_pProgressBGShape!.hidden = false
        self.m_pProgressBarShape!.hidden = false
        self.m_pProgressBarLabel!.hidden = false
        self.m_dProgressMod = 0.0
        self.m_pProgressTimer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: #selector(DoorModel.updateProgressBar), userInfo: nil, repeats: true)
    }
    
    func updateProgressBar()
    {
        if( self.m_dProgressMod < self.m_dTimerMotion )
        {
            self.m_dProgressMod = self.m_dProgressMod! + 0.1
            
            var fPercentage = self.m_dProgressMod! / self.m_dTimerMotion!
            
            if( fPercentage > 1.0 )
            {
                fPercentage = 1.0
            }
            
            let iPercentageLabel = Int(fPercentage * 100)
            self.m_pProgressBarLabel!.text = String(iPercentageLabel) + "%"
            
            self.m_pProgressBarCircle = UIBezierPath(arcCenter: CGPoint(x: self.m_dProgressX!, y: self.m_dProgressY!), radius: CGFloat(self.m_dProgressBarRadius!), startAngle: CGFloat(-M_PI * 0.5), endAngle:CGFloat(-M_PI * 0.5) + (CGFloat((M_PI * 2.0) * fPercentage)) , clockwise: true)
            self.m_pProgressBarShape!.path = self.m_pProgressBarCircle!.CGPath
            
            let bgCircle = UIBezierPath(arcCenter: CGPoint(x: self.m_dProgressX!,y: self.m_dProgressY!), radius: CGFloat(self.m_dProgressBarRadius!), startAngle: CGFloat(0), endAngle:CGFloat(M_PI * 2), clockwise: true)
            self.m_pProgressBGShape!.path = bgCircle.CGPath
        }
        else
        {
            self.m_pProgressBGShape!.hidden = true
            self.m_pProgressBarShape!.hidden = true
            self.m_pProgressBarLabel!.hidden = true
            self.m_dProgressMod = 0.0
            
            self.m_pProgressTimer?.invalidate()
        }
    }
    
    func PostDoorDataToWebserver(p_strAPNSToken : String)
    {
        let deviceID = self.m_pDevice!.id
        let particleToken = SparkCloud.sharedInstance().accessToken
        
        let params:NSDictionary = ["action" : "add", "platform" : "apns", "subscriber" : p_strAPNSToken, "device" : deviceID, "authtoken" : particleToken!]
        
        self.Post(params, url: "https://www.garadget.com/my/json/pn-signup.php")
    }
    
    func Post(params : NSDictionary, url : String)
    {
        //print(params)
        
        let request = NSMutableURLRequest(URL: NSURL(string: url)!)
        let session = NSURLSession.sharedSession()
        request.HTTPMethod = "POST"
        
        let pAppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        let strAction = String(params.valueForKey("action")!)
        let strDeviceID = String(params.valueForKey("device")!)
        let strParticleID = String(params.valueForKey("authtoken")!)
        
        let bodyData = "action=" + strAction + "&platform=apns&subscriber=" + String(pAppDelegate.m_strAPNSToken) + "&device=" + strDeviceID + "&authtoken=" + strParticleID
        
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
    
    func PostDisableDeviceAlertsToWebserver(p_strAPNSToken : String)
    {
        let deviceID = self.m_pDevice!.id
        let particleToken = SparkCloud.sharedInstance().accessToken
        
        let params:NSDictionary = ["action" : "remove", "platform" : "apns", "subscriber" : p_strAPNSToken, "device" : deviceID, "authtoken" : particleToken!]
        
        self.Post(params, url: "https://www.garadget.com/my/json/pn-signup.php")
    }
}
