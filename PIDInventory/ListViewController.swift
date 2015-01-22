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
    @IBAction func pidValueChanged(sender: UITextField) {
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
        
        var pidObject = appDelegate.querySingle(PIDObjectName.name, ByID: id) as PIDObject?
        
        if (pidObject != nil) {
            cell?.textLabel?.text =  pidObject!.pid
            cell?.tag = Int(pidObject!.id)
        }
        
        return cell!
    }
    
    //MARK: - Overrides
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        pidObjectsID = appDelegate.queryList(PIDObjectName.name, ToRetrieve:PIDObjectName.id)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

