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

    let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
    
    var timerConnectionCheck: NSTimer?
    var isAlive = false
    
    @IBOutlet weak var cellUpload: UITableViewCell!
    @IBOutlet weak var cellDownload: UITableViewCell!
    
    @IBOutlet weak var pickerViewUsers: UIPickerView!
    @IBOutlet weak var toolBarLabel: UIBarButtonItem!
    @IBOutlet weak var cellPicker: UITableViewCell!
    @IBOutlet weak var labelSelectedUsername: UILabel!
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
        var alert = UIAlertView(title: "Server Address", message:"Server:Port", delegate:self, cancelButtonTitle:"Cancel", otherButtonTitles: "OK")
        alert.tag = 10
        alert.alertViewStyle = UIAlertViewStyle.PlainTextInput
        alert.show()
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
        if (indexPath.section == 0 && indexPath.row == 0) {
                changePickerCellVisibility(!isPickerVisible)
        }
        
        if (indexPath.section == 2 && isAlive) {
            var title = indexPath.row == 0 ? "Data upload" : "Data overwrite"
            var message = indexPath.row == 0 ? "All modifications will be sent to the server, do you want to proceed?" : "Any modifications will be lost, are you sure you want to proceed?"
            var tag = indexPath.row
            
            var alert = UIAlertView(title: title, message: message, delegate: self, cancelButtonTitle: "Cancel", otherButtonTitles: "OK")
            alert.tag = tag
            alert.show()
        }
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        if buttonIndex != 0 {
            switch alertView.tag {
                case 0:
                    if appDelegate.count(PIDCaseName.name, aCondition: PIDCaseName.modified, aValue: true) > 0 {
                        uploadData()
                    } else {
                        UIAlertView(title: "No data to upload", message: "There are not any PID with a modified status", delegate: nil, cancelButtonTitle: "OK").show()
                    }
                case 1:
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
    
    var recordsToProcess = 0
    var recordsProcessed = 0
    var recordsFailed = 0
    var processing = false

    func uploadData() {
        if let caseList = appDelegate.queryList(PIDCaseName.name, aCondition: PIDCaseName.modified, aValue: true) {
            if caseList.count > 0 {
                if !processing {
                    processing = true
                    recordsToProcess = caseList.count
                    for c in caseList {
                        
                        var selectedRow = pickerViewUsers.selectedRowInComponent(0)
                        c.inventoryUser = listUsernames[selectedRow][0]
                        
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
        
        appDelegate.deleteObject(c)
        appDelegate.saveContext()
    }
    
    func uploadDataError() {
        ++recordsFailed
        checkIfUploadDone()
        
        appDelegate.rollBack()
    }
    
    func checkIfUploadDone() {
        if recordsProcessed + recordsFailed == recordsToProcess {
            println("\(recordsProcessed) processed  \(recordsFailed) errors")
            
            processing = false
            recordsToProcess = 0
            recordsProcessed = 0
            recordsFailed = 0
        }
    }
    
    func downloadData() {
        if !processing {
            processing = true
            appDelegate.deleteAllManagedObjects()
            
            appDelegate.queryService(serviceAddress, "GetUserList", onSuccessUsers, onProcessError)
        }
    }
    
    func onProcessError() {
        appDelegate.rollBack()
        processing = false
        UIAlertView(title: "Connection Error", message: "Process not completed, no changes occurred", delegate: nil, cancelButtonTitle: "OK").show()
    }
    
    func onSuccessUsers(x: AnyObject?) {
        if let results = x as? [NSArray] {
            listUsernames.removeAll(keepCapacity: false)
            
            for user in results {
                listUsernames.append([user[0] as String, user[1] as String])
            }
            
            NSUserDefaults.standardUserDefaults().setObject(listUsernames, forKey: "usernameList")
            
            refreshPickerViewUsers()
            
            appDelegate.queryService(serviceAddress, "GetInsertList", onSuccessInsert, onProcessError)
        } else {
            onProcessError()
        }
    }
    
    func onSuccessInsert(x: AnyObject?) {
        if onSuccessList(x, creator:appDelegate.createPIDInsert) {
            appDelegate.queryService(serviceAddress, "GetCaseList", onSuccessCase, onProcessError)
        } else {
            onProcessError()
        }
    }
    
    func onSuccessCase(x: AnyObject?) {
        if onSuccessList(x, creator:appDelegate.createPIDCase) {
            appDelegate.saveContext()
            clearDirectory()
            processing = false
        } else {
            onProcessError()
        }
    }
    
    func onSuccessList(x: AnyObject?,  creator: (() -> NSManagedObject)) -> Bool  {
        if let results = x as? [NSDictionary] {
            for data in results {
                var item = creator()
                
                for (key, value) in data {
                    var keyName = key as NSString
                    if item.respondsToSelector(NSSelectorFromString(keyName)) {
                        item.setValue(value, forKey: keyName)
                    }
                }
            }
            return true
        }
        return false
    }
    
    func onSuccessCheckConnection (x: AnyObject?)  {
        if let result = x as? Int {
            isAlive = result == 1
        } else {
            isAlive = false
        }
        refreshStatus()
    }
    
    func onFailCheckConnection () {
        isAlive = false
        refreshStatus()
    }
    
    func refreshStatus() {
        dispatch_async(dispatch_get_main_queue()) {
            var statusText = self.isAlive ? "Up": "Down"
            self.toolBarLabel.title = "Server: \(self.server) - Status: \(statusText)"
            
            self.toolBarLabel.tintColor = self.isAlive ? self.view.tintColor : UIColor.lightGrayColor()
            
            self.cellUpload.selectionStyle = self.isAlive ? .Blue : .None
            self.cellDownload.selectionStyle = self.isAlive ? .Blue : .None
            
            var labelUpload = self.cellUpload?.viewWithTag(1) as? UILabel
            if labelUpload != nil {
                labelUpload!.textColor = self.isAlive ? self.view.tintColor : UIColor.lightGrayColor()
            }
            
            var labelDownload = self.cellDownload?.viewWithTag(1) as? UILabel
            if labelDownload != nil {
                labelDownload!.textColor = self.isAlive ? self.view.tintColor : UIColor.lightGrayColor()
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
            if appDelegate.count(PIDInsertName.name) == 0 {
                UIAlertView(title: "No Inserts available", message: "Please download PID from server first", delegate: nil, cancelButtonTitle: "OK").show()
                return false
            }
        }
        
        return true
    }
    
    @IBAction func unwindToRefreshTableViewController(segue: UIStoryboardSegue) { }
}
