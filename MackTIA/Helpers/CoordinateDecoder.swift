//
//  CoordinateDecoder.swift
//
//  Created by Joaquim Pessoa Filho on 12/09/16.
//  Copyright © 2016 Mackenzie MackMobile. All rights reserved.
//

import Foundation
import MapKit

extension String {
    func coordinates() -> [CLLocationCoordinate2D]? {
        
        var bytes = self.utf8CString
        let length = self.lengthOfBytes(using: .utf8)
        var idx = 0
        
        var latitude = 0.0
        var longitude = 0.0
        
        var coords:[CLLocationCoordinate2D] = []
        
        while idx < length {
            var byte = 0
            var res = 0
            var shift = 0
            
            byte = bytes[idx] - 63
            idx += 1
            res |= (byte & 0x1F) << shift
            shift += 5
            
            while (byte >= 0x20) && idx < length {
                byte = bytes[idx] - 63
                idx += 1
                res |= (byte & 0x1F) << shift
                shift += 5
            }
            
            
            let deltaLat = ((res & 1)>0 ? Double(~(res >> 1)) : Double((res >> 1)))
            latitude += deltaLat
            
            shift = 0
            res = 0
            
            if idx < length {
                byte = bytes[idx] - 0x3F;
                idx += 1
                res |= (byte & 0x1F) << shift;
                shift += 5;
                
                while (byte >= 0x20) && idx < length {
                    byte = bytes[idx] - 0x3F;
                    idx += 1
                    res |= (byte & 0x1F) << shift;
                    shift += 5;
                }
            }
            
            let deltaLong = ((res & 1)>0 ? Double(~(res >> 1)) : Double((res >> 1)))
            longitude += deltaLong
            
            let finalLat = latitude * 1E-5
            let finalLong = longitude * 1E-5
            
            let coord = CLLocationCoordinate2D(latitude: finalLat, longitude: finalLong)
            coords.append(coord)
        }
        
        return coords
    }
}
