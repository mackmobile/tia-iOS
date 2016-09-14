//
//  CampusMapViewController.swift
//  MackTIA
//
//  Created by Joaquim Pessoa Filho on 19/08/16.
//  Copyright (c) 2016 Mackenzie. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so you can apply
//  clean architecture to your iOS and Mac projects, see http://clean-swift.com
//

import UIKit
import MapKit
//import Polyline
import GoogleMaps


class CampusMapViewController: UIViewController, MapRequest {
    
    @IBOutlet weak var mapView: GMSMapView!
    
    let locationManager = CLLocationManager()
    var locValue: CLLocationCoordinate2D?
    var retryDestination: CLLocationCoordinate2D?
    var centerCoordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees(-0), longitude: CLLocationDegrees(0))
    var zoomDefault:Float = 1.0
    var distanceDefault:Float = 1.0
    var zoomMax:Float = 1.0
    var routeOverlay: GMSPolyline?
    var pins:[[String:String]] = []
    var regions:[[String:String]] = []
    var campusName:String = "Campus"
    
    
    var flag = false
    
    // MARK: Object lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    // MARK: View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.delegate = self
        let authstate = CLLocationManager.authorizationStatus()
        if(authstate == CLAuthorizationStatus.notDetermined){
            print("Not Authorised")
            locationManager.requestWhenInUseAuthorization()
        }
        
        mapView.tintColor = UIColor.red
        mapView.isMyLocationEnabled = true
        mapView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.locationManager.startUpdatingLocation()
        
        if self.pins.count == 0 || self.regions.count == 0 || self.distanceDefault <= 1 {
            self.loadMapDataRemotely()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.locationManager.stopUpdatingLocation()
    }
    
    // MARK: Event handling
    
    @IBAction func reloadButton(_ sender: AnyObject) {
        self.loadMapDataRemotely()
    }
    
    func loadMapDataRemotely() {
        
        guard let campus = TIAServer.sharedInstance.user?.campus else {
            print(#function, "Problema com o campus do aluno. O atributo Campus não pode ser nulo")
            return
        }
        
        self.loadData(campus, completionHandler: { [weak self] (name, center, zoom, distance, zoomMax, pins, regions, error) in
            guard error == nil else {
                print(#function, "Erro na busca dos dados: \(error)")
                return
            }
            
            self?.pins = pins
            self?.regions = regions
            self?.campusName = name
            self?.centerCoordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees(center.x), longitude: CLLocationDegrees(center.y))
            self?.zoomDefault = zoom
            self?.distanceDefault = distance
            self?.zoomMax = zoomMax
            
            self?.navigationItem.title = self?.campusName
            
            self?.mapView.clear()
            
            self?.loadPinAnnotations()
            self?.loadRegions()
            })
    }
    
    
    func loadPinAnnotations() {
        
        mapView.camera = GMSCameraPosition.camera(withTarget: self.centerCoordinate, zoom: self.zoomDefault)
        
        // Add Map Annotation
        for item in self.pins {
            let point = CGPointFromString(item["location"]!)
            let coordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees(point.x), longitude: CLLocationDegrees(point.y))
            
            let img =  UIImage(named: "pin")!.insertText(text: item["number"]!, size: 16.0, offset: 0.2, color: UIColor(hex: item["color"]!))
            
            let marker = GMSMarker(position: coordinate)
            marker.title = item["name"]
            marker.snippet = item["buildName"]
            marker.icon = img
            marker.appearAnimation = kGMSMarkerAnimationPop
            marker.map = mapView
        }
    }
    
    func loadRegions() {
        
        // Add Map Annotation
        // to create encoded polyline: https://google-developers.appspot.com/maps/documentation/utilities/polyline-utility/polylineutility
        
        for item in self.regions {
            if let coordsString = item["polylineString"] {
                let path = GMSMutablePath(fromEncodedPath: coordsString)
                let polygon = GMSPolygon(path: path)
                polygon.title = item["name"]
                polygon.fillColor = UIColor(hex: item["color"]!).withAlphaComponent(0.5)
                polygon.map = mapView
            }
        }
    }
    
    func traceRouteTo(buildNumber: String) {
        
        let buildNameFormatted = String(Int(buildNumber) ?? 0)
        
        if let destination = self.pins.filter({$0["number"] == buildNameFormatted}).first {
            let point = CGPointFromString(destination["location"]!)
            let coordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees(point.x), longitude: CLLocationDegrees(point.y))
            traceRouteTo(coordinate: coordinate)
        } else {
            let alert = UIAlertController(title: NSLocalizedString("campusmap_errorBuildNotFoundTitle", comment: "Too far away"), message: String(format: NSLocalizedString("campusmap_errorBuildNotFoundMessage", comment: "Too far away"), buildNumber), preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func traceRouteTo(coordinate destination: CLLocationCoordinate2D) {
        if let origin = locValue {
            if CLLocation(location: origin).distance(from: CLLocation(location: destination)) > 3000 {
                let alert = UIAlertController(title: NSLocalizedString("campusmap_errorTooFarAwayTitle", comment: "Too far away"), message: NSLocalizedString("campusmap_errorTooFarAwayMessage", comment: "Too far away"), preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                return
            }
            DirectionsAPI.sharedInstance.getPolyline(origin: origin, destination: destination) { [weak self] (polylineEncoded, error) in
                
                guard polylineEncoded != nil else {
                    print(#function, "Problema ao obter a rota")
                    return
                }
                
                let path = GMSPath(fromEncodedPath: polylineEncoded!)
                
                if self?.routeOverlay == nil {
                    self?.routeOverlay = GMSPolyline(path: path)
                } else {
                    self?.routeOverlay?.path = path
                }
                
                guard let polyline = self?.routeOverlay else {
                    return
                }
                
                polyline.strokeWidth = 4
                polyline.strokeColor = UIColor.red.withAlphaComponent(0.6)
                //                let styles = [GMSStrokeStyle.solidColor(UIColor.redColor().colorWithAlphaComponent(0.6)), GMSStrokeStyle.solidColor(UIColor.clearColor())]
                //                let lengths = [1,2]
                //                polyline.spans = GMSStyleSpans(polyline.path!, styles, lengths, kGMSLengthRhumb)
                
                polyline.map = self?.mapView
            }
        } else {
            retryDestination = destination
        }
    }
}

// MARK: - Map View delegate

extension CampusMapViewController: GMSMapViewDelegate, CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            self.locValue = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            
            if retryDestination != nil {
                traceRouteTo(coordinate: retryDestination!)
                retryDestination = nil
            }
            
        }
    }
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        self.traceRouteTo(coordinate: marker.position)
        return false
    }
    
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        
        if flag {
            flag = false
            return
        }
        
        let centerLocation = CLLocation(location: self.centerCoordinate)
        let centerMapView = CLLocation(location: mapView.camera.target)
        
        if centerLocation.distance(from: centerMapView) > Double(self.distanceDefault) || mapView.camera.zoom < self.zoomMax {
            mapView.animate(to: GMSCameraPosition.camera(withTarget: self.centerCoordinate, zoom: self.zoomDefault))
            flag = true
        }
        
    }
}
