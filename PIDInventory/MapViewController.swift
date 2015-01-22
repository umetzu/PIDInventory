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

    @IBOutlet weak var mapView: MKMapView!
    
    //MARK: - MKMapViewDelegate
    func mapView(mapView: MKMapView!, didUpdateUserLocation userLocation: MKUserLocation!) {
        var region = MKCoordinateRegion(center: userLocation.coordinate, span: MKCoordinateSpanMake(0.01, 0.01))
        mapView.setRegion(mapView.regionThatFits(region), animated: true)
    }
    
    //MARK: - Overrides
    override func viewDidLoad() {
        super.viewDidLoad()    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

