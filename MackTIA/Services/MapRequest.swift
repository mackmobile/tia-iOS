//
//  MapRequest.swift
//  MackTIA
//
//  Created by Joaquim Pessoa Filho on 06/09/16.
//  Copyright © 2016 Mackenzie. All rights reserved.
//

import Foundation

protocol MapRequest { }

extension MapRequest {
    
    func loadData(_ campus:String, completionHandler:@escaping (_ name: String, _ center:CGPoint, _ zoom:Float, _ distance:Float, _ zoomMax:Float, _ pins: [[String:String]], _ regions:[[String:String]], ErrorCode?)->Void) {
        
        TIAServer.sharedInstance.sendRequest(service: .Map) { (jsonData, error) in
            guard error == nil && jsonData != nil else {
                completionHandler("", CGPoint(x: 0,y: 0), 0, 0, 0, [],[], error)
                return
            }
            
            guard let response = jsonData?["campi"] as? [[String:AnyObject]] else {
                completionHandler("", CGPoint(x: 0,y: 0), 0, 0, 0, [],[],ErrorCode.otherFailure(title: NSLocalizedString("error_invalidDataFormatTitle", comment: "JSON problem"), message: NSLocalizedString("error_invalidDataFormatMes,sage", comment: "JSON problem")))
                return
            }
            
            for campusData in response {
                if let campusCode = campusData["code"] as? String {
                    if campusCode == campus {
                        guard let pins = campusData["pins"] as? Array<[String:String]> else {
                            completionHandler("", CGPoint(x: 0,y: 0), 0, 0, 0, [],[],ErrorCode.otherFailure(title: NSLocalizedString("error_invalidDataFormatTitle", comment: "JSON problem"), message: NSLocalizedString("error_invalidDataFormatMessage", comment: "JSON problem")))
                            return
                        }
                        
                        guard let regions = campusData["regions"] as? Array<[String:String]> else {
                            completionHandler("", CGPoint(x: 0,y: 0), 0, 0, 0, [],[],ErrorCode.otherFailure(title: NSLocalizedString("error_invalidDataFormatTitle", comment: "JSON problem"), message: NSLocalizedString("error_invalidDataFormatMessage", comment: "JSON problem")))
                            return
                        }
                        
                        guard let campusName = campusData["name"] as? String else {
                            completionHandler("", CGPoint(x: 0,y: 0), 0, 0, 0, [],[],ErrorCode.otherFailure(title: NSLocalizedString("error_invalidDataFormatTitle", comment: "JSON problem"), message: NSLocalizedString("error_invalidDataFormatMessage", comment: "JSON problem")))
                            return
                        }
                        
                        guard let centerString = campusData["coordinate"] as? String else {
                            completionHandler("", CGPoint(x: 0,y: 0), 0, 0, 0, [],[],ErrorCode.otherFailure(title: NSLocalizedString("error_invalidDataFormatTitle", comment: "JSON problem"), message: NSLocalizedString("error_invalidDataFormatMessage", comment: "JSON problem")))
                            return
                        }
                        
                        let center = CGPointFromString(centerString)
                        
                        guard let zoom = Float(campusData["zoom"] as? String ?? "0") else {
                            completionHandler("", CGPoint(x: 0,y: 0), 0, 0, 0, [],[],ErrorCode.otherFailure(title: NSLocalizedString("error_invalidDataFormatTitle", comment: "JSON problem"), message: NSLocalizedString("error_invalidDataFormatMessage", comment: "JSON problem")))
                            return
                        }
                        
                        guard let distance = Float(campusData["distance"] as? String ?? "0") else {
                            completionHandler("", CGPoint(x: 0,y: 0), 0, 0, 0, [],[],ErrorCode.otherFailure(title: NSLocalizedString("error_invalidDataFormatTitle", comment: "JSON problem"), message: NSLocalizedString("error_invalidDataFormatMessage", comment: "JSON problem")))
                            return
                        }
                        
                        guard let zoomMax = Float(campusData["zoomMax"] as? String ?? "0") else {
                            completionHandler("", CGPoint(x: 0,y: 0), 0, 0, 0, [],[],ErrorCode.otherFailure(title: NSLocalizedString("error_invalidDataFormatTitle", comment: "JSON problem"), message: NSLocalizedString("error_invalidDataFormatMessage", comment: "JSON problem")))
                            return
                        }
                        
                        completionHandler(campusName, center, zoom, distance, zoomMax, pins, regions, nil)
                    }
                }
            }
        }
    }
}
