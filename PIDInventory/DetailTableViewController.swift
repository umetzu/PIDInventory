//
//  DetailTableViewController.swift
//  PIDInventory
//
//  Created by Baker on 1/23/15]zf re23w
//  Copyright (c) 2015 Umetzu. All rights reserved.
//

import UIKit
import MapKit

class DetailTableViewController: UITableViewController {

    let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
    
    var currentID = 0
    var currentPIDObject: PIDCase?
    
    @IBOutlet weak var textFieldCaseBarcode: UITextField!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var textViewComments: UITextView!
    @IBOutlet weak var buttonPID: UIButton!
    @IBOutlet weak var labelCaseName: UILabel!
    
    @IBOutlet weak var labelCaseModified: UILabel!
    @IBOutlet weak var labelCoverModified: UILabel!
    @IBOutlet weak var labelInsertModified: UILabel!
    @IBOutlet weak var labelLocationModified: UILabel!
    @IBOutlet weak var labelStandModified: UILabel!
    
    // Mark: Actions
    @IBAction func unwindToDetailTableViewController(segue: UIStoryboardSegue) {
        var scanned = (segue.sourceViewController as CameraViewController).capturedCode
        
        textFieldCaseBarcode.text = scanned
        
        self.view.endEditing(true)
    }
    
    func saveChanges(sender: UIBarButtonItem) {
        currentPIDObject?.inventoryCaseBarcode = textFieldCaseBarcode.text
        currentPIDObject?.inventoryComments = textViewComments.text
        currentPIDObject?.inventoryModified = true
        
        appDelegate.saveContext()
        
        self.performSegueWithIdentifier("unwindFromDetail", sender: self)
    }
    
    func cancelChanges(sender: UIBarButtonItem) {
        appDelegate.rollBack()
        self.performSegueWithIdentifier("unwindFromDetail", sender: self)
    }
    
    func fillValues() {
        if (currentID == -1) {
            currentPIDObject = appDelegate.createPIDCase()
            currentPIDObject!.id = appDelegate.lastID(PIDCaseName.name) + 1
            if (appDelegate.lastUserLocation != nil) {
                currentPIDObject?.inventoryLatitude = appDelegate.lastUserLocation!.latitude
                currentPIDObject?.inventoryLongitude = appDelegate.lastUserLocation!.longitude
            }
        } else {
            
            textFieldCaseBarcode.enabled = false
            buttonPID.enabled = false
            
            currentPIDObject = appDelegate.querySingle(PIDCaseName.name, ByID: currentID)
            
            textFieldCaseBarcode.text = currentPIDObject?.inventoryCaseBarcode
            labelCaseName.text = currentPIDObject?.inventoryCaseNameArchive
            textViewComments.text = currentPIDObject?.inventoryComments
        }
        
        setAnnotation(currentPIDObject!)
    }
    
    func setAnnotation(pidObject: PIDCase) {
        var annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: pidObject.inventoryLatitude, longitude: pidObject.inventoryLongitude)
        mapView.addAnnotation(annotation)
        
        var region = MKCoordinateRegion(center: annotation.coordinate, span: MKCoordinateSpanMake(0.01, 0.01))
        mapView.setRegion(mapView.regionThatFits(region), animated: true)
    }
    
    func mapView(mapView: MKMapView!, didSelectAnnotationView view: MKAnnotationView!) {
        var c = 0.00001
        var north = currentPIDObject!.inventoryLatitude + c
        var south = currentPIDObject!.inventoryLatitude - c
        var west = currentPIDObject!.inventoryLongitude - c
        var east = currentPIDObject!.inventoryLongitude + c
        
        var pidObjectsInFrame = appDelegate.queryMap(west, anEastPoint: east, aNorthPoint: north, aSouthPoint: south)
        
        if pidObjectsInFrame != nil && pidObjectsInFrame?.count > 0 {
            var actionSheet  = UIActionSheet(title: "Sharing with", delegate: nil, cancelButtonTitle: "OK", destructiveButtonTitle: nil)
            actionSheet.tag = 2
            
            for pidObject in pidObjectsInFrame! {
                actionSheet.addButtonWithTitle("PID: \(pidObject[PIDCaseName.caseBarcode] as String)")
            }
            
            actionSheet.showInView(UIApplication.sharedApplication().keyWindow)
            
            mapView.deselectAnnotation(view.annotation, animated: false)
        }
    }
    
    // MARK : Overrides
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBarHidden = false
        
        labelCaseModified.text = currentPIDObject!.caseModified ? "Complete" : "Incomplete"
        labelCoverModified.text = currentPIDObject!.coverModified ? "Complete" : "Incomplete"
        labelInsertModified.text = currentPIDObject!.insertModified ? "Complete" : "Incomplete"
        labelLocationModified.text = currentPIDObject!.locationModified ? "Complete" : "Incomplete"
        labelStandModified.text = currentPIDObject!.standModified ? "Complete" : "Incomplete"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let saveButton = UIBarButtonItem(title: "Save", style: UIBarButtonItemStyle.Done, target: self, action: "saveChanges:")
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.Plain, target: self, action: "cancelChanges:")
        
        self.navigationItem.setRightBarButtonItem(saveButton, animated: false)
        self.navigationItem.setLeftBarButtonItem(cancelButton, animated: false)
        
        fillValues()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: Table View
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    
    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let dest = segue.destinationViewController as? ValuesTableViewController {
            dest.currentPIDObject = currentPIDObject
        } else if let dest = segue.destinationViewController as? CameraViewController {
            dest.sourceView = 1
        }
    }
}
