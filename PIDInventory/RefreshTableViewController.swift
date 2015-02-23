//
//  RefreshViewController.swift
//  PIDInventory
//
//  Created by Baker on 1/21/15.
//  Copyright (c) 2015 Umetzu. All rights reserved.
//

import UIKit
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

    func uploadData() {
        if let caseList = appDelegate.queryList(PIDCaseName.name, aCondition: PIDCaseName.modified, aValue: true) {
            if caseList.count > 0 {
                for c in caseList {
                    var selectedRow = pickerViewUsers.selectedRowInComponent(0)
                    c.inventoryUser = listUsernames[selectedRow][0]
                    
                    var jsonList = toJSON(c)
                    
                    var statusUpload = appDelegate.sendToService(serviceAddress, method: "PostCaseList", objectToSend: jsonList)
                    
                    if !statusUpload {
                        jsonProcessError()
                        return
                    }
                    
                    appDelegate.deleteObject(c)
                    
                    appDelegate.saveContext()
                }
            }
        }
    }
    
    func downloadData() {
        appDelegate.deleteAllManagedObjects()
        
        if let userList = appDelegate.queryService(serviceAddress, "GetUserList") as? [NSArray] {
            listUsernames.removeAll(keepCapacity: false)
            
            for user in userList {
                listUsernames.append([user[0] as String, user[1] as String])
            }
            
            NSUserDefaults.standardUserDefaults().setObject(listUsernames, forKey: "usernameList")
            
            refreshPickerViewUsers()
        }
        
        var statusInsert = appDelegate.downloadFromService(serviceAddress, method: "GetInsertList", objectCreator:appDelegate.createPIDInsert)
        
        if !statusInsert {
            jsonProcessError()
            return
        }
        
        var statusCase = appDelegate.downloadFromService(serviceAddress, method: "GetCaseList", objectCreator:appDelegate.createPIDCase)
        
        if !statusCase {
            jsonProcessError()
            return
        }
        
        if statusInsert && statusCase {
            appDelegate.saveContext()
            clearDirectory()
        }
    }
    
    func jsonProcessError() {
        appDelegate.rollBack()
        UIAlertView(title: "Connection Error", message: "Process not completed, no changes occurred", delegate: nil, cancelButtonTitle: "OK").show()
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
        isAlive = appDelegate.downloadFromService(serviceAddress, method: "Alive", objectCreator:nil)
        
        var statusText = isAlive ? "Up": "Down"
        toolBarLabel.title = "Server: \(server) - Status: \(statusText)"
        
        toolBarLabel.tintColor = isAlive ? self.view.tintColor : UIColor.lightGrayColor()
        
        cellUpload.selectionStyle = isAlive ? .Blue : .None
        cellDownload.selectionStyle = isAlive ? .Blue : .None
        
        var labelUpload = cellUpload?.viewWithTag(1) as? UILabel
        if labelUpload != nil {
            labelUpload!.textColor = isAlive ? self.view.tintColor : UIColor.lightGrayColor()
        }
        
        var labelDownload = cellDownload?.viewWithTag(1) as? UILabel
        if labelDownload != nil {
            labelDownload!.textColor = isAlive ? self.view.tintColor : UIColor.lightGrayColor()
        }
       
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
