//
//  FirstViewController.swift
//  PIDInventory
//
//  Created by Baker on 1/21/15.
//  Copyright (c) 2015 Umetzu. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate, UIActionSheetDelegate {

    let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
    var userLocationZoomed = false
    var annotations = [MKPointAnnotation:[String, Int, Bool]]()
    var annotationTitles = [String, Int, Bool]()
    
    @IBOutlet weak var mapView: MKMapView!
    
    //MARK: - MKMapViewDelegate
    func mapView(mapView: MKMapView!, didUpdateUserLocation userLocation: MKUserLocation!) {
        if (!userLocationZoomed) {
            userLocationZoomed = true
            var region = MKCoordinateRegion(center: userLocation.coordinate, span: MKCoordinateSpanMake(0.01, 0.01))
            mapView.setRegion(mapView.regionThatFits(region), animated: true)
        }
        
        appDelegate.lastUserLocation = userLocation.coordinate
    }
    
    func mapView(mapView: MKMapView!, regionDidChangeAnimated animated: Bool) {
        
        var span = mapView.region.span
        
        if (span.latitudeDelta < 0.15) {
            var mRect = self.mapView.visibleMapRect
            var neMapPoint = MKMapPointMake(MKMapRectGetMaxX(mRect), mRect.origin.y)
            var swMapPoint = MKMapPointMake(mRect.origin.x, MKMapRectGetMaxY(mRect))
            var neCoord = MKCoordinateForMapPoint(neMapPoint)
            var swCoord = MKCoordinateForMapPoint(swMapPoint)
            
            var pidObjectsInFrame = appDelegate.queryMap(swCoord.longitude, anEastPoint: neCoord.longitude, aNorthPoint: neCoord.latitude, aSouthPoint: swCoord.latitude)
            
            mapView.removeAnnotations(mapView.annotations)
            annotations.removeAll()
            
            if pidObjectsInFrame != nil {
                for pidObject in pidObjectsInFrame! {
                    
                    var annotationInPlace = Array(annotations.keys).filter({ x in
                        
                        var x2 = x.coordinate.longitude
                        var y2 = x.coordinate.latitude
                        var x1 = pidObject[PIDCaseName.longitude] as Double
                        var y1 = pidObject[PIDCaseName.latitude] as Double
                        var c = 0.0
                        
                        return x1 >= x2 - c && x1 <= x2 + c && y1 >= y2 - c && y1 <= y2 + c
                    })
                    
                    var annotation: MKPointAnnotation!
                    
                    if (annotationInPlace.count > 0) {
                        annotation = annotationInPlace[0]
                    } else {
                        annotation = MKPointAnnotation()
                        annotation.coordinate = CLLocationCoordinate2D(latitude: pidObject[PIDCaseName.latitude] as Double , longitude: pidObject[PIDCaseName.longitude] as Double)
                    }
                    
                    annotations[annotation] = annotations[annotation] ?? [String,Int, Bool]()
                    
                    var modified = pidObject[PIDCaseName.modified] as Bool
                    
                    annotations[annotation]!.append("PID: \(pidObject[PIDCaseName.caseBarcode] as String) - \(completedText(pidObject[PIDCaseName.modified] as Bool))", pidObject[PIDCaseName.id] as Int, pidObject[PIDCaseName.modified] as Bool)
                }
            }
            
            for annotation in Array(annotations.keys) {
                mapView.addAnnotation(annotation)
            }
        }
    }
    
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        if annotation is MKUserLocation {
            return nil
        }
        
        var pinIdentifier = "customPin"
        
        var pin = mapView.dequeueReusableAnnotationViewWithIdentifier(pinIdentifier) as MKPinAnnotationView?
        
        if (pin == nil) {
            pin = MKPinAnnotationView(annotation: annotation, reuseIdentifier: pinIdentifier)
        } else {
            pin?.annotation = annotation
        }
        
        var completed = true
        
        for x in annotations[annotation as MKPointAnnotation]! {
            if !x.2 {
                completed = false
            }
        }
        
        pin!.pinColor = completed ? MKPinAnnotationColor.Green : MKPinAnnotationColor.Red
        
        return pin
    }

    func mapView(mapView: MKMapView!, didSelectAnnotationView view: MKAnnotationView!) {
        
        if view.annotation is MKUserLocation {
            return
        }
        
        var actionSheet  = UIActionSheet(title: "Sharing with", delegate: self, cancelButtonTitle: "Cancel", destructiveButtonTitle: nil)
        
        annotationTitles = annotations[view.annotation as MKPointAnnotation]!
        
        actionSheet.tag = 1
        
        for x in annotationTitles {
            actionSheet.addButtonWithTitle(x.0)
        }
        
        actionSheet.showFromRect(view.frame, inView: mapView, animated: true)
        
        mapView.deselectAnnotation(view.annotation, animated: false)
        
    }
    
    // MARK: - UIActionSheetDelegate
    func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int) {
        if (actionSheet.tag == 1 ) {
            if (buttonIndex == 0 ) {
                annotationTitles.removeAll()
            } else {
                var id = annotationTitles[buttonIndex - 1].1
                performSegueWithIdentifier("segueToDetail", sender: id)
            }
        }
    }
    
    //MARK: - Overrides
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBarHidden = true
        mapView(mapView, regionDidChangeAnimated: false)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let dest = segue.destinationViewController as? DetailTableViewController {
            dest.currentID = sender as Int
        }
    }
}

