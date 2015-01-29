//
//  MKPointTagAnnotation.swift
//  PIDInventory
//
//  Created by Baker on 1/29/15.
//  Copyright (c) 2015 Umetzu. All rights reserved.
//

import UIKit
import MapKit

class MKPointTagAnnotation: NSObject, MKAnnotation {
    
    var coordinate: CLLocationCoordinate2D
    var title: String = ""
    var subtitle: String = ""
    var tag = 0
    
    init(location coord:CLLocationCoordinate2D) {
        self.coordinate = coord
        super.init()
    }

}
