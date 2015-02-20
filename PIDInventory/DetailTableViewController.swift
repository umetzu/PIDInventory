//
//  DetailTableViewController.swift
//  PIDInventory
//
//  Created by Baker on 1/23/15]zf re23w
//  Copyright (c) 2015 Umetzu. All rights reserved.
//

import UIKit
import MapKit

class DetailTableViewController: UITableViewController, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIAlertViewDelegate {

    let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
    
    var currentID = 0
    var currentPIDObject: PIDCase?
    
    @IBOutlet weak var textFieldCaseBarcode: UITextField!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var textViewComments: UITextView!
    @IBOutlet weak var buttonPID: UIButton!
    @IBOutlet weak var labelCaseName: UILabel!
    
    @IBOutlet weak var viewImageView1: UIView!
    @IBOutlet weak var viewImageView2: UIView!
    
    @IBOutlet weak var labelCaseModified: UILabel!
    @IBOutlet weak var labelCoverModified: UILabel!
    @IBOutlet weak var labelInsertModified: UILabel!
    @IBOutlet weak var labelLocationModified: UILabel!
    @IBOutlet weak var labelStandModified: UILabel!
    
    var currentTag = 101
    
    // Mark: Actions
    @IBAction func unwindToDetailTableViewController(segue: UIStoryboardSegue) {
        var scanned = (segue.sourceViewController as CameraViewController).capturedCode
        
        textFieldCaseBarcode.text = scanned
        
        self.view.endEditing(true)
    }

    
    var picker:UIImagePickerController = UIImagePickerController()
    
    @IBAction func imageViewTapped(sender: UITapGestureRecognizer) {
        picker.delegate = self
        var imageView = sender.view as UIImageView
        
        var actionSheet  = UIActionSheet(title: imageView.tag == 101 ? "Photo 1" : "Photo 2", delegate: self, cancelButtonTitle: "Cancel", destructiveButtonTitle: nil)
        actionSheet.tag = imageView.tag
       
        actionSheet.addButtonWithTitle("Take Photo")
        
        var view = imageView.tag == 101 ? viewImageView1 : viewImageView2
        actionSheet.showFromRect(imageView.frame, inView: view, animated: true)

    }

    // MARK: - UIActionSheetDelegate
    func actionSheet(actionSheet: UIActionSheet, didDismissWithButtonIndex buttonIndex: Int) {
        if actionSheet.tag == 10 {
            if buttonIndex != 0 {
                openInMaps()
            }
        } else {
            switch buttonIndex {
            case 1:
                callImagePicker(actionSheet.tag)
            default: break
            }
        }
    }
    
    func callImagePicker(tag: Int) {
        if(UIImagePickerController.isSourceTypeAvailable(.Camera))
        {
            currentTag = tag
            picker.sourceType = .Camera
            picker.modalPresentationStyle = .FullScreen
            presentViewController(picker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(picker: UIImagePickerController!, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]!)
    {
        picker.dismissViewControllerAnimated(true, completion: nil)
        
        var view = currentTag == 101 ? viewImageView1 : viewImageView2
        var imageView = view.viewWithTag(currentTag) as UIImageView
        
        imageView.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        
        if imageView.image != nil {
            var c = NSDateFormatter()
            c.dateFormat = "yyyyMMddHHmmss"
            
            if currentTag == 101 {
                currentPIDObject?.inventoryPhoto1 = savePicture(imageView.image!)
                currentPIDObject?.inventoryPhoto1Date = c.stringFromDate(NSDate())
            } else {
                currentPIDObject?.inventoryPhoto2 = savePicture(imageView.image!)
                currentPIDObject?.inventoryPhoto2Date = c.stringFromDate(NSDate())
            }
            
        }
    }   
    
    func saveChanges(sender: UIBarButtonItem) {
        if textFieldCaseBarcode.text.isEmpty {
            UIAlertView(title: "Missing Barcode", message: "Please provide a Case Barcode",
                delegate: nil, cancelButtonTitle: "Ok").show()
        } else {
            
            var m1 = currentPIDObject!.caseModified
            var m2 = currentPIDObject!.coverModified
            var m3 = currentPIDObject!.insertModified
            var m4 = currentPIDObject!.locationModified
            var m5 = currentPIDObject!.standModified
            
            if !(m1 && m2 && m3 && m4 && m5) {
                UIAlertView(title: "Missing Information", message: "You haven't fill up all the rating information. Do you want to mark it as completed?", delegate: self, cancelButtonTitle: "Cancel", otherButtonTitles: "OK").show()
                return
            }
            
            saveAndReturn()
        }
    }
    
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        if buttonIndex != 0 {
            saveAndReturn()
        }
    }
    
    func saveAndReturn() {
        currentPIDObject?.inventoryCaseBarcode = textFieldCaseBarcode.text
        currentPIDObject?.inventoryComments = textViewComments.text
        currentPIDObject?.inventoryModified = true
        currentPIDObject?.inventoryDate = formatter.stringFromDate(NSDate())
        
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
            
            currentPIDObject = appDelegate.querySingle(PIDCaseName.name, ByID: currentID)
            
            textFieldCaseBarcode.text = currentPIDObject?.inventoryCaseBarcode
            labelCaseName.text = currentPIDObject?.inventoryCaseNameArchive
            textViewComments.text = currentPIDObject?.inventoryComments
            
            var image1 = readPicture(currentPIDObject!.inventoryPhoto1)
            var image2 = readPicture(currentPIDObject!.inventoryPhoto2)
            
            if image1 != nil {
                (viewImageView1.viewWithTag(101) as UIImageView).image = image1
            }
            
            if image2 != nil {
                (viewImageView2.viewWithTag(102) as UIImageView).image = image2
            }
        }
        
        setAnnotation(currentPIDObject!)
    }
    
    func setAnnotation(pidObject: PIDCase) {
        var annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: pidObject.inventoryLatitude, longitude: pidObject.inventoryLongitude)
        mapView.addAnnotation(annotation)
        
        var region = MKCoordinateRegion(center: annotation.coordinate, span: MKCoordinateSpanMake(0.001, 0.001))
        mapView.setRegion(mapView.regionThatFits(region), animated: true)
    }
    
    func mapView(mapView: MKMapView!, didSelectAnnotationView view: MKAnnotationView!) {
        
        var actionSheet  = UIActionSheet(title: "Get Directions", delegate: self, cancelButtonTitle: "Cancel", destructiveButtonTitle: nil, otherButtonTitles: "Open in Maps App")
        actionSheet.tag = 10
        actionSheet.showFromRect(view.frame, inView: mapView, animated: true)
        
        mapView.deselectAnnotation(view.annotation, animated: false)
    }
    
    func openInMaps() {
        let currentLocation = MKMapItem.mapItemForCurrentLocation()
        
        var place = MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: currentPIDObject!.inventoryLatitude, longitude: currentPIDObject!.inventoryLongitude), addressDictionary: nil)
        var destination = MKMapItem(placemark: place)
        destination.name = "PID: \(currentPIDObject!.inventoryCaseBarcode)"
        
        MKMapItem.openMapsWithItems([currentLocation, destination], launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving])
    }
    
    // MARK : Overrides
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBarHidden = false
        
        labelCaseModified.text = completedText(currentPIDObject!.caseModified)
        labelCoverModified.text = completedText(currentPIDObject!.coverModified)
        labelInsertModified.text = completedText(currentPIDObject!.insertModified)
        labelLocationModified.text = completedText(currentPIDObject!.locationModified)
        labelStandModified.text = completedText(currentPIDObject!.standModified)
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
