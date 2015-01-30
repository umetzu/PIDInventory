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
    var annotations = [MKPointAnnotation:[String, Int]]()
    var annotationTitles = [String, Int]()
    
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
        
        if (span.latitudeDelta < 0.08) {
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
                        var x1 = pidObject[PIDObjectName.longitude] as Double
                        var y1 = pidObject[PIDObjectName.latitude] as Double
                        var c = 0.001
                        
                        return x1 > x2 - c && x1 < x2 + c && y1 > y2 - c && y1 < y2 + c
                    })
                    
                    var annotation: MKPointAnnotation!
                    
                    if (annotationInPlace.count > 0) {
                        annotation = annotationInPlace[0]
                    } else {
                        annotation = MKPointAnnotation()
                        annotation.coordinate = CLLocationCoordinate2D(latitude: pidObject[PIDObjectName.latitude] as Double , longitude: pidObject[PIDObjectName.longitude] as Double)
                    }
                    
                    annotations[annotation] = annotations[annotation] ?? [String,Int]()
                    
                    annotations[annotation]!.append("PID: \(pidObject[PIDObjectName.pid] as String)", pidObject[PIDObjectName.id] as Int)
                }
            }
            
            for annotation in Array(annotations.keys) {
                mapView.addAnnotation(annotation)
            }
        }
    }

    func mapView(mapView: MKMapView!, didSelectAnnotationView view: MKAnnotationView!) {
        
        var actionSheet  = UIActionSheet(title: nil, delegate: self, cancelButtonTitle: "Cancel", destructiveButtonTitle: nil)
        
        annotationTitles = annotations[view.annotation as MKPointAnnotation]!
        
        actionSheet.tag = 1
        
        for x in annotationTitles {
            actionSheet.addButtonWithTitle(x.0)
        }
        
        actionSheet.showInView(UIApplication.sharedApplication().keyWindow)
        
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

