//
//  RefreshViewController.swift
//  PIDInventory
//
//  Created by Baker on 1/21/15.
//  Copyright (c) 2015 Umetzu. All rights reserved.
//

import UIKit

class RefreshTableViewController: UITableViewController, UITableViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate {

    @IBOutlet weak var pickerViewUsers: UIPickerView!
    @IBOutlet weak var toolBarLabel: UIBarButtonItem!
    @IBOutlet weak var cellPicker: UITableViewCell!
    @IBOutlet weak var labelSelectedUsername: UILabel!
    var isPickerVisible = true

    
    let usersList = [ "John", "Thomas", "Richard", "Peter", "John" , "Chuck", "Richie", "Dane", "Emery", "Keith" ]
    let server = "0.0.0.0"
    
    // MARK: - UIPickerViewDataSource
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return usersList.count
    }
    
    // MARK: - UIPickerViewDelegate
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        return usersList[row]
    }
    
    //MARK: - UITableViewDelegate
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if (indexPath.section == 0 && indexPath.row == 0) {
                changePickerCellVisibility(!isPickerVisible)
        }
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        //var height = self.tableView.rowHeight
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
        labelSelectedUsername.text = usersList[row]
    }
    
    //MARK: - Overrides
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.toolbarHidden = false
        self.navigationController?.navigationBarHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        changePickerCellVisibility(false)
        toolBarLabel.title = "Sever: \(server) - Status: Unreachable"
        labelSelectedUsername.text = usersList[0]
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        self.navigationController?.toolbarHidden = true
    }
    
    @IBAction func unwindToRefreshTableViewController(segue: UIStoryboardSegue) { }
}
