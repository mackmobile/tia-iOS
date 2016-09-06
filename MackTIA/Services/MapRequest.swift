//
//  MapManager.swift
//  MackTIA
//
//  Created by Joaquim Pessoa Filho on 06/09/16.
//  Copyright © 2016 Mackenzie. All rights reserved.
//

import Foundation

protocol MapRequest { }

extension MapRequest {
    
    func loadData(campus:String, completionHandler:(name: String, center:CGPoint, zoom:Float, distance:Float, zoomMax:Float, pins: [[String:String]], regions:[[String:String]], ErrorCode?)->Void) {
        
        TIAServer.sharedInstance.sendRequest(.Map) { (jsonData, error) in
            guard error == nil && jsonData != nil else {
                print(#function, "Problema ao carregar dados para o mapa: \(error)")
                completionHandler(name: "", center: CGPoint(x: 0,y: 0), zoom: 0, distance: 0, zoomMax: 0, pins: [],regions: [], error)
                return
            }
            
            guard let response = jsonData?["campi"] as? [[String:AnyObject]] else {
                print(#function, "problema com o formato do JSON (geral)")
                completionHandler(name: "", center: CGPoint(x: 0,y: 0), zoom: 0, distance: 0, zoomMax: 0, pins: [],regions: [],ErrorCode.OtherFailure(title: NSLocalizedString("error_invalidDataFormatTitle", comment: "JSON problem"), message: NSLocalizedString("error_invalidDataFormatMes,sage", comment: "JSON problem")))
                return
            }
            
            for campusData in response {
                if let campusCode = campusData["code"] as? String {
                    if campusCode == campus {
                        guard let pins = campusData["pins"] as? Array<[String:String]> else {
                            print(#function, "problema com o formato do JSON (Pins)")
                            completionHandler(name: "", center: CGPoint(x: 0,y: 0), zoom: 0, distance: 0, zoomMax: 0, pins: [],regions: [],ErrorCode.OtherFailure(title: NSLocalizedString("error_invalidDataFormatTitle", comment: "JSON problem"), message: NSLocalizedString("error_invalidDataFormatMessage", comment: "JSON problem")))
                            return
                        }
                        
                        guard let regions = campusData["regions"] as? Array<[String:String]> else {
                            print(#function, "problema com o formato do JSON (Regions)")
                            completionHandler(name: "", center: CGPoint(x: 0,y: 0), zoom: 0, distance: 0, zoomMax: 0, pins: [],regions: [],ErrorCode.OtherFailure(title: NSLocalizedString("error_invalidDataFormatTitle", comment: "JSON problem"), message: NSLocalizedString("error_invalidDataFormatMessage", comment: "JSON problem")))
                            return
                        }
                        
                        guard let campusName = campusData["name"] as? String else {
                            print(#function, "problema com o formato do JSON (Campus Name)")
                            completionHandler(name: "", center: CGPoint(x: 0,y: 0), zoom: 0, distance: 0, zoomMax: 0, pins: [],regions: [],ErrorCode.OtherFailure(title: NSLocalizedString("error_invalidDataFormatTitle", comment: "JSON problem"), message: NSLocalizedString("error_invalidDataFormatMessage", comment: "JSON problem")))
                            return
                        }
                        
                        guard let centerString = campusData["coordinate"] as? String else {
                            print(#function, "problema com o formato do JSON (Center)")
                            completionHandler(name: "", center: CGPoint(x: 0,y: 0), zoom: 0, distance: 0, zoomMax: 0, pins: [],regions: [],ErrorCode.OtherFailure(title: NSLocalizedString("error_invalidDataFormatTitle", comment: "JSON problem"), message: NSLocalizedString("error_invalidDataFormatMessage", comment: "JSON problem")))
                            return
                        }
                        
                        let center = CGPointFromString(centerString)
                        
                        guard let zoom = Float(campusData["zoom"] as? String ?? "0") else {
                            print(#function, "problema com o formato do JSON (Zoom)")
                            completionHandler(name: "", center: CGPoint(x: 0,y: 0), zoom: 0, distance: 0, zoomMax: 0, pins: [],regions: [],ErrorCode.OtherFailure(title: NSLocalizedString("error_invalidDataFormatTitle", comment: "JSON problem"), message: NSLocalizedString("error_invalidDataFormatMessage", comment: "JSON problem")))
                            return
                        }
                        
                        guard let distance = Float(campusData["distance"] as? String ?? "0") else {
                            print(#function, "problema com o formato do JSON (Distance)")
                            completionHandler(name: "", center: CGPoint(x: 0,y: 0), zoom: 0, distance: 0, zoomMax: 0, pins: [],regions: [],ErrorCode.OtherFailure(title: NSLocalizedString("error_invalidDataFormatTitle", comment: "JSON problem"), message: NSLocalizedString("error_invalidDataFormatMessage", comment: "JSON problem")))
                            return
                        }
                        
                        guard let zoomMax = Float(campusData["zoomMax"] as? String ?? "0") else {
                            print(#function, "problema com o formato do JSON (Zoom Max)")
                            completionHandler(name: "", center: CGPoint(x: 0,y: 0), zoom: 0, distance: 0, zoomMax: 0, pins: [],regions: [],ErrorCode.OtherFailure(title: NSLocalizedString("error_invalidDataFormatTitle", comment: "JSON problem"), message: NSLocalizedString("error_invalidDataFormatMessage", comment: "JSON problem")))
                            return
                        }
                        
                        completionHandler(name: campusName, center: center, zoom: zoom, distance: distance, zoomMax: zoomMax, pins: pins, regions: regions, nil)
                    }
                }
            }
            
            
            
            

        }
    }
}