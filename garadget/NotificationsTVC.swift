//
//  NotificationsTVC.swift
//  garadget
//
//  Created by Stephen Madsen on 3/23/16.
//  Copyright © 2016 Stephen Madsen. All rights reserved.
//
import MapKit

class NotificationsTVC: UITableViewController, MKMapViewDelegate
{
    // Event Alert Outlets
    @IBOutlet weak var notify_on_reboot_outlet: UISwitch!

    @IBOutlet weak var notify_on_online_outlet: UISwitch!
    
    @IBOutlet weak var notify_on_open_outlet: UISwitch!
    
    @IBOutlet weak var notify_on_close_outlet: UISwitch!
    
    @IBOutlet weak var notify_on_stopped_outlet: UISwitch!
    
    @IBOutlet weak var notify_on_disconnect_outlet: UISwitch!
    
    //@IBOutlet weak var door_start_delay_outlet: UILabel!
    
    // Timeout Alert Outlets
    @IBOutlet weak var door_motion_outlet: UISwitch!
    
    @IBOutlet weak var timeout_value_outlet: UIButton!
    
    var m_iTimeoutAlertIndex : Int? = 0
    
    let m_arrTimeoutAlertLabels = ["30 Seconds", "1 minute", "2 minutes", "3 minutes", "5 minutes", "10 minutes", "15 minutes", "20 minutes", "30 minutes", "40 minutes", "1 hour", "1.5 hours", "2 hours", "3 hours", "4 hours", "6 hours", "8 hours", "12 hours"]
    
    let m_arrTimeoutAlertValues = [30.0, 60.0, 120.0, 180, 300, 600, 900, 1200, 1800, 2400, 3600, 5400, 7200, 10800, 14400, 21600, 28800, 43200]
    
    // Night Alerts
    @IBOutlet weak var night_alerts_enabled_outlet: UISwitch!
    
    @IBOutlet weak var night_from_button_outlet: UIButton!
    
    @IBOutlet weak var night_to_button_outlet: UIButton!
    
    @IBOutlet weak var night_timezone_button_outlet: UIButton!
    
//    let m_arrTimezoneLabels = ["(GMT-12:00) International Date Line West", "(GMT-11:00) Midway Island, Samoa", "(GMT-10:00) Hawaii", "(GMT-09:00 +DST) Alaska", "(GMT-08:00 +DST) Pacific Time (US & Canada)", "(GMT-08:00 +DST) Tijuana, Baja California", "(GMT-07:00 +DST) Arizona", "(GMT-07:00 +DST) Chihuahua, La Paz Mazatlan", "(GMT-07:00 +DST) Mountain Time (US & Canada)", "(GMT-06:00) Central America", "(GMT-06:00 +DST) Central Time (US & Canada)", "(GMT-06:00) Guadalajara, Mexico City, Monterrey", "(GMT-06:00) Saskatchewan", "(GMT-05:00) Bogota, Lima, Quito, Rio Branco", "(GMT-05:00 +DST) Eastern Time (US & Canada)", "(GMT-05:00 +DST) Indiana (East)", "(GMT-04:00 +DST) Atlantic Time (Canada)", "(GMT-04:00) Caracas, La Paz", "(GMT-04:00) Manaus", "(GMT-04:00) Santiago", "(GMT-03:30) Newfoundland", "(GMT-03:00) Brasilia", "(GMT-03:00) Buenos Aires, Georgetown", "(GMT-03:00) Greenland", "(GMT-03:00) Montevideo", "(GMT-02:00) Mid-Atlantic", "(GMT-01:00) Cape Verde Is.", "(GMT-00:00) Monrovia, Reykjavik", "(GMT-00:00 +DST) Dublin, Edinburgh, Lisbon, Longon", "(GMT+01:00 + DST) Amsterdam, Berlin, Bern, Rome, Stockholm, Vienna", "(GMT+01:00 + DST) Belgrade, Bratislava, Budapest, Ljubljana, Prague", "(GMT+01:00 + DST) Brussels, Copenhagen, Madrid, Paris", "(GMT+01:00 + DST) Sarajevo, Skopje, Warsaw, Zagreb", "(GMT+01:00) West Central Africa", "(GMT+02:00 + DST) Amman", "(GMT+02:00 + DST) Athens, Bucharest, Istanbul", "(GMT+02:00 + DST) Cairo", "(GMT+02:00) Harare, Pretoria", "(GMT+02:00 + DST) Helsinki, Kyiv, Riga, Tallin", "(GMT+02:00 + DST) Jerusalem", "(GMT+02:00 + DST) Windhoek", "(GMT+03:00) Kuwait, Riyadh, Baghdad", "(GMT+03:00) Moscow, St. Petersburg, Volgograd", "(GMT+03:30) Tehran", "(GMT+04:00) Abu Dhabi, Muscat, Tbilsi", "(GMT+04:30) Kabul", "(GMT+05:00) Islamabad, Karachi, Tashkent", "(GMT+05:30) Chennai, Kokata, Mumbai, New Delhi", "(GMT+06:00) Almaty, Novosibirsk", "(GMT+07:00) Bangkok, Hanoi, Jakarta", "(GMT+07:00) Krasnoyarsk", "(GMT+08:00) Beijing, Chongqing, Hong Kong, Urumqi", "(GMT+08:00) Kuala Lumpur, Singapore", "(GMT+08:00) Irkutsk, Perth, Taipei, Ulaan Bataar", "(GMT+09:00) Osaka, Sapporo, Seoul, Tokyo, Yakutsk", "(GMT+09:30) Adelaide", "(GMT+09:30) Darwin", "(GMT+10:00) Brisbane", "(GMT+10:00) Canberra, Hobart, Melbourne, Sydney", "(GMT+10:00) Guam, Port Moresby, Vladivostok", "(GMT+11:00) Magadan, Solomon Is., New Caledonia", "(GMT+12:00) Auckland, Wllington", "(GMT+12:00) Fiji, Kamchatka, Marshall Is."]
//    
//    let m_arrTimezoneValues = [ -12, -11, -10, -9, -8, -8, -7, -7, -7, -6, -6, -6, -6, -5, -5, -5, -4, -4, -4, -4, -3.5, -3, -3, -3, -3, -2, -1, 0, 0, 1, 1, 1, 1, 1, 2, 2, 2, 2, 2, 2, 2, 3, 3, 3.5, 4, 4.5, 5, 5.5, 6, 7, 7, 8, 8, 8, 9, 9.5, 9.5, 10, 10, 10, 11, 12, 12 ]

    let m_arrTimezoneLabels = ["(GMT-12:00) International Date Line West", "(GMT-11:00) Midway Island, Samoa", "(GMT-10:00) Hawaii", "(GMT-09:00 +DST) Alaska", "(GMT-08:00 +DST) Pacific Time (US & Canada)", "(GMT-07:00 +DST) Mountain Time (US & Canada)", "(GMT-06:00 +DST) Central Time (US & Canada)", "(GMT-05:00 +DST) Eastern Time (US & Canada)", "(GMT-04:00 +DST) Atlantic Time (Canada)", "(GMT-03:30) Newfoundland", "(GMT-02:00) Mid-Atlantic", "(GMT-01:00) Cape Verde Is.", "(GMT-00:00) Monrovia, Reykjavik", "(GMT-00:00 +DST) Dublin, Edinburgh, Lisbon, Longon", "(GMT+01:00 + DST) Amsterdam, Berlin, Bern, Rome, Stockholm, Vienna", "(GMT+01:00 + DST) Belgrade, Bratislava, Budapest, Ljubljana, Prague", "(GMT+01:00 + DST) Brussels, Copenhagen, Madrid, Paris", "(GMT+01:00 + DST) Sarajevo, Skopje, Warsaw, Zagreb", "(GMT+01:00) West Central Africa", "(GMT+02:00 + DST) Amman", "(GMT+02:00 + DST) Athens, Bucharest, Istanbul", "(GMT+02:00 + DST) Cairo", "(GMT+02:00) Harare, Pretoria", "(GMT+02:00 + DST) Helsinki, Kyiv, Riga, Tallin", "(GMT+02:00 + DST) Jerusalem", "(GMT+02:00 + DST) Windhoek", "(GMT+03:00) Kuwait, Riyadh, Baghdad", "(GMT+03:00) Moscow, St. Petersburg, Volgograd", "(GMT+03:30) Tehran", "(GMT+04:00) Abu Dhabi, Muscat, Tbilsi", "(GMT+04:30) Kabul", "(GMT+05:00) Islamabad, Karachi, Tashkent", "(GMT+05:30) Chennai, Kokata, Mumbai, New Delhi", "(GMT+06:00) Almaty, Novosibirsk", "(GMT+07:00) Bangkok, Hanoi, Jakarta", "(GMT+07:00) Krasnoyarsk", "(GMT+08:00) Beijing, Chongqing, Hong Kong, Urumqi", "(GMT+08:00) Kuala Lumpur, Singapore", "(GMT+08:00) Irkutsk, Perth, Taipei, Ulaan Bataar", "(GMT+09:00) Osaka, Sapporo, Seoul, Tokyo, Yakutsk", "(GMT+09:30) Adelaide", "(GMT+09:30) Darwin", "(GMT+10:00) Brisbane", "(GMT+10:00) Canberra, Hobart, Melbourne, Sydney", "(GMT+10:00) Guam, Port Moresby, Vladivostok", "(GMT+11:00) Magadan, Solomon Is., New Caledonia", "(GMT+12:00) Auckland, Wllington", "(GMT+12:00) Fiji, Kamchatka, Marshall Is."]
    
    let m_arrTimezoneValues = [ -12, -11, -10, -9, -8, -7, -6, -5, -4, -3.5, -3, -2, -1, 0, 0, 1, 1, 1, 1, 1, 2, 2, 2, 2, 2, 2, 2, 3, 3, 3.5, 4, 4.5, 5, 5.5, 6, 7, 7, 8, 8, 8, 9, 9.5, 9.5, 10, 10, 10, 11, 12, 12 ]

    
    var m_iNightAlertTimeZoneIndex : Int! = 0
    
    // Location
    @IBOutlet weak var location_enabled_label_outlet: UILabel!
    @IBOutlet weak var location_enabled_switch_outlet: UISwitch!
    @IBOutlet weak var door_radius_button_outlet: UIButton!
    
    //m_arrTimezoneLabel
    
    let m_arrRadiusLabels = ["15 meters", "25 meters", "35 meters", "50 meters", "75 meters", "100 meters", "200 meters", "500 meters"]
    let m_arrRadiusValues = [15, 25, 35, 50, 75, 100, 200, 500]
    var m_iRadiusLabelIndex : Int = 0
    
    @IBOutlet weak var map_outlet: MKMapView!
    
    var m_pCircleOverlay : MKCircle!
    var m_pLineOverlay : MKPolyline!
    var m_pDoorAnnotation : DoorLocationAnnotation!
    var m_pRadiusAnnotation : MKPointAnnotation!
    var m_bFirstTimeLocated : Bool! = false
    
    var m_pDoorModel : DoorModel!
    
    func refresh(sender:AnyObject)
    {
        // Updating your data here...
        m_pDoorModel?.loadSettingsFromDevice()
        
        NSTimer.scheduledTimerWithTimeInterval(2.0, target: self, selector:#selector(NotificationsTVC.UpdateAlertsUIData), userInfo: nil, repeats: false)
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.navigationController!.navigationBar.hidden = false
        
        map_outlet.delegate = self
        
        self.m_pCircleOverlay = nil
        
        var uilgr = UILongPressGestureRecognizer(target: self, action: "setDoorLocationFromGesture:")
        uilgr.minimumPressDuration = 1.0
        map_outlet.addGestureRecognizer(uilgr)
        
        self.refreshControl?.addTarget(self, action: #selector(NotificationsTVC.refresh(_:)), forControlEvents: UIControlEvents.ValueChanged)
    }
    
    func UpdateAlertsUIData()
    {
        if self.m_pDoorModel != nil
        {
            if( self.m_pDoorModel?.m_bNotifyOnRebootEnabled == true )
            {
                self.notify_on_reboot_outlet.setOn(true, animated: false)
            }
            else
            {
                self.notify_on_reboot_outlet.setOn(false, animated: false)
            }
        
            if( self.m_pDoorModel?.m_bNotifyOnOpenEnabled == true )
            {
                self.notify_on_open_outlet.setOn(true, animated: false)
            }
            else
            {
                self.notify_on_open_outlet.setOn(false, animated: false)
            }
            
            if( self.m_pDoorModel?.m_bNotifyOnCloseEnabled == true )
            {
                self.notify_on_close_outlet.setOn(true, animated: false)
            }
            else
            {
                self.notify_on_close_outlet.setOn(false, animated: false)
            }
            
            if( self.m_pDoorModel?.m_bNotifyWhenOnlineEnabled == true )
            {
                self.notify_on_online_outlet.setOn(true, animated: false)
            }
            else
            {
                self.notify_on_online_outlet.setOn(false, animated: false)
            }
            
            if( self.m_pDoorModel?.m_bNotifyOnStoppedEnabled == true )
            {
                self.notify_on_stopped_outlet.setOn(true, animated: false)
            }
            else
            {
                self.notify_on_stopped_outlet.setOn(false, animated: false)
            }
            
            if( self.m_pDoorModel?.m_bNotifyOnDisconnectEnabled == true )
            {
                self.notify_on_disconnect_outlet.setOn(true, animated: false)
            }
            else
            {
                self.notify_on_disconnect_outlet.setOn(false, animated: false)
            }
            
            if( self.m_pDoorModel?.m_fTimeoutValue != nil && self.m_pDoorModel?.m_fTimeoutValue != 0 )
            {
                self.door_motion_outlet.setOn(true, animated: false)
                
                for index in 0...(self.m_arrTimeoutAlertValues.count - 1)
                {
                    if self.m_arrTimeoutAlertValues[index] == self.m_pDoorModel?.m_fTimeoutValue
                    {
                        self.m_iTimeoutAlertIndex = index
                        self.timeout_value_outlet.setTitle(m_arrTimeoutAlertLabels[index], forState: UIControlState.Normal)
                        break
                    }
                }
            }
            else
            {
                self.door_motion_outlet.setOn(false, animated: false)
            }
            
            // Night Alerts
            if( self.m_pDoorModel?.m_iNightAlertStartValue == self.m_pDoorModel?.m_iNightAlertEndValue )
            {
                night_alerts_enabled_outlet.setOn(false, animated: false)
            }
            else
            {
                night_alerts_enabled_outlet.setOn(true, animated: false)
            }
            
            ///////////////////////////////////////////////////////////////////////////////////////////////////////
            //Night Alert TimeZone
            if( self.m_pDoorModel!.m_pNightAlertTimeZone != nil )
            {
                //print(self.m_pDoorModel!.m_pNightAlertTimeZone.abbreviation)
                //print(self.m_pDoorModel!.m_pNightAlertTimeZone.name)
                //print(self.m_pDoorModel!.m_pNightAlertTimeZone.secondsFromGMT)
                //print(self.m_pDoorModel!.m_pNightAlertTimeZone.description)
                
                let fOffset = Double( (self.m_pDoorModel!.m_pNightAlertTimeZone!.secondsFromGMT / 60 / 60) - 1)
            
                var iIndex = 0
                
                //            var arrTimezonesAvailable = Array(NSTimeZone.abbreviationDictionary().values)
                //            let arrTimezonesAbbreviations = Array(NSTimeZone.abbreviationDictionary().keys)

//                for pAbbreviation in arrTimezonesAbbreviations
//                {
//                    let timezone = NSTimeZone(abbreviation: pAbbreviation)
//                    
//                    let fGMTOffset = Double( (timezone!.secondsFromGMT / 60 / 60) - 1)
//                    
//                    if( fOffset == fGMTOffset )
//                    {
//                        self.m_iNightAlertTimeZoneIndex = iIndex
//                        break
//                    }
//                    else if( m_pDoorModel!.m_pNightAlertTimeZone.abbreviation! == pAbbreviation )
//                    {
//                        self.m_iNightAlertTimeZoneIndex = iIndex
//                        break
//                    }
//                    
//                    iIndex += 1
//                }
                
                iIndex = 0
                for value in m_arrTimezoneValues
                {
                    if( value == fOffset )
                    {
                        self.m_iNightAlertTimeZoneIndex = iIndex
                        
                        night_timezone_button_outlet.setTitle(self.m_arrTimezoneLabels[self.m_iNightAlertTimeZoneIndex], forState: UIControlState.Normal)
                        
                        break
                    }
                    
                    iIndex += 1
                }
                
//                if( self.m_iNightAlertTimeZoneIndex < arrTimezonesAvailable.count )
//                {
//                    let strTimezoneLabel = arrTimezonesAvailable[self.m_iNightAlertTimeZoneIndex] + " (" + self.m_pDoorModel!.m_pNightAlertTimeZone.abbreviation! + ")"
//                
//                    night_timezone_button_outlet.setTitle(strTimezoneLabel, forState: UIControlState.Normal)
//                }
            }
            ///////////////////////////////////////////////////////////////////////////////////////////////////////
            
            let dateFormatter = NSDateFormatter()
            dateFormatter.locale = NSLocale(localeIdentifier: "us-en")
            dateFormatter.dateFormat = "hh:mm a"
            
            if(self.m_pDoorModel!.m_pNightAlertStartTime != nil )
            {
                let strFormattedDate = dateFormatter.stringFromDate(self.m_pDoorModel!.m_pNightAlertStartTime)
                self.night_from_button_outlet.setTitle(strFormattedDate, forState: UIControlState.Normal)
            }
            
            if(self.m_pDoorModel!.m_pNightAlertEndTime != nil )
            {
                let strFormattedDate = dateFormatter.stringFromDate(self.m_pDoorModel!.m_pNightAlertEndTime)
                self.night_to_button_outlet.setTitle(strFormattedDate, forState: UIControlState.Normal)
            }
            
            // Location Alerts
            if( self.m_pDoorModel?.m_bNotifyOnDepartureEnabled == true && self.m_pDoorModel?.m_pDoorLocation != nil )
            {
                self.location_enabled_switch_outlet.setOn(true, animated: true)
                
                self.setDoorLocationOnMap((self.m_pDoorModel?.m_pDoorLocation)!)
            }
            else
            {
                self.location_enabled_switch_outlet.setOn(false, animated: true)
                
                self.door_radius_button_outlet.setTitle("", forState: UIControlState.Normal)
            }
        }
        
        self.tableView.reloadData()
        self.refreshControl?.endRefreshing()
    }
    
    override func viewDidAppear(animated: Bool)
    {
        self.navigationController!.navigationBar.hidden = false
        
        self.UpdateAlertsUIData()
    }
    
    @IBAction func enableRebootAlertAction(sender: AnyObject)
    {
        if( notify_on_reboot_outlet.on )
        {
            m_pDoorModel?.ToggleRebootAlerts(true)
            
            let pAppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            if(pAppDelegate.m_strAPNSToken != nil)
            {
                self.m_pDoorModel!.PostDoorDataToWebserver(pAppDelegate.m_strAPNSToken!)
            }
        }
        else
        {
            m_pDoorModel?.ToggleRebootAlerts(false)
            
            self.CheckAlertSettingsStatus()
        }
    }
    
    @IBAction func enableOnlineAlertAction(sender: AnyObject)
    {
        if( notify_on_online_outlet.on )
        {
            m_pDoorModel?.ToggleOnlineAlerts(true)
            
            let pAppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            if(pAppDelegate.m_strAPNSToken != nil)
            {
                self.m_pDoorModel!.PostDoorDataToWebserver(pAppDelegate.m_strAPNSToken!)
            }
        }
        else
        {
            m_pDoorModel?.ToggleOnlineAlerts(false)
            
            self.CheckAlertSettingsStatus()
        }
    }
    
    @IBAction func enableOpenAlertAction(sender: AnyObject)
    {
        if( notify_on_open_outlet.on )
        {
            m_pDoorModel?.ToggleOpenAlerts(true)
            
            let pAppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            if(pAppDelegate.m_strAPNSToken != nil)
            {
                self.m_pDoorModel!.PostDoorDataToWebserver(pAppDelegate.m_strAPNSToken!)
            }
        }
        else
        {
            m_pDoorModel?.ToggleOpenAlerts(false)
            
            self.CheckAlertSettingsStatus()
        }
    }
    
    @IBAction func enableClosedAlertAction(sender: AnyObject)
    {
        if( notify_on_close_outlet.on )
        {
            m_pDoorModel?.ToggleClosedAlerts(true)
            
            let pAppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            if(pAppDelegate.m_strAPNSToken != nil)
            {
                self.m_pDoorModel!.PostDoorDataToWebserver(pAppDelegate.m_strAPNSToken!)
            }
        }
        else
        {
            m_pDoorModel?.ToggleClosedAlerts(false)
            
            self.CheckAlertSettingsStatus()
        }
    }
    
    @IBAction func enableStoppedAlertAction(sender: AnyObject)
    {
        if( notify_on_stopped_outlet.on )
        {
            m_pDoorModel?.ToggleStoppedAlerts(true)
            
            let pAppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            if(pAppDelegate.m_strAPNSToken != nil)
            {
                self.m_pDoorModel!.PostDoorDataToWebserver(pAppDelegate.m_strAPNSToken!)
            }
        }
        else
        {
            m_pDoorModel?.ToggleStoppedAlerts(false)
            
            self.CheckAlertSettingsStatus()
        }
    }
   
    @IBAction func enableOfflineAlertAction(sender: AnyObject)
    {
        if( notify_on_disconnect_outlet.on )
        {
            m_pDoorModel?.ToggleDisconnectedAlerts(true)
            
            let pAppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            if(pAppDelegate.m_strAPNSToken != nil)
            {
                self.m_pDoorModel!.PostDoorDataToWebserver(pAppDelegate.m_strAPNSToken!)
            }
        }
        else
        {
            m_pDoorModel?.ToggleDisconnectedAlerts(false)
            
            self.CheckAlertSettingsStatus()
        }
    }
    
    func CheckAlertSettingsStatus()
    {
        if( self.m_pDoorModel?.m_bNotifyOnRebootEnabled == false && self.m_pDoorModel?.m_bNotifyOnOpenEnabled == false && self.m_pDoorModel?.m_bNotifyOnCloseEnabled == false && self.m_pDoorModel?.m_bNotifyWhenOnlineEnabled == false && self.m_pDoorModel?.m_bNotifyOnStoppedEnabled == false && self.m_pDoorModel?.m_bNotifyOnDisconnectEnabled == false)
        {
            let pAppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            if(pAppDelegate.m_strAPNSToken != nil)
            {
                self.m_pDoorModel!.PostDisableDeviceAlertsToWebserver(pAppDelegate.m_strAPNSToken!)
            }
        }
    }
    
    @IBAction func backButtonAction()
    {
        self.navigationController!.navigationBar.hidden = true    
    }
    
    @IBAction func timeoutAlertSwitchOutlet(sender: AnyObject)
    {
        if( door_motion_outlet.on )
        {
            self.m_pDoorModel?.SetTimeoutAlert(self.m_arrTimeoutAlertValues[self.m_iTimeoutAlertIndex!])
            
            let pAppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            if(pAppDelegate.m_strAPNSToken != nil)
            {
                self.m_pDoorModel!.PostDoorDataToWebserver(pAppDelegate.m_strAPNSToken!)
            }
        }
        else
        {
            m_pDoorModel?.SetTimeoutAlert(0)
        }
    }
    
    @IBAction func timeoutAlertButtonAction(sender: AnyObject)
    {
        ActionSheetStringPicker.showPickerWithTitle("Timeout Alert", rows: m_arrTimeoutAlertLabels, initialSelection: self.m_iTimeoutAlertIndex!, doneBlock: {
            picker, value, index in
            
//            print("value = \(value)")
//            print("index = \(index)")
//            print("picker = \(picker)")
            
            let pText = String(index)
            sender.setTitle(pText, forState: UIControlState.Normal )
            
            self.m_iTimeoutAlertIndex = Int(value)
            self.m_pDoorModel?.SetTimeoutAlert(self.m_arrTimeoutAlertValues[self.m_iTimeoutAlertIndex!])
            
            return
            }, cancelBlock: { ActionStringCancelBlock in return }, origin: sender)
    }
    
    @IBAction func nightAlertsButtonAction(sender: AnyObject)
    {
        if( night_alerts_enabled_outlet.on )
        {
            //Default times when first enabled
            self.m_pDoorModel?.SetNightAlerts(1330, p_iEnd: 360)
            
            let pAppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            if(pAppDelegate.m_strAPNSToken != nil)
            {
                self.m_pDoorModel!.PostDoorDataToWebserver(pAppDelegate.m_strAPNSToken!)
            }
        }
        else
        {
            //Times are equal, so night alerts will be disabled
            m_pDoorModel?.SetNightAlerts(0, p_iEnd: 0)
        }
    }
    
    @IBAction func nightAlertsFromButtonAction(sender: AnyObject)
    {
        ActionSheetDatePicker.showPickerWithTitle("From", datePickerMode: UIDatePickerMode.Time, selectedDate: self.m_pDoorModel!.m_pNightAlertStartTime, doneBlock: {
            picker, value, index in
            
            //print("value = \(value)")
            //print("index = \(index)")
            //print("picker = \(picker)")
            
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss zzzz"
            let date = dateFormatter.dateFromString(String(value))
            print(date!)
            
            let dateFormatter02 = NSDateFormatter()
            dateFormatter02.locale = NSLocale(localeIdentifier: "us-en")
            dateFormatter02.dateFormat = "hh:mm a"
            
            let strFormattedDate = dateFormatter02.stringFromDate(date!)
            print(strFormattedDate)
            
            sender.setTitle(strFormattedDate, forState: UIControlState.Normal )
            
            self.m_pDoorModel!.SetNightAlertStart(date!)
            
            return
            }, cancelBlock: { ActionDateCancelBlock in return }, origin: sender as! UIView)
    }
    
    @IBAction func nightAlertsToButtonAction(sender: AnyObject)
    {
        let pTimePick = ActionSheetDatePicker()
        pTimePick.locale = NSLocale(localeIdentifier: "en-US")
        
        ActionSheetDatePicker.showPickerWithTitle("To", datePickerMode: UIDatePickerMode.Time, selectedDate: self.m_pDoorModel!.m_pNightAlertEndTime, doneBlock:
        {
            picker, value, index in
            
            //print("value = \(value)")
            //print("index = \(index)")
            //print("picker = \(picker)")
            
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss zzzz"
            let date = dateFormatter.dateFromString(String(value))
            //print(date!)
            
            let dateFormatter02 = NSDateFormatter()
            dateFormatter02.locale = NSLocale(localeIdentifier: "us-en")
            dateFormatter02.dateFormat = "hh:mm a"
            
            let strFormattedDate = dateFormatter02.stringFromDate(date!)
            //print(strFormattedDate)
            
            sender.setTitle(strFormattedDate, forState: UIControlState.Normal )
            
            self.m_pDoorModel!.SetNightAlertEnd(date!)
            
            return
            }, cancelBlock: { ActionDateCancelBlock in return }, origin: sender as! UIView)
    }
    
    @IBAction func setTimezoneButtonAction(sender: AnyObject)
    {
        ActionSheetStringPicker.showPickerWithTitle("TimeZone", rows: m_arrTimezoneLabels, initialSelection: self.m_iNightAlertTimeZoneIndex, doneBlock: {
            picker, value, index in
            
//            print("value = \(value)")
//            print("index = \(index)")
//            print("picker = \(picker)")
            
            let pText = String(index)
            sender.setTitle(pText, forState: UIControlState.Normal )
            
            
            ///////////////////////////////////////////////////////////////////////////////////////////////////////
            //Set TimeZone data on model
            self.m_iNightAlertTimeZoneIndex = Int(value)
            
            if( self.m_iNightAlertTimeZoneIndex >= 0 && self.m_iNightAlertTimeZoneIndex < self.m_arrTimezoneValues.count)
            {
                let secondsFromValue = Int(self.m_arrTimezoneValues[self.m_iNightAlertTimeZoneIndex])
                let pNewTimeZone = NSTimeZone(forSecondsFromGMT: secondsFromValue * 60 * 60)
                
                print(pNewTimeZone.abbreviation)
                print(pNewTimeZone.description)
                print(pNewTimeZone.daylightSavingTimeOffset)
                
                self.m_pDoorModel!.SetNightAlertsTimeZone(pNewTimeZone)
            }

            //let arrTimezonesAbbreviations = Array(NSTimeZone.abbreviationDictionary().keys)
//            let arrTimezonesAbbreviations = Array(NSTimeZone.abbreviationDictionary().keys)
//            let pNewTimeZone = NSTimeZone(abbreviation: arrTimezonesAbbreviations[self.m_iNightAlertTimeZoneIndex])!
//            self.m_pDoorModel!.SetNightAlertsTimeZone(pNewTimeZone)
            ///////////////////////////////////////////////////////////////////////////////////////////////////////
            
            return
            }, cancelBlock: { ActionStringCancelBlock in return }, origin: sender)
    }
    
    @IBAction func enabledLocationNotificationsAction(sender: AnyObject)
    {
        if( location_enabled_switch_outlet.on )
        {
            m_pDoorModel?.EnabledLocationRadiusForDoor(true)
            
            let pAppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            pAppDelegate.AuthorizeLocationTracking()
        }
        else
        {
            m_pDoorModel?.EnabledLocationRadiusForDoor(false)
            
            let allAnnotations = self.map_outlet.annotations
            self.map_outlet.removeAnnotations(allAnnotations)
            
            if m_pCircleOverlay != nil
            {
                map_outlet.removeOverlay(m_pCircleOverlay!)
                m_pCircleOverlay = nil
            }
            
            if( m_pLineOverlay != nil )
            {
                self.map_outlet.removeOverlay(m_pLineOverlay!)
                m_pLineOverlay = nil
            }
            
            door_radius_button_outlet.setTitle("", forState: UIControlState.Normal)
            
            self.m_pDoorModel!.m_pDoorLocation = nil
        }
    }
    
    @IBAction func setDoorRadiusButtonAction(sender: AnyObject)
    {
        ActionSheetStringPicker.showPickerWithTitle("Door Radius", rows: m_arrRadiusLabels, initialSelection: self.m_iRadiusLabelIndex, doneBlock: {
            picker, value, index in
            
//            print("value = \(value)")
//            print("index = \(index)")
//            print("picker = \(picker)")
            
            let pText = String(index)
            sender.setTitle(pText, forState: UIControlState.Normal )
            
            self.m_iRadiusLabelIndex = Int(value)
            self.m_pDoorModel?.SetDoorRadius(Double(self.m_arrRadiusValues[self.m_iRadiusLabelIndex]))
            
            ///////////////////////////////////////////////////////////
            //Update door radius
            if( self.m_pDoorModel.m_pDoorLocation != nil )
            {
                self.addRadiusCircle(self.m_pDoorModel.m_pDoorLocation!, p_dRadius: self.m_pDoorModel.m_dDepartureRadius!)
                
                var mapRegion = MKCoordinateRegion()
                mapRegion.center = self.m_pDoorModel.m_pDoorLocation!.coordinate
                mapRegion.span = MKCoordinateSpanMake(0.02, 0.02)
                self.map_outlet.setRegion(mapRegion, animated: true)
                
                let radiusCoords = self.locationWithBearing(90.0, distanceMeters: self.m_pDoorModel.m_dDepartureRadius!, origin: self.m_pDoorModel.m_pDoorLocation!.coordinate)
                let radiusAnnotation = MKPointAnnotation()
                radiusAnnotation.coordinate = radiusCoords
                radiusAnnotation.title = "Radius"
                
                if( self.m_pRadiusAnnotation != nil )
                {
                    self.map_outlet.removeAnnotation(self.m_pRadiusAnnotation!)
                }
                self.map_outlet.addAnnotation(radiusAnnotation)
                self.m_pRadiusAnnotation = radiusAnnotation
                
                self.addRadiusLineToMap(self.m_pDoorModel.m_pDoorLocation!.coordinate, p_pEndCoord: radiusCoords)
            }
            ///////////////////////////////////////////////////////////
            
            return
            }, cancelBlock: { ActionStringCancelBlock in return }, origin: sender)
    }
    
    func addRadiusCircle(location: CLLocation, p_dRadius: Double)
    {
        if m_pCircleOverlay != nil
        {
            map_outlet.removeOverlay(m_pCircleOverlay!)
        }
        
        m_pCircleOverlay = MKCircle(centerCoordinate: location.coordinate, radius: p_dRadius as CLLocationDistance)
        self.map_outlet.addOverlay(m_pCircleOverlay!)
    }
    
    func mapView(mapView: MKMapView!, rendererForOverlay overlay: MKOverlay!) -> MKOverlayRenderer!
    {
        if overlay is MKCircle
        {
            let circle = MKCircleRenderer(overlay: overlay)
            circle.strokeColor = UIColor.redColor()
            circle.fillColor = UIColor(red: 255, green: 0, blue: 0, alpha: 0.1)
            circle.lineWidth = 1
            return circle
        }
        else if overlay is MKPolyline
        {
            let pr = MKPolylineRenderer(overlay: overlay);
            pr.strokeColor = UIColor.blueColor()
            pr.lineWidth = 3;
            return pr;
        }
        else
        {
            return nil
        }
    }
    
    func mapView(mapView: MKMapView,
        didUpdateUserLocation userLocation: MKUserLocation)
    {
        if( self.m_bFirstTimeLocated == false && (self.m_pDoorModel.m_pDoorLocation == nil || self.m_pDoorModel.m_bNotifyOnDepartureEnabled == false) )
        {
            m_bFirstTimeLocated = true
        
            var mapRegion = MKCoordinateRegion();
            mapRegion.center = map_outlet.userLocation.coordinate;
            mapRegion.span = MKCoordinateSpanMake(0.02, 0.02);
            map_outlet.setRegion(mapRegion, animated: true)
        }
    }
    
    func mapView(mapView: MKMapView,
        didAddAnnotationViews views: [MKAnnotationView])
    {
        print("Annotation Added to map view")
    }
    
    func setDoorLocationFromGesture(gestureRecognizer:UIGestureRecognizer)
    {
        if gestureRecognizer.state == UIGestureRecognizerState.Began
        {
            let touchPoint = gestureRecognizer.locationInView(map_outlet)
            
            let newCoordinates = map_outlet.convertPoint(touchPoint, toCoordinateFromView: map_outlet)
            let newLocation = CLLocation(latitude: newCoordinates.latitude, longitude: newCoordinates.longitude)
            
            m_pDoorModel?.EnabledLocationRadiusForDoor(true)
            m_pDoorModel?.SetDoorLocation(newLocation)
            
            if( self.m_pDoorModel.m_dDepartureRadius == nil || self.m_pDoorModel.m_dDepartureRadius == 0.0 )
            {
                m_pDoorModel?.SetDoorRadius(500)
            }
            
            self.setDoorLocationOnMap(newLocation)
            
//            CLGeocoder().reverseGeocodeLocation(CLLocation(latitude: newCoordinates.latitude, longitude: newCoordinates.longitude), completionHandler: {(placemarks, error) -> Void in
//                if error != nil {
//                    //println("Reverse geocoder failed with error" + error.localizedDescription)
//                    return
//                }
//                
//                if placemarks!.count > 0
//                {
//                    let pm = placemarks![0] as! CLPlacemark
//                    
//                    // not all places have thoroughfare & subThoroughfare so validate those values
//                    annotation.title = pm.thoroughfare! + ", " + pm.subThoroughfare!
//                    annotation.subtitle = pm.subLocality
//                    self.map_outlet.addAnnotation(annotation)
//                    //println(pm)
//                }
//                else
//                {
//                    annotation.title = "Unknown Place"
//                    self.map_outlet.addAnnotation(annotation)
//                    //println("Problem with the data received from geocoder")
//                }
//                //places.append(["name":annotation.title,"latitude":"\(newCoordinates.latitude)","longitude":"\(newCoordinates.longitude)"])
//            })
        }
    }
    
    func setDoorLocationOnMap(p_pNewLocation : CLLocation)
    {
        let newCoordinates = CLLocationCoordinate2D(latitude: p_pNewLocation.coordinate.latitude, longitude: p_pNewLocation.coordinate.longitude)
        let annotation = DoorLocationAnnotation()
        annotation.coordinate = newCoordinates
        annotation.title = self.m_pDoorModel?.m_strName
        
        self.m_pDoorAnnotation = annotation
        
        let allAnnotations = self.map_outlet.annotations
        self.map_outlet.removeAnnotations(allAnnotations)
        
        self.map_outlet.addAnnotation(annotation)
        
        self.addRadiusCircle(p_pNewLocation, p_dRadius: self.m_pDoorModel.m_dDepartureRadius!)
        
        location_enabled_switch_outlet.setOn(true, animated: true)
        
        let strRadiusLabelText = String(Int(self.m_pDoorModel.m_dDepartureRadius!)) + " meters"
        door_radius_button_outlet.setTitle(strRadiusLabelText, forState: UIControlState.Normal)
        
        var mapRegion = MKCoordinateRegion()
        mapRegion.center = p_pNewLocation.coordinate
        mapRegion.span = MKCoordinateSpanMake(0.02, 0.02)
        map_outlet.setRegion(mapRegion, animated: true)
        
        let radiusCoords = self.locationWithBearing(90.0, distanceMeters: self.m_pDoorModel.m_dDepartureRadius!, origin: newCoordinates)
        let radiusAnnotation = MKPointAnnotation()
        radiusAnnotation.coordinate = radiusCoords
        radiusAnnotation.title = "Radius"
        self.map_outlet.addAnnotation(radiusAnnotation)
        self.m_pRadiusAnnotation = radiusAnnotation
        
        self.addRadiusLineToMap(newCoordinates, p_pEndCoord: radiusCoords)
    }
    
    func locationWithBearing(bearing:Double, distanceMeters:Double, origin:CLLocationCoordinate2D) -> CLLocationCoordinate2D {
        let distRadians = distanceMeters / (6372797.6)
        
        var rbearing = bearing * M_PI / 180.0
        
        let lat1 = origin.latitude * M_PI / 180
        let lon1 = origin.longitude * M_PI / 180
        
        let lat2 = asin(sin(lat1) * cos(distRadians) + cos(lat1) * sin(distRadians) * cos(rbearing))
        let lon2 = lon1 + atan2(sin(rbearing) * sin(distRadians) * cos(lat1), cos(distRadians) - sin(lat1) * sin(lat2))
        
        return CLLocationCoordinate2D(latitude: lat2 * 180 / M_PI, longitude: lon2 * 180 / M_PI)
    }
    
    func addRadiusLineToMap(p_pStartCoord : CLLocationCoordinate2D, p_pEndCoord : CLLocationCoordinate2D)
    {
        var lineCords: [CLLocationCoordinate2D] = []
        
        //let coordinatesToAppend = CLLocationCoordinate2D(latitude: p_pStartCoord.latitude, longitude: newCoordinates.longitude)
        lineCords.append(p_pStartCoord)
        
        lineCords.append(p_pEndCoord)
        
        if( m_pLineOverlay != nil )
        {
            self.map_outlet.removeOverlay(m_pLineOverlay!)
        }
        m_pLineOverlay = MKPolyline(coordinates: &lineCords, count: lineCords.count)
        
        self.map_outlet.addOverlay(m_pLineOverlay!)
    }
    
    func mapView(p_mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView?
    {
        if annotation is DoorLocationAnnotation
        {
            let pinAnnotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "myPin")
            
            pinAnnotationView.pinColor = .Green
            pinAnnotationView.draggable = false
            pinAnnotationView.canShowCallout = true
            pinAnnotationView.animatesDrop = true
            
            return pinAnnotationView
        }
        
        if annotation is MKPointAnnotation
        {
            let pinAnnotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "myPin")
            
            pinAnnotationView.pinTintColor = UIColor.blueColor()
            pinAnnotationView.draggable = true
            pinAnnotationView.canShowCallout = true
            pinAnnotationView.animatesDrop = true
            
            return pinAnnotationView
        }
        
        return nil
    }
    
    func mapView(mapView: MKMapView, didSelectAnnotationView view: MKAnnotationView)
    {
        //print("Selected annotation: " + (view.annotation?.title!)!)
        
        if view.annotation is MKUserLocation
        {
            let newLocation = CLLocation(latitude: view.annotation!.coordinate.latitude, longitude: view.annotation!.coordinate.longitude)
            
            m_pDoorModel?.EnabledLocationRadiusForDoor(true)
            m_pDoorModel?.SetDoorLocation(newLocation)
            
            if( self.m_pDoorModel.m_dDepartureRadius == nil || self.m_pDoorModel.m_dDepartureRadius == 0.0 )
            {
                m_pDoorModel?.SetDoorRadius(500)
            }
            
            self.setDoorLocationOnMap(newLocation)
        }
    }
    
    func mapView(p_mapView: MKMapView, annotationView view: MKAnnotationView,didChangeDragState newState: MKAnnotationViewDragState, fromOldState oldState: MKAnnotationViewDragState)
    {
        //print("Changing State" + String(newState))
        
        if( newState == MKAnnotationViewDragState.Ending )
        {
            self.addRadiusLineToMap((m_pDoorAnnotation?.coordinate)!, p_pEndCoord: (view.annotation?.coordinate)!)
            
            let location = CLLocation(latitude: (self.m_pDoorAnnotation?.coordinate.latitude)!, longitude: (self.m_pDoorAnnotation?.coordinate.longitude)!)
            let radiusLocation = CLLocation(latitude: (view.annotation?.coordinate.latitude)!, longitude: (view.annotation?.coordinate.longitude)!)
            
            self.m_pDoorModel.SetDoorRadius(location.distanceFromLocation(radiusLocation))
            door_radius_button_outlet.setTitle(String(Int(self.m_pDoorModel.m_dDepartureRadius!)) + " meters", forState: UIControlState.Normal)
            
            self.addRadiusCircle(location, p_dRadius: self.m_pDoorModel.m_dDepartureRadius!)
        }
    }
}
