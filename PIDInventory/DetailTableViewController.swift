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
        (showCameraTag == 0 ? textFieldPID : textFieldBarcode).text = scanned
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
            textFieldBarcode.text = currentPIDObject?.insertBarcode
            textViewComments.text = currentPIDObject?.comments
        }
        
        setAnnotation(currentPIDObject!)
    }
    
    func setAnnotation(pidObject: PIDCase) {
        var annotation = MKPointAnnotation()
        annotation.title = currentPIDObject?.insertBarcode
        annotation.coordinate = CLLocationCoordinate2D(latitude: pidObject.latitude, longitude: pidObject.longitude)
        mapView.addAnnotation(annotation)
        
        var region = MKCoordinateRegion(center: annotation.coordinate, span: MKCoordinateSpanMake(0.01, 0.01))
        mapView.setRegion(mapView.regionThatFits(region), animated: true)
    }
    
    // MARK : Overrides
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBarHidden = false
        
        //handle insertname, insertbarcode
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
            dest.newBarCode = textFieldBarcode.text
        }
    }
}
