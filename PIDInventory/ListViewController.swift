//
//  SecondViewController.swift
//  PIDInventory
//
//  Created by Baker on 1/21/15.
//  Copyright (c) 2015 Umetzu. All rights reserved.
//

import UIKit
import CoreData

class ListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
  
    let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
    var pidObjectsID: [Int] = []
    
    @IBOutlet weak var textFieldPID: UITextField!
    @IBOutlet weak var tableViewPID: UITableView!
    
    //MARK: - Actions
    @IBAction func pidEditingChanged(sender: UITextField) {
        if (textFieldPID.text.isEmpty) {
            pidObjectsID = appDelegate.queryList(PIDCaseName.name, ToRetrieve:PIDCaseName.id, SortBy: PIDCaseName.caseBarcode)
        } else {
            pidObjectsID = appDelegate.queryList(PIDCaseName.name, ToRetrieve: PIDCaseName.id, aCondition: PIDCaseName.caseBarcode, aValue: sender.text, SortBy: PIDCaseName.caseBarcode)
        }
        
        tableViewPID.reloadData()
    }
    
    //MARK: - UITableViewDataSource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pidObjectsID.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cellIdentifier = "pidCell"
        var cell = tableViewPID.dequeueReusableCellWithIdentifier(cellIdentifier) as UITableViewCell?
        
        if (cell == nil) {
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: cellIdentifier)
        }
        
        var id = pidObjectsID[indexPath.row]
        
        var pidObject = appDelegate.querySingle(PIDCaseName.name, ByID: id) as PIDCase?
        
        if (pidObject != nil) {
            var labelPID = cell?.viewWithTag(1) as? UILabel
            if labelPID != nil {
                labelPID!.text = pidObject?.inventoryCaseBarcode
            }
            
            var labelBarcode = cell?.viewWithTag(2) as? UILabel
            if labelBarcode != nil {
                labelBarcode!.text = pidObject?.insertBarcode
            }
            
            cell?.tag = Int(pidObject!.id)
        }
        
        return cell!
    }
    
    // MARK: UITableViewDelegate
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    //MARK: - Overrides
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBarHidden = true
        pidEditingChanged(textFieldPID)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let dest = segue.destinationViewController as? DetailTableViewController {
            if let cell = sender as? UITableViewCell {
                dest.currentID = cell.tag
            } else {
                dest.currentID = -1
            }
        } else if let dest = segue.destinationViewController as? CameraViewController {
            dest.sourceView = 0
        }
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        self.view.endEditing(true);
    }
}































