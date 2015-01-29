//
//  FirstViewController.swift
//  PIDInventory
//
//  Created by Baker on 1/21/15.
//  Copyright (c) 2015 Umetzu. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {

    let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
    var userLocationZoomed = false
    
    @IBOutlet weak var mapView: MKMapView!
    
    //MARK: - MKMapViewDelegate
    func mapView(mapView: MKMapView!, didUpdateUserLocation userLocation: MKUserLocation!) {
        if (!userLocationZoomed) {
            userLocationZoomed = true
            var region = MKCoordinateRegion(center: userLocation.coordinate, span: MKCoordinateSpanMake(0.01, 0.01))
            mapView.setRegion(mapView.regionThatFits(region), animated: true)
        }
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
            
            if pidObjectsInFrame != nil {
                for pidObject in pidObjectsInFrame! {
                    var annotation = MKPointTagAnnotation(location: CLLocationCoordinate2D(latitude: pidObject[PIDObjectName.latitude] as Double , longitude: pidObject[PIDObjectName.longitude] as Double))
                    
                    annotation.title = "PID: \(pidObject[PIDObjectName.pid] as String)"
                    annotation.tag = pidObject[PIDObjectName.id] as Int
                    mapView.addAnnotation(annotation)
                }
            }
        }
    }
    
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        
        if (annotation is MKUserLocation) {
            return nil
        }
        
        var annotationView = mapView.dequeueReusableAnnotationViewWithIdentifier("point") as MKPinAnnotationView?
        
        if(annotationView == nil) {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier:"point")
            annotationView!.rightCalloutAccessoryView = UIButton.buttonWithType(UIButtonType.DetailDisclosure) as UIView
        }
        
        annotationView!.tag = (annotation as MKPointTagAnnotation).tag
        annotationView!.enabled = true
        annotationView!.canShowCallout = true
        
        return annotationView;
    }
    
    func mapView(mapView: MKMapView!, annotationView view: MKAnnotationView!, calloutAccessoryControlTapped control: UIControl!) {
        performSegueWithIdentifier("segueToDetail", sender: view)
    }
    
    //MARK: - Overrides
    override func viewDidLoad() {
        super.viewDidLoad()    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let dest = segue.destinationViewController as? DetailTableViewController {
            dest.currentID = (sender as MKAnnotationView).tag
        }
    }
}

