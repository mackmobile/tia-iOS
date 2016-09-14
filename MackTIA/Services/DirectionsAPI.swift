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
    let alamofireManager:Alamofire.SessionManager?
    
    init() {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 25 // seconds
        configuration.timeoutIntervalForResource = 25
        self.alamofireManager = Alamofire.SessionManager(configuration: configuration)
    }
    
    
    // MARK: API Communication
    
    func getPolyline(origin: CLLocationCoordinate2D, destination: CLLocationCoordinate2D, completionHandler:@escaping (_ polylineEncoded:String?, _ error: ErrorCode?) -> Void) {
        
        guard let alamofireManager = self.alamofireManager else {
            print(#function, "Não foi possível criar objeto Manager para conexão web")
            completionHandler(nil, ErrorCode.domainNotFound)
            return
        }
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        let parameters: [String: String] = [
            "origin": "\(origin.latitude),\(origin.longitude)",
            "destination": "\(destination.latitude),\(destination.longitude)",
            "mode": "walking",
            "key": Token.APIKey.rawValue
        ]
        
        alamofireManager.request(DirectionsURL.Base.rawValue, method: .get, parameters: parameters, encoding: URLEncoding.default).responseJSON { response in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            
            if response.result.error != nil {
                print(#function, response.result.error)
                completionHandler(nil, ErrorCode.domainNotFound)
                return
            } else {
                if let data = response.result.value as? [String: Any] {
                    guard let routes = data["routes"] as? [[String: AnyObject]], let first = routes.first, let overview_polyline = first["overview_polyline"] as? [String: AnyObject], let polyline = overview_polyline["points"] as? String else {
                        completionHandler(nil, ErrorCode.otherFailure(title: NSLocalizedString("error_noDataFound_title", comment: "No data found"), message: NSLocalizedString("error_noDataFound_message", comment: "No data found")))
                        return
                    }
                    completionHandler(polyline, nil)
                    return
                } else {
                    completionHandler(nil, ErrorCode.otherFailure(title: NSLocalizedString("error_noDataFound_title", comment: "No data found"), message: NSLocalizedString("error_noDataFound_message", comment: "No data found")))
                    return
                }
            }
        }
    }
}
