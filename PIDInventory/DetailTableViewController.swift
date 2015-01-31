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
    var showCameraTag = 0
    
    @IBOutlet weak var textFieldPID: UITextField!
    @IBOutlet weak var textFieldBarcode: UITextField!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var textViewComments: UITextView!
    @IBOutlet weak var buttonPID: UIButton!
    
    // Mark: Actions
    @IBAction func showCamera(sender: UIButton) {
        showCameraTag = sender.tag
    }
    
    @IBAction func unwindToDetailTableViewController(segue: UIStoryboardSegue) {
        var scanned = (segue.sourceViewController as CameraViewController).capturedCode
        
        if showCameraTag == 0  {
            textFieldPID.text = scanned
        } else {
            textFieldBarcode.text = scanned
            insertBarcodeChanged(textFieldBarcode)
        }
        
        self.view.endEditing(true)
    }
    
    func saveChanges(sender: UIBarButtonItem) {
        currentPIDObject?.caseBarcode = textFieldPID.text
        currentPIDObject?.insertBarcode = textFieldBarcode.text
        currentPIDObject?.comments = textViewComments.text
        
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
                currentPIDObject?.latitude = appDelegate.lastUserLocation!.latitude
                currentPIDObject?.longitude = appDelegate.lastUserLocation!.longitude
            }
        } else {
            
            textFieldPID.enabled = false
            buttonPID.enabled = false
            
            currentPIDObject = appDelegate.querySingle(PIDCaseName.name, ByID: currentID)
            
            textFieldPID.text = currentPIDObject?.caseBarcode
            textViewComments.text = currentPIDObject?.comments
        }
        
        setAnnotation(currentPIDObject!)
    }
    
    // MARK: - Barcode linking
    @IBAction func insertBarcodeChanged(sender: UITextField) {
        var result = ""
        
        if countElements(textFieldBarcode.text) > 4 {
            result = appDelegate.querySingle(PIDInsertName.name, ToRetrieve: PIDInsertName.insertName, aCondition: PIDInsertName.insertBarcode, aValue: textFieldBarcode.text)
        }
        
        currentPIDObject?.insertName = result
        currentPIDObject?.insertBarcode = textFieldBarcode.text
    }
    
    func refreshInsertBarcode() {
        textFieldBarcode.text = currentPIDObject?.insertBarcode
    }
    
    func setAnnotation(pidObject: PIDCase) {
        var annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: pidObject.latitude, longitude: pidObject.longitude)
        mapView.addAnnotation(annotation)
        
        var region = MKCoordinateRegion(center: annotation.coordinate, span: MKCoordinateSpanMake(0.01, 0.01))
        mapView.setRegion(mapView.regionThatFits(region), animated: true)
    }
    
    func mapView(mapView: MKMapView!, didSelectAnnotationView view: MKAnnotationView!) {
        var c = 0.001
        var north = currentPIDObject!.latitude + c
        var south = currentPIDObject!.latitude - c
        var west = currentPIDObject!.longitude - c
        var east = currentPIDObject!.longitude + c
        
        var pidObjectsInFrame = appDelegate.queryMap(west, anEastPoint: east, aNorthPoint: north, aSouthPoint: south)
        
        if pidObjectsInFrame != nil {
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
        
        refreshInsertBarcode()
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
        }
    }
}
