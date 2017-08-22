//
//  TIAServer.swift
//  MackTIA
//
//  Created by Joaquim Pessoa Filho on 14/04/16.
//  Copyright © 2016 Mackenzie. All rights reserved.
//

import Foundation
import Alamofire

enum ServiceURL:String {
    case Login          = "https://www3.mackenzie.br/tia/tia_mobile/ping.php"
    case Grades         = "https://www3.mackenzie.br/tia/tia_mobile/notas.php"
    case Absence        = "https://www3.mackenzie.br/tia/tia_mobile/faltas.php"
    case ClassSchedule  = "https://www3.mackenzie.br/tia/tia_mobile/horarios.php"
    case Map            = "https://www3.mackenzie.br/tia/tia_mobile/mapa.php"
}

private enum Token:String {
    case parte1 = "aNw3476Bi4ok33T987nQ"
    case parte2 = "wc8oc669GE738m8uMA77"
}

class TIAServer {
    
    // MARK: Singleton Methods
    static let sharedInstance = TIAServer()
    let alamofireManager:Alamofire.SessionManager?
    
    init() {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 25 // seconds
        configuration.timeoutIntervalForResource = 25
        self.alamofireManager = Alamofire.SessionManager(configuration: configuration)
    }
    
    // MARK: Security Parameters and Methods
    var user:User?
    
    fileprivate func makeToken() -> String {
        let date = Date()
        let calendar = Calendar.current
        let components = (calendar as NSCalendar).components([NSCalendar.Unit.day, NSCalendar.Unit.month, NSCalendar.Unit.year], from: date)
        let day = (components.day ?? 0) < 10 ? "0\(components.day ?? 0)" : "\(components.day ?? 0)"
        let month = (components.month ?? 0) < 10 ? "0\(components.month ?? 0)" : "\(components.month ?? 0)"
        let year = components.year ?? 0
        let token = "\(Token.parte1.rawValue)\(month)\(year)\(day)\(Token.parte2.rawValue)"
        return token.md5
    }
    
    // MARK: Login Manager
    
    func loginRecorded() -> User? {
        guard let tia = UserDefaults.standard.object(forKey: "tia") as? String,
            let password = UserDefaults.standard.object(forKey: "password") as? String,
            let campus = UserDefaults.standard.object(forKey: "campus") as? String,
            let name = UserDefaults.standard.object(forKey: "name") as? String,
            let campusName = UserDefaults.standard.object(forKey: "campusName") as? String else {
                self.logoff()
                return nil
        }
        
        self.user = User(name: name, tia: tia, password: password, campus: campus, campusName: campusName)
        return self.user
        
    }
    
    func registerLogin() {
        guard let u = user else {
            return
        }
        
        UserDefaults.standard.set(u.tia, forKey: "tia")
        UserDefaults.standard.set(u.password, forKey: "password")
        UserDefaults.standard.set(u.campus, forKey: "campus")
        UserDefaults.standard.set(u.name, forKey: "name")
        UserDefaults.standard.set(u.campusName, forKey: "campusName")
    }
    
    func logoff() {
        UserDefaults.standard.removeObject(forKey: "statement")
        UserDefaults.standard.removeObject(forKey: "tia")
        UserDefaults.standard.removeObject(forKey: "password")
        UserDefaults.standard.removeObject(forKey: "campus")
        UserDefaults.standard.removeObject(forKey: "name")
        UserDefaults.standard.removeObject(forKey: "campusName")
    }
    
    
    // MARK: Server Communication
    
    fileprivate func getRequestParameters() -> [String:Any] {
        let parameters = [
            "mat": self.user?.tia ?? " ",
            "pass": self.user?.password ?? " ",
            "token": self.makeToken(),
            "unidade": self.user?.campus ?? " "
        ]
        return parameters
    }
    
    func sendRequest(service:ServiceURL, completionHandler:@escaping (_ jsonData:AnyObject?, _ error: ErrorCode?) -> Void) {
        
        guard let alamofireManager = self.alamofireManager else {
            completionHandler(nil, ErrorCode.domainNotFound)
            return
        }
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        

        alamofireManager.request(service.rawValue, method: .post, parameters: self.getRequestParameters(), encoding: URLEncoding.default).responseJSON { (response) in
            
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            
            if response.result.error != nil {
                completionHandler(nil, ErrorCode.domainNotFound)
                return
            } else {
                if let jsonData = response.result.value {
                    completionHandler(jsonData as AnyObject?, nil)
                    return
                } else {
                    completionHandler(nil, ErrorCode.otherFailure(title: NSLocalizedString("error_noDataFound_title", comment: "No data found"), message: NSLocalizedString("error_noDataFound_message", comment: "No data found")))
                    return
                }
            }
        }
    }
}
