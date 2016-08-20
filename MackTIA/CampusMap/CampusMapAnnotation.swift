//
//  CampusMapAnnotation.swift
//  MackTIA
//
//  Created by Joaquim Pessoa Filho on 19/08/16.
//  Copyright © 2016 Mackenzie. All rights reserved.
//

import MapKit

class CampusMapAnnotation: NSObject, MKAnnotation {
    let name:String
    let buildName:String
    let number:String
    let coordinate: CLLocationCoordinate2D
    
    init(name:String, buildName:String, number:String, coordinate:CLLocationCoordinate2D) {
        self.name = name
        self.buildName = buildName
        self.number = number
        self.coordinate = coordinate
        
        super.init()
    }
    
    var title:String? {
        return name
    }
    
    var subtitle:String? {
        return buildName
    }
}
