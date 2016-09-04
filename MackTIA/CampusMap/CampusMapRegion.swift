//
//  CampusMapRegion.swift
//  MackTIA
//
//  Created by Evandro on 04/09/16.
//  Copyright © 2016 Mackenzie. All rights reserved.
//

import MapKit
import Polyline

class CampusMapRegion: MKPolygon {
    var name:String = ""
    var color: UIColor?
    
    convenience init(name:String, polylineString: String, color: String) {
        self.init()
        self.name = name
        self.color = UIColor(hex: color)
        if let coordinates: [CLLocationCoordinate2D] = decodePolyline(polylineString) {
            var waypoints = coordinates
                self.init(coordinates: &waypoints, count: waypoints.count)
            self.name = name
            self.color = UIColor(hex: color)
        }
    }
    
    var fillColor:UIColor {
        return color?.colorWithAlphaComponent(0.1) ?? UIColor.blackColor().colorWithAlphaComponent(0.1)
    }
    
    var strokeColor:UIColor {
        return color?.colorWithAlphaComponent(0.4) ?? UIColor.blackColor().colorWithAlphaComponent(0.4)
    }
}
