//
//  CampusMapAnnotation.swift
//  MackTIA
//
//  Created by Joaquim Pessoa Filho on 19/08/16.
//  Copyright © 2016 Mackenzie. All rights reserved.
//

import MapKit

class CampusMapAnnotation: NSObject, MKAnnotation {
    let title:String?
    let locationName:String
    let coordinate: CLLocationCoordinate2D
    
    init(title:String, locationName:String, coordinate:CLLocationCoordinate2D) {
        self.title = title
        self.locationName = locationName
        self.coordinate = coordinate
        
        super.init()
    }
    
    var subtitle: String? {
        return locationName
    }
}
