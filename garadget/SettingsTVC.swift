//
//  SettingsTVC.swift
//  garadget
//
//  Created by Stephen Madsen on 3/23/16.
//  Copyright © 2016 Stephen Madsen. All rights reserved.
//
import UIKit
class SettingsTVC: UITableViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource
{
    var m_pDoorModel : DoorModel?
    
    var m_pUpdateUITimer : NSTimer?
    
    // Door Outlets
    @IBOutlet weak var m_visible_outlet: UISwitch!
    
    @IBOutlet weak var m_id_outlet: UILabel!
    
    @IBOutlet weak var m_name_outlet: UILabel!
    
    @IBOutlet weak var m_name_input_outlet: UITextField!
    
    @IBOutlet weak var m_status_outlet: UILabel!
    
    @IBOutlet weak var m_lastcontact_outlet: UILabel!
    
    @IBOutlet weak var m_firmware_outlet: UILabel!
    
    // WIFI Radio Outlets
    @IBOutlet weak var m_wifi_ssid_outlet: UILabel!
    
    @IBOutlet weak var m_wifi_strength_outlet: UILabel!
    
    @IBOutlet weak var m_wifi_ip_outlet: UILabel!
    
    @IBOutlet weak var m_wifi_gateway_outlet: UILabel!
    
    @IBOutlet weak var m_wifi_ipmask_outlet: UILabel!
    
    @IBOutlet weak var m_wifi_mac_outlet: UILabel!
    
    // Sensor Reflection
    @IBOutlet weak var m_sensor_reflection: UILabel!
    
    // Scan Period
    @IBOutlet weak var m_scan_period_outlet: UILabel!
    @IBOutlet weak var m_scan_period_button: UIButton!
    var m_iScanPeriodIndex : Int = 0
    let m_arrScanPeriodLabels = ["Twice Per Second", "Every Second", "Every 2 Seconds", "Every 3 Seconds", "Every 5 Seconds", "Every 10 Seconds", "Every 30 Seconds", "Every Minute"]
    let m_arrScanPeriodList = [0.5, 1, 2, 3, 5, 10, 30, 60]
    
    // Sensor Reads
    @IBOutlet weak var m_sensor_reads_outlet: UILabel!
    @IBOutlet weak var m_sensor_reads_button: UIButton!
    var m_iSensorReadsIndex : Int = 0
    let m_arrSensorReadLabels = ["1", "2", "3", "4", "5"]
    let m_arrSensorReadList = [1, 2, 3, 4, 5]
    
    // Sensor Threshold
    @IBOutlet weak var m_sensor_threshold_outlet: UILabel!
    @IBOutlet weak var m_sensor_threshold_button: UIButton!
    var m_iSensorThresholdIndex : Int = 0
    let m_arrSensorThresholdLabels = ["5", "10", "15", "20", "25", "30", "35", "40", "45", "50", "55", "60", "65", "70", "75", "80"]
    
    ///////////////////////////?
    // Door Outlets
    @IBOutlet weak var m_door_motion_outlet: UILabel!
    @IBOutlet weak var m_door_motion_button: UIButton!
    var m_iDoorMotionIndex : Int = 0
    let m_arrDoorMotionLabels = ["5 Seconds", "6 Seconds", "7 Seconds", "8 Seconds", "9 Seconds", "10 Seconds", "11 Seconds", "12 Seconds", "13 Seconds", "14 Seconds", "15 Seconds", "16 Seconds", "17 Seconds", "18 Seconds", "19 Seconds", "20 Seconds", "21 Seconds", "22 Seconds", "23 Seconds", "24 Seconds", "25 Seconds", "26 Seconds", "27 Seconds", "28 Seconds", "29 Seconds", "30 Seconds"]
    let m_arrDoorMotionVars = [5.0, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30]
    
    @IBAction func doorMotionAction(sender: AnyObject)
    {
        ActionSheetStringPicker.showPickerWithTitle("Door Motion", rows: m_arrDoorMotionLabels, initialSelection: m_iDoorMotionIndex, doneBlock: {
            picker, value, index in
            
            print("value = \(value)")
            print("index = \(index)")
            print("picker = \(picker)")
            
            self.m_iDoorMotionIndex = Int(value)
            
            let pText = String(index)
            sender.setTitle(pText, forState: UIControlState.Normal )
            
            if (self.m_pDoorModel?.m_bConnected == true)
            {
                self.SaveSettingsToDevice(sender)
            }
            
            return
            }, cancelBlock: { ActionStringCancelBlock in return }, origin: sender)
    }
    
    // Relay On Time
    @IBOutlet weak var m_relay_on_time_outlet: UILabel!
    @IBOutlet weak var relay_on_button: UIButton!
    var m_iRelayOnIndex : Int = 0
    let m_arrRelayOnLabels = ["0.3 seconds", "0.4 seconds", "0.5 seconds", "0.7 seconds", "1.0 Seconds"]
    let m_arrRelayOnValues = [0.3, 0.4, 0.5, 0.7, 1.0]
    
    @IBAction func relayOnTimeAction(sender: AnyObject)
    {
        ActionSheetStringPicker.showPickerWithTitle("Relay On Time", rows: ["0.3 seconds", "0.4 seconds", "0.5 seconds", "0.7 seconds", "1.0 Seconds"], initialSelection: m_iRelayOnIndex, doneBlock: {
            picker, value, index in
            
            print("value = \(value)")
            print("index = \(index)")
            print("picker = \(picker)")
            
            self.m_iRelayOnIndex = Int(value)
            
            let pText = String(index)
            sender.setTitle(pText, forState: UIControlState.Normal )
            
            if (self.m_pDoorModel?.m_bConnected == true)
            {
                self.SaveSettingsToDevice(sender)
            }
            
            return
            }, cancelBlock: { ActionStringCancelBlock in return }, origin: sender)
    }
    
    // Relay Off Time
    @IBOutlet weak var m_relay_off_time_outlet: UILabel!
    @IBOutlet weak var relay_off_button: UIButton!
    var m_iRelayOffIndex : Int = 0
    let m_arrRelayOffLabels = ["0.3 seconds", "0.4 seconds", "0.5 seconds", "0.7 seconds", "1.0 Seconds", "1.5 Seconds", "2.0 Seconds", "2.5 Seconds", "3.0 Seconds", "4.0 Seconds", "5.0 Seconds"]
    let m_arrRelayOffValues = [0.3, 0.4, 0.5, 0.7, 1.0, 1.5, 2.0, 2.5, 3.0, 4.0, 5.0]
    
    @IBAction func relayOffTimeAction(sender: AnyObject)
    {
        ActionSheetStringPicker.showPickerWithTitle("Relay Off Time", rows: ["0.3 seconds", "0.4 seconds", "0.5 seconds", "0.7 seconds", "1.0 Seconds", "1.5 Seconds", "2.0 Seconds", "2.5 Seconds", "3.0 Seconds", "4.0 Seconds", "5.0 Seconds"], initialSelection: m_iRelayOffIndex, doneBlock: {
            picker, value, index in
            
            print("value = \(value)")
            print("index = \(index)")
            print("picker = \(picker)")
            
            self.m_iRelayOffIndex = Int(value)
            
            let pText = String(index)
            sender.setTitle(pText, forState: UIControlState.Normal )
            
            if (self.m_pDoorModel?.m_bConnected == true)
            {
                self.SaveSettingsToDevice(sender)
            }
            
            return
            }, cancelBlock: { ActionStringCancelBlock in return }, origin: sender)
    }
    
    func refresh(sender:AnyObject)
    {
        // Updating your data here...
        m_pDoorModel?.loadSettingsFromDevice()
        
        NSTimer.scheduledTimerWithTimeInterval(2.0, target: self, selector:#selector(SettingsTVC.UpdateSettingsUIData), userInfo: nil, repeats: false)
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.navigationController!.navigationBar.hidden = false
        
        m_name_input_outlet.delegate = self
        
        self.refreshControl?.addTarget(self, action: #selector(SettingsTVC.refresh(_:)), forControlEvents: UIControlEvents.ValueChanged)
        
        m_pUpdateUITimer = NSTimer.scheduledTimerWithTimeInterval(2.0, target: self, selector:#selector(SettingsTVC.updateCoreSettingsDataFromServer), userInfo: nil, repeats: true)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if(m_pUpdateUITimer != nil )
        {
            m_pUpdateUITimer?.invalidate()
        }
        
        if (m_pDoorModel?.m_bConnected == true)
        {
            self.SaveSettingsToDevice(sender!)
        }
    }
    
    func updateCoreSettingsDataFromServer()
    {
        m_sensor_reflection.text = m_pDoorModel?.m_strSensorRate;
        
        let fWifiStrength = Double((m_pDoorModel?.m_strWifiSignal)!)
        var s_strength : String
        
        if (fWifiStrength <= -85)
        {
            s_strength = "poor"
        }
        else if (fWifiStrength <= -60)
        {
            s_strength = "good"
        }
        else
        {
            s_strength = "excellent"
        }
        m_wifi_strength_outlet.text = s_strength
        m_wifi_strength_outlet.text = m_wifi_strength_outlet.text! + " (" + (m_pDoorModel?.m_strWifiSignal)! + "dB)"
    }
    
    @IBAction func scanPeriodAction(sender: AnyObject)
    {
        if( self.m_iScanPeriodIndex < self.m_arrScanPeriodLabels.count )
        {
            ActionSheetStringPicker.showPickerWithTitle("Scan Period", rows: m_arrScanPeriodLabels, initialSelection: self.m_iScanPeriodIndex, doneBlock:
                {
                picker, value, index in
                
                print("value = \(value)")
                print("index = \(index)")
                print("picker = \(picker)")
                    
                self.m_iScanPeriodIndex = Int(value)
                self.m_scan_period_button.setTitle(self.m_arrScanPeriodLabels[self.m_iScanPeriodIndex], forState: UIControlState.Normal )
                
                if (self.m_pDoorModel?.m_bConnected == true)
                {
                    self.SaveSettingsToDevice(sender)
                }
                    
                return
                }, cancelBlock: { ActionStringCancelBlock in return }, origin: sender)
        }
    }
    
    @IBAction func scanReadsAction(sender: AnyObject)
    {
        if( self.m_iSensorReadsIndex < self.m_arrSensorReadLabels.count )
        {
        ActionSheetStringPicker.showPickerWithTitle("Sensor Reads", rows: self.m_arrSensorReadLabels, initialSelection: m_iSensorReadsIndex, doneBlock: {
            picker, value, index in
            
            print("value = \(value)")
            print("index = \(index)")
            print("picker = \(picker)")
            
            self.m_iSensorReadsIndex = Int(value)
            
            let pText = String(index)
            self.m_sensor_reads_button.setTitle(pText, forState: UIControlState.Normal )
            
            if (self.m_pDoorModel?.m_bConnected == true)
            {
                self.SaveSettingsToDevice(sender)
            }
            
            return
            }, cancelBlock: { ActionStringCancelBlock in return }, origin: sender)
        }
    }
    
    @IBAction func sensorThresholdAction(sender: AnyObject)
    {
        ActionSheetStringPicker.showPickerWithTitle("Sensor Threshold", rows: self.m_arrSensorThresholdLabels, initialSelection: self.m_iSensorThresholdIndex, doneBlock: {
            picker, value, index in
            
            print("value = \(value)")
            print("index = \(index)")
            print("picker = \(picker)")
            
            self.m_iSensorThresholdIndex = Int(value)
            
            let pText = String(index)
            self.m_sensor_threshold_button.setTitle(pText, forState: UIControlState.Normal )
            
            if (self.m_pDoorModel?.m_bConnected == true)
            {
                self.SaveSettingsToDevice(sender)
            }
            
            return
            }, cancelBlock: { ActionStringCancelBlock in return }, origin: sender)
    }
    
    func UpdateSettingsUIData()
    {
        if self.m_pDoorModel != nil
        {
            ///////////////////////////////////////
            //Door Data
            
//            if m_pDoorModel?.m_bVisibility == true
//            {
//                m_visible_outlet.setOn(true, animated: true)
//            }
//            else
//            {
//                m_visible_outlet.setOn(false, animated: true)
//            }
//            
//            m_visible_outlet.addTarget(self, action: "switchChangedAction:", forControlEvents: UIControlEvents.ValueChanged)
            
            self.m_id_outlet.text = m_pDoorModel?.m_strID
            
            self.m_name_outlet.text = m_pDoorModel?.m_strName
            self.m_name_input_outlet.text = m_pDoorModel?.m_strName
            
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            
            m_lastcontact_outlet.text = dateFormatter.stringFromDate((m_pDoorModel?.m_pLastContact)!)
            
            if m_pDoorModel?.m_strFirmwareVersion == ""
            {
                m_firmware_outlet.text = "?"
            }
            else
            {
                m_firmware_outlet.text = m_pDoorModel?.m_strFirmwareVersion
            }
            
            if (self.m_pDoorModel?.m_bConnected != true)
            {
                m_status_outlet.text = "Offline"
            }
            else
            {
                m_status_outlet.text = m_pDoorModel?.m_strStatus
                
                ///////////////////////////////////////
                //Wifi Data
                if (m_pDoorModel?.m_bConnected == true)
                {
                    m_wifi_ssid_outlet.text = m_pDoorModel?.m_strWifiSsid
                    
                    let fWifiStrength = Double((m_pDoorModel?.m_strWifiSignal)!)
                    var s_strength : String
                    
                    if (fWifiStrength <= -85)
                    {
                        s_strength = "poor"
                    }
                    else if (fWifiStrength <= -60)
                    {
                        s_strength = "good"
                    }
                    else
                    {
                        s_strength = "excellent"
                    }
                    
                    m_wifi_strength_outlet.text = s_strength
                    
                    
                    m_wifi_strength_outlet.text = m_wifi_strength_outlet.text! + " (" + (m_pDoorModel?.m_strWifiSignal)! + "dB)"
                    
                    m_wifi_ip_outlet.text = m_pDoorModel?.m_strWifiIp
                    
                    m_wifi_gateway_outlet.text = m_pDoorModel?.m_strWifiGateway
                    
                    m_wifi_ipmask_outlet.text = m_pDoorModel?.m_strWifiNetmask
                    
                    m_wifi_mac_outlet.text = m_pDoorModel?.m_strWifiMac
                    
                    ///////////////////////////////////////
                    //Sensor Data
                    
                    // Scan Period
                    for index in 0...(self.m_arrScanPeriodList.count - 1)
                    {
                        if self.m_arrScanPeriodList[index] == Double((self.m_pDoorModel?.m_strSensorScanPeriod)!)
                        {
                            self.m_iScanPeriodIndex = index
                            self.m_scan_period_button.setTitle(m_arrScanPeriodLabels[index], forState: UIControlState.Normal)
                            break
                        }
                    }
                    
                    let borderAlpha : CGFloat = 0.2
                    
                    self.m_scan_period_button.layer.cornerRadius = 2;
                    self.m_scan_period_button.layer.borderWidth = 1;
                    self.m_scan_period_button.layer.borderColor = UIColor(white: 0.0, alpha: borderAlpha).CGColor
                    
                    // Sensor Reads
                    for index in 0...(self.m_arrSensorReadList.count - 1)
                    {
                        if self.m_arrSensorReadList[index] == Int((self.m_pDoorModel?.m_strSensorReads)!)
                        {
                            self.m_iSensorReadsIndex = index
                            //self.m_scan_period_button.setTitle(m_arrScanPeriodLabels[index], forState: UIControlState.Normal)
                            break
                        }
                    }
                    
                    m_sensor_reads_button.setTitle(m_pDoorModel?.m_strSensorReads, forState: UIControlState.Normal)
                    self.m_sensor_reads_button.layer.cornerRadius = 2;
                    self.m_sensor_reads_button.layer.borderWidth = 1;
                    self.m_sensor_reads_button.layer.borderColor = UIColor(white: 0.0, alpha: borderAlpha).CGColor
                    
                    // Sensor Threshold
                    for index in 0...(self.m_arrSensorThresholdLabels.count - 1)
                    {
                        if self.m_arrSensorThresholdLabels[index] == self.m_pDoorModel?.m_strSensorThreshhold
                        {
                            self.m_iSensorThresholdIndex = index
                            break
                        }
                    }
                    
                    m_sensor_threshold_button.setTitle(m_pDoorModel?.m_strSensorThreshhold, forState: UIControlState.Normal)
                    self.m_sensor_threshold_button.layer.cornerRadius = 2;
                    self.m_sensor_threshold_button.layer.borderWidth = 1;
                    self.m_sensor_threshold_button.layer.borderColor = UIColor(white: 0.0, alpha: borderAlpha).CGColor
                    
                    // Sensor Reflection
                    m_sensor_reflection.text = m_pDoorModel?.m_strSensorRate;
                    
                    ///////////////////////////////////////
                    // Door Motion
                    for index in 0...(self.m_arrDoorMotionVars.count - 1)
                    {
                        if self.m_arrDoorMotionVars[index] == Double((self.m_pDoorModel?.m_strTimerMotion)!)
                        {
                            self.m_iDoorMotionIndex = index
                            self.m_door_motion_button.setTitle(m_arrDoorMotionLabels[index], forState: UIControlState.Normal)
                            break
                        }
                    }
                    
                    self.m_door_motion_button.layer.cornerRadius = 2;
                    self.m_door_motion_button.layer.borderWidth = 1;
                    self.m_door_motion_button.layer.borderColor = UIColor(white: 0.0, alpha: borderAlpha).CGColor
                    
                    for index in 0...(self.m_arrRelayOnValues.count - 1)
                    {
                        if self.m_arrRelayOnValues[index] == Double((self.m_pDoorModel?.m_strTimerRelayOn)!)
                        {
                            self.m_iRelayOnIndex = index
                            self.relay_on_button.setTitle(m_arrRelayOnLabels[index], forState: UIControlState.Normal)
                            break
                        }
                    }
                    //self.relay_on_button.setTitle(m_pDoorModel?.m_strTimerRelayOn, forState: UIControlState.Normal)
                    self.relay_on_button.layer.cornerRadius = 2;
                    self.relay_on_button.layer.borderWidth = 1;
                    self.relay_on_button.layer.borderColor = UIColor(white: 0.0, alpha: borderAlpha).CGColor
                    
                    for index in 0...(self.m_arrRelayOffValues.count - 1)
                    {
                        if self.m_arrRelayOffValues[index] == Double((self.m_pDoorModel?.m_strTimerRelayOff)!)
                        {
                            self.m_iRelayOffIndex = index
                            self.relay_off_button.setTitle(m_arrRelayOffLabels[index], forState: UIControlState.Normal)
                            break
                        }
                    }
                    //self.relay_off_button.setTitle(m_pDoorModel?.m_strTimerRelayOff, forState: UIControlState.Normal)
                    self.relay_off_button.layer.cornerRadius = 2;
                    self.relay_off_button.layer.borderWidth = 1;
                    self.relay_off_button.layer.borderColor = UIColor(white: 0.0, alpha: borderAlpha).CGColor
                    
                    //m_wifi_reconnect_outlet.text = m_pDoorModel?.m_strTimerWifiReconnect
                }
            }
        }
        
        self.tableView.reloadData()
        self.refreshControl?.endRefreshing()
    }
    
    override func viewDidAppear(animated: Bool)
    {        
        self.navigationController!.navigationBar.hidden = false
        
        self.UpdateSettingsUIData()
    }
    
    func switchChangedAction(switchState: UISwitch)
    {
        let defaults = NSUserDefaults.standardUserDefaults()
        
        if switchState.on
        {
            m_pDoorModel?.m_bVisibility = true
            defaults.setBool(true, forKey: m_pDoorModel!.m_strName! + "doorVisible")
        }
        else
        {
            m_pDoorModel?.m_bVisibility = false
            defaults.setBool(false, forKey: m_pDoorModel!.m_strName! + "doorVisible")
        }
    }
    
    //#### UITextField delegate methods ####
    
    func textFieldDidEndEditing(textField: UITextField)
    {
        
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        
        m_pDoorModel?.renameDevice(textField.text!)
        
        return false
    }
    
    //#### UIPickerView delegate methods ####
    
    // The number of columns of data
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int
    {
        pickerView.subviews.forEach({
            
            $0.hidden = $0.frame.height == 0.5
        })
        
        return 1
    }
    
    // The number of rows of data
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        return 0
    }
    
    // The data to return for the row and component (column) that's being passed in
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        return nil
    }
    
    //#### UINavigationController footer delegate methods ####
    
    //override func tableView(tableView: UITableView,
    //    viewForFooterInSection section: Int) -> UIView?
    //{
//        let sampleView = UIView()
//        sampleView.frame = CGRectMake(730/2, 5, 60, 4);
//        sampleView.backgroundColor = UIColor.blackColor()
//        return sampleView;
    //}
    
    override func tableView(tableView: UITableView,
        heightForFooterInSection section: Int) -> CGFloat
    {
        return 0.0
    }
    
    func SaveSettingsToDevice(sender: AnyObject)
    {
        var __error  = false
        var __params = ""
        
        if( m_pDoorModel?.m_strSensorScanPeriod != nil )
        {
            let iCurrentValue = Double((m_pDoorModel?.m_strSensorScanPeriod)!)
            let iSettingsValue = m_arrScanPeriodList[m_iScanPeriodIndex]
            
            if( iCurrentValue != iSettingsValue )
            {
                if iSettingsValue < 0.5 || iSettingsValue > 60
                {
                    let errorAlertView = UIAlertView(title: "Alert", message:"Sensor Scan Period amount should be between 0.5-60", delegate:self, cancelButtonTitle: "ok")
                    errorAlertView.show()
                    
                    __error = true
                }
                else
                {
                    m_pDoorModel?.m_strSensorScanPeriod = String(iSettingsValue)
                    
                    __params = __params + "rdt=" + String(format: "%.f", iSettingsValue*1000)
                }
            }
        }
        
        if( m_pDoorModel?.m_strSensorReads != nil )
        {
            let iCurrentValue = Int((m_pDoorModel?.m_strSensorReads)!)
            let iSettingsValue = Int(m_sensor_reads_button.titleLabel!.text!)
            
            if( iCurrentValue != iSettingsValue )
            {
                if iSettingsValue < 1 || iSettingsValue > 20
                {
                    let errorAlertView = UIAlertView(title: "Alert", message:"Sendor Reads amount should be between 1-20", delegate:self, cancelButtonTitle: "ok")
                    errorAlertView.show()
                    __error = true
                }
                else
                {
                    m_pDoorModel?.m_strSensorReads = String(iSettingsValue!)
                    
                    if __params != "" {
                        __params = __params + "|srr=" + String(iSettingsValue!)
                    }else{
                        __params = __params + "srr=" + String(iSettingsValue!)
                    }
                }
            }
        }
        
        if( m_pDoorModel?.m_strSensorThreshhold != nil )
        {
            let iCurrentValue = Int((m_pDoorModel?.m_strSensorThreshhold)!)
            let iSettingsValue = Int(m_sensor_threshold_button.titleLabel!.text!)
            
            if( iCurrentValue != iSettingsValue )
            {
                if iSettingsValue < 1 || iSettingsValue > 80
                {
                    let errorAlertView = UIAlertView(title: "Alert", message:"Sensor Threshold amount should be between 1-80", delegate:self, cancelButtonTitle: "ok")
                    errorAlertView.show()
                    __error = true
                }
                else
                {
                    m_pDoorModel?.m_strSensorThreshhold = String(iSettingsValue!)
                    
                    if __params != "" {
                        __params = __params + "|srt=" + String(iSettingsValue!)
                    }else{
                        __params = __params + "srt=" + String(iSettingsValue!)
                    }
                }
            }
        }

        if( m_pDoorModel?.m_strTimerMotion != nil )
        {
            let iCurrentValue = Int((m_pDoorModel?.m_dTimerMotion)!)
            let iSettingsValue = Int(self.m_arrDoorMotionVars[self.m_iDoorMotionIndex])
            
            if( iCurrentValue != iSettingsValue )
            {
                if iSettingsValue < 1 || iSettingsValue > 1200
                {
                    let errorAlertView = UIAlertView(title: "Alert", message:"Door Motion amount should be between 1000-1200000", delegate:self, cancelButtonTitle: "ok")
                    errorAlertView.show()
                    __error = true
                }
                else
                {
                    m_pDoorModel?.m_strTimerMotion = String(iSettingsValue)
                    m_pDoorModel?.m_dTimerMotion = Double(iSettingsValue)
                    
                    if __params != "" {
                        __params = __params + "|mtt=" + String(format: "%.f", Double(iSettingsValue)*1000)
                    }else{
                        __params = __params + "mtt=" + String(format: "%.f", Double(iSettingsValue)*1000)
                    }
                }
            }
        }

        /*if self.m_strDoorMotion.text != __appDelegate?.&& __error == false {
            let __timerMotionSTR = __doorMotionTF.text
            if Double(__timerMotionSTR!)! < 1 || Double(__timerMotionSTR!)! > 1200 {
                //__appDelegate?.showAlert("Alert", __msg: "Door Motion amount should be between 1000-1200000")
                __appDelegate?.showAlert("Alert", __msg: "Door Motion amount should be between 1-1200")
                __error = true
            }else{
                __appDelegate?.__selectedDoor?.__timerMotion = __doorMotionTF.text
                
                if __params != "" {
                    __params = __params! + "|mtt=" + String(format: "%.f", Double(__timerMotionSTR!)!*1000)
                }else{
                    __params = __params! + "mtt=" + String(format: "%.f", Double(__timerMotionSTR!)!*1000)
                }
                
            }
            //__appDelegate?.__selectedDoor?.setDeviceConfig("mtt=\(__timerMotionSTR!)")
            //self.performSelector("checkDeviceConfigered", withObject: nil, afterDelay: 0.1)
        }*/
        
        /*
        if __doorStartDelayTF.text != __appDelegate?.__selectedDoor?.__warmUpTime && __error == false {
            let __warmUpTimeSTR = __doorStartDelayTF.text
            if Double(__warmUpTimeSTR!)! < 0.1 || Double(__warmUpTimeSTR!)! > 10 {
                //__appDelegate?.showAlert("Alert", __msg: "Start Delay amount should be between 100-10000")
                __appDelegate?.showAlert("Alert", __msg: "Start Delay amount should be between 0.1-10")
                __error = true
            }else{
                __appDelegate?.__selectedDoor?.__warmUpTime = __doorStartDelayTF.text
                
                if __params != "" {
                    __params = __params! + "|mot=" + String(format: "%.f", Double(__warmUpTimeSTR!)!*1000)
                }else{
                    __params = __params! + "mot=" + String(format: "%.f", Double(__warmUpTimeSTR!)!*1000)
                }
            }
            //__appDelegate?.__selectedDoor?.setDeviceConfig("mot=\(__warmUpTimeSTR!)")
            //self.performSelector("checkDeviceConfigered", withObject: nil, afterDelay: 0.1)
        }
        */
        
        if( m_pDoorModel?.m_strTimerRelayOn != nil )
        {
            let iCurrentValue = Double((m_pDoorModel?.m_strTimerRelayOn)!)
            let iSettingsValue = self.m_arrRelayOnValues[self.m_iRelayOnIndex]
            
            if( iCurrentValue != iSettingsValue )
            {
                m_pDoorModel?.m_strTimerRelayOn = String(iSettingsValue)
            
                if __params != "" {
                    __params = __params + "|rlt=" + String(format: "%.f", Double(iSettingsValue)*1000)
                }else{
                    __params = __params + "rlt=" + String(format: "%.f", Double(iSettingsValue)*1000)
                }
            }
        }
        
        if( m_pDoorModel?.m_strTimerRelayOff != nil )
        {
            let iCurrentValue = Double((m_pDoorModel?.m_strTimerRelayOff)!)
            let iSettingsValue = self.m_arrRelayOffValues[self.m_iRelayOffIndex]
            
            if( iCurrentValue != iSettingsValue )
            {
                m_pDoorModel?.m_strTimerRelayOff = String(iSettingsValue)
                
                if __params != "" {
                    __params = __params + "|rlp=" + String(format: "%.f", Double(iSettingsValue)*1000)
                }else{
                    __params = __params + "rlp=" + String(format: "%.f", Double(iSettingsValue)*1000)
                }
            }
        }
        
        /*
        if __relayOnTimeTF.text != __appDelegate?.__selectedDoor?.__timerRelayOn && __error == false {
            let __timerRelayOnSTR = __relayOnTimeTF.text
            if Double(__timerRelayOnSTR!)! < 0.01 || Double(__timerRelayOnSTR!)! > 2 {
                //__appDelegate?.showAlert("Alert", __msg: "Timer Relay on amount should be between 10-2000")
                __appDelegate?.showAlert("Alert", __msg: "Timer Relay on amount should be between 0.01-2")
                __error = true
            }else{
                __appDelegate?.__selectedDoor?.__timerRelayOn = __relayOnTimeTF.text
                
                if __params != "" {
                    __params = __params! + "|rlt=" + String(format: "%.f", Double(__timerRelayOnSTR!)!*1000)
                }else{
                    __params = __params! + "rlt=" + String(format: "%.f", Double(__timerRelayOnSTR!)!*1000)
                }
            }
            //__appDelegate?.__selectedDoor?.setDeviceConfig("rlt=\(__timerRelayOnSTR!)")
            //self.performSelector("checkDeviceConfigered", withObject: nil, afterDelay: 0.1)
        }
        
        if __relayOffTimeTF.text != __appDelegate?.__selectedDoor?.__timerRelayOff && __error == false {
            let __timerRelayOffSTR = __relayOffTimeTF.text
            if Double(__timerRelayOffSTR!)! < 0.01 || Double(__timerRelayOffSTR!)! > 5 {
                //__appDelegate?.showAlert("Alert", __msg: "Timer Relay off amount should be between 10-5000")
                __appDelegate?.showAlert("Alert", __msg: "Timer Relay off amount should be between 0.01-5")
                __error = true
            }else{
                __appDelegate?.__selectedDoor?.__timerRelayOff = __relayOffTimeTF.text
                
                if __params != "" {
                    __params = __params! + "|rlp=" + String(format: "%.f", Double(__timerRelayOffSTR!)!*1000)
                }else{
                    __params = __params! + "rlp=" + String(format: "%.f", Double(__timerRelayOffSTR!)!*1000)
                }
            }
            //__appDelegate?.__selectedDoor?.setDeviceConfig("rlp=\(__timerRelayOffSTR!)")
            //self.performSelector("checkDeviceConfigered", withObject: nil, afterDelay: 0.1)
        }
        
        if __wiFiReconnectTF.text != __appDelegate?.__selectedDoor?.__connectionTimeOut && __error == false {
            let __wiFiReconnectSTR = __wiFiReconnectTF.text
            if Double(__wiFiReconnectSTR!)! < 0.5 || Double(__wiFiReconnectSTR!)! > 30 {
                //__appDelegate?.showAlert("Alert", __msg: "Timer Relay off amount should be between 500-30000")
                __appDelegate?.showAlert("Alert", __msg: "WiFi Reconnect amount should be between 0.5-30")
                __error = true
            }else{
                __appDelegate?.__selectedDoor?.__connectionTimeOut = __wiFiReconnectTF.text
                
                if __params != "" {
                    __params = __params! + "|cnt=" + String(format: "%.f", Double(__wiFiReconnectSTR!)!*1000)
                }else{
                    __params = __params! + "cnt=" + String(format: "%.f", Double(__wiFiReconnectSTR!)!*1000)
                }
            }
            //__appDelegate?.__selectedDoor?.setDeviceConfig("rlp=\(__timerRelayOffSTR!)")
            //self.performSelector("checkDeviceConfigered", withObject: nil, afterDelay: 0.1)
        }
        */
        
        if __params != "" && __error == false
        {
            print("__params == ",__params)
            self.m_pDoorModel!.setDeviceConfig(__params)
        }
    }
}
