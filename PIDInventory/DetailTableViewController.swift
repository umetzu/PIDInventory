//
//  DetailTableViewController.swift
//  PIDInventory
//
//  Created by Baker on 1/23/15]zf re23w
//  Copyright (c) 2015 Umetzu. All rights reserved.
//

import UIKit
import MapKit

class DetailTableViewController: UITableViewController, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

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
        
        var actionSheet  = UIActionSheet(title: nil, delegate: self, cancelButtonTitle: "Cancel", destructiveButtonTitle: nil)
        actionSheet.tag = imageView.tag
       
        actionSheet.addButtonWithTitle("Take Photo")
        actionSheet.addButtonWithTitle("Photo Library")
        
        var view = imageView.tag == 101 ? viewImageView1 : viewImageView2
        actionSheet.showFromRect(imageView.frame, inView: view, animated: true)

    }

    // MARK: - UIActionSheetDelegate
    func actionSheet(actionSheet: UIActionSheet, didDismissWithButtonIndex buttonIndex: Int) {
        switch buttonIndex {
        case 1:
            callImagePicker(.Camera, tag: actionSheet.tag)
        case 2:
            callImagePicker(.PhotoLibrary, tag: actionSheet.tag)
        default: break
        }
    }
    
    func callImagePicker(type: UIImagePickerControllerSourceType, tag: Int) {
        if(UIImagePickerController.isSourceTypeAvailable(type))
        {
            currentTag = tag
            picker.sourceType = type
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
            if currentTag == 101 {
                currentPIDObject?.inventoryPhoto1 = savePicture(imageView.image!)
            } else {
                currentPIDObject?.inventoryPhoto2 = savePicture(imageView.image!)
            }
            
        }
    }
    
    // MARK: - Image Functions
    func documentsPathForFileName(name: String) -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true);
        let path = paths[0] as String;
        let fullPath = path.stringByAppendingPathComponent(name)
        
        return fullPath
    }
    
    func savePicture(image: UIImage) -> String {
        let imageData = UIImagePNGRepresentation(image)
        let relativePath = "image_\(NSDate.timeIntervalSinceReferenceDate()).png"
        let path = documentsPathForFileName(relativePath)
        imageData.writeToFile(path, atomically: true)
        
        return relativePath
    }
    
    func readPicture(path: String) -> UIImage? {
        let oldFullPath = documentsPathForFileName(path)
        let oldImageData = NSData(contentsOfFile: oldFullPath)
        
        return oldImageData != nil ? UIImage(data: oldImageData!) : nil
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
            actionSheet.showFromRect(view.frame, inView: mapView, animated: true)
            
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
