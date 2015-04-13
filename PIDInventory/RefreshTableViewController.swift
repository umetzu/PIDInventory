//
//  RefreshViewController.swift
//  PIDInventory
//
//  Created by Baker on 1/21/15.
//  Copyright (c) 2015 Umetzu. All rights reserved.
//

import UIKit
import CoreData
import SystemConfiguration

class RefreshTableViewController: UITableViewController, UITableViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate, UIAlertViewDelegate {

    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    var timerConnectionCheck: NSTimer?
    var isAlive = false
    
    @IBOutlet weak var cellUpload: UITableViewCell!
    @IBOutlet weak var cellDownload: UITableViewCell!
    @IBOutlet weak var labelProcessing: UILabel!
    @IBOutlet weak var pickerViewUsers: UIPickerView!
    @IBOutlet weak var toolBarLabel: UIBarButtonItem!
    @IBOutlet weak var cellPicker: UITableViewCell!
    @IBOutlet weak var labelSelectedUsername: UILabel!
    @IBOutlet weak var labelDBDetails: UILabel!
    @IBOutlet weak var labelModifiedDetails: UILabel!
    
    var recordsToProcess = 0
    var recordsProcessed = 0
    var recordsFailed = 0
    var processing = false
    
    var isPickerVisible = true

    var listUsernames:[[String]] = [["Other", "Other "]]
    
    var server: String {
        get {
            return NSUserDefaults.standardUserDefaults().stringForKey("server")!
        }
    }
    
    var serviceAddress: String {
        get {
            return "http://\(server)/PIDService.svc/"
        }
    }
    
    @IBAction func changeServer(sender: UIBarButtonItem) {
        if !processing {
            var alert = UIAlertView(title: "Server Address", message:"Server:Port", delegate:self, cancelButtonTitle:"Cancel", otherButtonTitles: "OK")
            alert.tag = 10
            alert.alertViewStyle = UIAlertViewStyle.PlainTextInput
            alert.show()
        }
    }
    
    // MARK: - UIPickerViewDataSource
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return listUsernames.count
    }
    
    // MARK: - UIPickerViewDelegate
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        return listUsernames[row][1]
    }
    
    //MARK: - UITableViewDelegate
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        if !processing {
            if (indexPath.section == 0 && indexPath.row == 0) {
                    changePickerCellVisibility(!isPickerVisible)
            }
            
            if (indexPath.section == 3 && isAlive) {
                
                if indexPath.row != 0 {
                    if appDelegate.count(PIDCaseName.name, aCondition: PIDCaseName.modified, aValue: true) == 0 {
                        labelProcessing.text = "There are no changes to upload"
                        return
                    }
                }
                
                var title = indexPath.row != 0 ? "Data upload" : "Data overwrite"
                var message = indexPath.row != 0 ? "All modifications will be sent to the server, do you want to proceed?" : "Any modifications will be lost, are you sure you want to proceed?"
                var tag = indexPath.row
                
                var alert = UIAlertView(title: title, message: message, delegate: self, cancelButtonTitle: "Cancel", otherButtonTitles: "OK")
                alert.tag = tag
                alert.show()
            }
        }
    }
    
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        if buttonIndex != 0 {
            switch alertView.tag {
                case 1:
                    uploadData()
                case 0:
                    downloadData()
                default:
                    if let textField = alertView.textFieldAtIndex(0) {
                        isAlive = false
                        var userDefaults = NSUserDefaults.standardUserDefaults()
                        userDefaults.setObject(textField.text, forKey: "server")
                        userDefaults.synchronize()
                        checkConnection()
                    }
            }
        }
    }

    func uploadData() {
        if let caseList = appDelegate.queryList(PIDCaseName.name, aCondition: PIDCaseName.modified, aValue: true) {
            if caseList.count > 0 {
                if !processing {
                    processing = true
                    self.labelProcessing.text = "Processing..."
                    recordsToProcess = caseList.count
                    
                    var selectedRow = pickerViewUsers.selectedRowInComponent(0)
                    var user = listUsernames[selectedRow][0]
                    
                    for c in caseList {
                        c.inventoryUser = user
                    
                        var statusUpload = appDelegate.sendToService(serviceAddress, method: "PostCaseList", pidCase: c, onSuccess: uploadDataSuccess, onError: uploadDataError)
                        
                        if !statusUpload {
                            recordsProcessed = 0
                            onProcessError()
                            return
                        }
                    }
                }
            }
        }
    }
    
    func uploadDataSuccess(c: PIDCase) {
        ++recordsProcessed
        checkIfUploadDone()
        
        dispatch_async(dispatch_get_main_queue()) {
            self.appDelegate.deleteObject(c)
            self.appDelegate.saveContext()
        }
    }
    
    func uploadDataError() {
        ++recordsFailed
        checkIfUploadDone()
        
        dispatch_async(dispatch_get_main_queue()) {
            self.appDelegate.rollBack()
        }
    }
    
    func checkIfUploadDone() {
        if recordsProcessed + recordsFailed == recordsToProcess {
            var x = recordsProcessed
            var y = recordsFailed
            
            dispatch_async(dispatch_get_main_queue()) {
                
                self.appDelegate.deleteAllManagedObjects()
                self.appDelegate.saveContext()
                
                self.labelProcessing.text = "\(x) records were uploaded" + (y > 0 ? " \(y) errors" : "")
                
                NSUserDefaults.standardUserDefaults().setObject("", forKey: "downloadDate")
                self.refreshDBLabel()
                
                self.pickerViewUsers.reloadAllComponents()
            }
            
            processing = false
            recordsToProcess = 0
            recordsProcessed = 0
            recordsFailed = 0
        }
    }
    
    func onProcessError() {
        appDelegate.rollBack()
        processing = false
        
        dispatch_async(dispatch_get_main_queue()) {
            self.labelProcessing.text = "Connection error, no changes were saved"
        }
    }
    
    func onDownloadSuccess(pids: Int) {
        clearDirectory()
        
        dispatch_async(dispatch_get_main_queue()) {
            
            self.appDelegate.saveContext()
            
            self.labelProcessing.text = "\(pids) records were downloaded"
            
            let timestamp = NSDateFormatter.localizedStringFromDate(NSDate(), dateStyle: .MediumStyle, timeStyle: .ShortStyle)
            NSUserDefaults.standardUserDefaults().setObject(timestamp, forKey: "downloadDate")
            self.refreshDBLabel()
            
            self.pickerViewUsers.reloadAllComponents()
        }
        
        processing = false
    }
    
    func refreshDBLabel() {
        var message = ""
        var message2 = ""
        var downloadDate = NSUserDefaults.standardUserDefaults().stringForKey("downloadDate")
        
        if downloadDate != nil && !downloadDate!.isEmpty {
            message = "Last Download \(downloadDate!)"
            var count = appDelegate.count(PIDCaseName.name, aCondition: PIDCaseName.modified, aValue: true)
            message2 = "Modified Records: \(count)"
        } else {
            message = "Empty DB"
            message2 = "Modified records: 0"
        }
        
        labelDBDetails.text = message
        labelModifiedDetails.text = message2
    }
    
    func downloadData() {
        if !processing {
            processing = true
            self.labelProcessing.text = "Processing..."
            appDelegate.deleteAllManagedObjects()
            
            appDelegate.queryService(serviceAddress, "GetUserList", onSuccessUsers, onProcessError, 15)
        }
    }
    
    func onSuccessUsers(x: AnyObject?) {
        if let results = x as? [NSArray] {
            listUsernames.removeAll(keepCapacity: false)
            
            for user in results {
                listUsernames.append([user[0] as! String, user[1] as! String])
            }
            
            NSUserDefaults.standardUserDefaults().setObject(listUsernames, forKey: "usernameList")
            
            refreshPickerViewUsers()
            
            appDelegate.queryService(serviceAddress, "GetInsertList", onSuccessInsert, onProcessError, 15)
        } else {
            onProcessError()
        }
    }
    
    func onSuccessInsert(x: AnyObject?) {
        if onSuccessList(x, creator:appDelegate.createPIDInsert) >= 0 {
            appDelegate.queryService(serviceAddress, "GetCaseList", onSuccessCase, onProcessError, 15)
        } else {
            onProcessError()
        }
    }
    
    func onSuccessCase(x: AnyObject?) {
        var pids = onSuccessList(x, creator:appDelegate.createPIDCase)
        if  pids >= 0{
            onDownloadSuccess(pids)
        } else {
            onProcessError()
        }
    }
    
    func onSuccessList(x: AnyObject?,  creator: (() -> NSManagedObject)) -> Int  {
        if let results = x as? [NSDictionary] {
            dispatch_async(dispatch_get_main_queue(), {
                for data in results {
                    var item = creator()
                    
                    for (key, value) in data {
                        var keyName = key as! NSString
                        if item.respondsToSelector(NSSelectorFromString(keyName as String)) {
                            item.setValue(value, forKey: keyName as String)
                        }
                    }
                }
            })
            return results.count
        }
        return -1
    }
    
    func onSuccessCheckConnection (x: AnyObject?)  {
         if !processing {
            if let result = x as? Int {
                isAlive = result == 1
            } else {
                isAlive = false
            }
            refreshStatus()
        }
    }
    
    func onFailCheckConnection () {
        if !processing {
            isAlive = false
            refreshStatus()
        }
    }
    
    func refreshStatus() {
        var localIsAlive = isAlive
        dispatch_async(dispatch_get_main_queue()) {
            var statusText = localIsAlive ? "Up": "Down"
            self.toolBarLabel.title = "Server: \(self.server) - Status: \(statusText)"
            
            self.toolBarLabel.tintColor = localIsAlive ? blueColor : UIColor.lightGrayColor()
            
            self.cellUpload.selectionStyle = localIsAlive ? .Blue : .None
            self.cellDownload.selectionStyle = localIsAlive ? .Blue : .None
            
            var labelUpload = self.cellUpload?.viewWithTag(1) as? UILabel
            if labelUpload != nil {
                labelUpload!.textColor = localIsAlive ? blueColor : UIColor.lightGrayColor()
            }
            
            var labelDownload = self.cellDownload?.viewWithTag(1) as? UILabel
            if labelDownload != nil {
                labelDownload!.textColor = localIsAlive ? blueColor : UIColor.lightGrayColor()
            }
        }
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        var height = super.tableView(tableView, heightForRowAtIndexPath: indexPath)
        
        if (indexPath.section == 0 && indexPath.row == 1) {
            height = self.isPickerVisible ? 162 : 0
        }
        
        return height
    }
    
    //MARK: - UIPickerView
    func changePickerCellVisibility(shouldDisplay: Bool) {
        if shouldDisplay {
            isPickerVisible = true
            tableView.beginUpdates()
            tableView.endUpdates()

            UIView.animateWithDuration(0.25, animations: { self.pickerViewUsers.alpha = 1 })

        }
        else {
            isPickerVisible = false
            tableView.beginUpdates()
            tableView.endUpdates()
            UIView.animateWithDuration(0.25, animations: { self.pickerViewUsers.alpha = 0 })
        }
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        labelSelectedUsername.text = listUsernames[row][1]
    }
    
    //MARK: - Overrides
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.toolbarHidden = false
        self.navigationController?.navigationBarHidden = true
        
        refreshDBLabel()
        
        timerConnectionCheck = NSTimer.scheduledTimerWithTimeInterval(3, target: self, selector: Selector("checkConnection"), userInfo: nil, repeats: true)
        
        timerConnectionCheck!.fire()
    }
    
    override func viewWillDisappear(animated: Bool) {
        if timerConnectionCheck != nil && timerConnectionCheck!.valid {
            timerConnectionCheck?.invalidate()
        }
    }
    
    func checkConnection() {
        appDelegate.queryService(serviceAddress, "Alive", onSuccessCheckConnection, onFailCheckConnection, 1)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshPickerViewUsers()
    }
    
    func refreshPickerViewUsers() {
        if let list = NSUserDefaults.standardUserDefaults().valueForKey("usernameList") as? [[String]] {
            listUsernames = list
        }
        
        pickerViewUsers.reloadAllComponents()
        
        changePickerCellVisibility(false)
        
        labelSelectedUsername.text = listUsernames[0][1]
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        self.navigationController?.toolbarHidden = true
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String?, sender: AnyObject?) -> Bool {
        if identifier == "startInventorySegue" {
            if processing {
                return false
            }
            if appDelegate.count(PIDInsertName.name) == 0 {
                UIAlertView(title: "No Inserts available", message: "Please download PID from server first", delegate: nil, cancelButtonTitle: "OK").show()
                return false
            }
        }
        
        return true
    }
    
    @IBAction func unwindToRefreshTableViewController(segue: UIStoryboardSegue) { }
}
