//
//  DirectionsAPI.swift
//  MackTIA
//
//  Created by Evandro on 23/08/16.
//  Copyright © 2016 Mackenzie. All rights reserved.
//

import Foundation
import Alamofire
import UIKit
import CoreLocation


enum DirectionsURL:String {
    case Base          = "https://maps.googleapis.com/maps/api/directions/json"
}

private enum Token:String {
    case APIKey = "AIzaSyCboJix6gXaxiCwBN52axQal_4thEDViZY"
}

class DirectionsAPI {
    
    // MARK: Singleton Methods
    static let sharedInstance = DirectionsAPI()
    let alamoFireManager:Alamofire.Manager?
    
    init() {
        let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        configuration.timeoutIntervalForRequest = 25 // seconds
        configuration.timeoutIntervalForResource = 25
        self.alamoFireManager = Alamofire.Manager(configuration: configuration)
    }
    
    
    // MARK: API Communication
    
    func getPolyline(origin: CLLocationCoordinate2D, destination: CLLocationCoordinate2D, completionHandler:(polylineEncoded:String?, error: ErrorCode?) -> Void) {
        
        guard let _ = self.alamoFireManager else {
            print(#function, "Não foi possível criar objeto Manager para conexão web")
            completionHandler(polylineEncoded: nil, error: ErrorCode.DomainNotFound)
            return
        }
        
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        
        let parameters: [String: String] = [
            "origin": "\(origin.latitude),\(origin.longitude)",
            "destination": "\(destination.latitude),\(destination.longitude)",
            "mode": "walking",
            "key": Token.APIKey.rawValue
        ]
        
        alamoFireManager!.request(.GET, DirectionsURL.Base.rawValue, parameters: parameters).responseJSON { response in
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            
            if response.result.error != nil {
                print(#function, response.result.error)
                completionHandler(polylineEncoded: nil, error: ErrorCode.DomainNotFound)
                return
            } else {
                if let data = response.result.value as? [String: AnyObject] {
                    guard let routes = data["routes"] as? [[String: AnyObject]], let first = routes.first, let overview_polyline = first["overview_polyline"] as? [String: AnyObject], let polyline = overview_polyline["points"] as? String else {
                        completionHandler(polylineEncoded: nil, error: ErrorCode.OtherFailure(title: NSLocalizedString("error_noDataFound_title", comment: "No data found"), message: NSLocalizedString("error_noDataFound_message", comment: "No data found")))
                        return
                    }
                    completionHandler(polylineEncoded: polyline, error: nil)
                    return
                } else {
                    completionHandler(polylineEncoded: nil, error: ErrorCode.OtherFailure(title: NSLocalizedString("error_noDataFound_title", comment: "No data found"), message: NSLocalizedString("error_noDataFound_message", comment: "No data found")))
                    return
                }
            }
        }
    }
}