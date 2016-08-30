//
//  TIAServer.swift
//  MackTIA
//
//  Created by Joaquim Pessoa Filho on 14/04/16.
//  Copyright © 2016 Mackenzie. All rights reserved.
//

import Foundation
import Alamofire
import UIKit

enum ServiceURL:String {
    // TODO: Precisa que o servidor devolva o nome do aluno no servico ping.php
    case Login          = "https://www3.mackenzie.com.br/tia/tia_mobile/ping.php"
    case Grades         = "https://www3.mackenzie.com.br/tia/tia_mobile/notas.php"
    case Absence        = "https://www3.mackenzie.com.br/tia/tia_mobile/faltas.php"
    case ClassSchedule  = "https://www3.mackenzie.com.br/tia/tia_mobile/horarios.php"
}

private enum Token:String {
    case parte1 = "aNw3476Bi4ok33T987nQ"
    case parte2 = "wc8oc669GE738m8uMA77"
}

class TIAServer {
    
    // MARK: Singleton Methods
    static let sharedInstance = TIAServer()
    let alamoFireManager:Alamofire.Manager?
    
    init() {
        let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        configuration.timeoutIntervalForRequest = 25 // seconds
        configuration.timeoutIntervalForResource = 25
        self.alamoFireManager = Alamofire.Manager(configuration: configuration)
    }
    
    // MARK: Security Parameters and Methods
    var user:User?
    
    private func makeToken() -> String {
        let date = NSDate()
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([NSCalendarUnit.Day, NSCalendarUnit.Month, NSCalendarUnit.Year], fromDate: date)
        let day = components.day < 10 ? "0\(components.day)" : "\(components.day)"
        let month = components.month < 10 ? "0\(components.month)" : "\(components.month)"
        let token = "\(Token.parte1.rawValue)\(month)\(components.year)\(day)\(Token.parte2.rawValue)"
        return token.md5
    }
    
    // MARK: Login Manager
    
    func loginRecorded() -> User? {
        guard let tia = NSUserDefaults.standardUserDefaults().objectForKey("tia") as? String,
            let password = NSUserDefaults.standardUserDefaults().objectForKey("password") as? String,
            let campus = NSUserDefaults.standardUserDefaults().objectForKey("campus") as? String,
            let name = NSUserDefaults.standardUserDefaults().objectForKey("name") as? String,
            let campusName = NSUserDefaults.standardUserDefaults().objectForKey("campusName") as? String else {
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
        
        NSUserDefaults.standardUserDefaults().setObject(u.tia, forKey: "tia")
        NSUserDefaults.standardUserDefaults().setObject(u.password, forKey: "password")
        NSUserDefaults.standardUserDefaults().setObject(u.campus, forKey: "campus")
        NSUserDefaults.standardUserDefaults().setObject(u.name, forKey: "name")
        NSUserDefaults.standardUserDefaults().setObject(u.campusName, forKey: "campusName")
    }
    
    func logoff() {
        NSUserDefaults.standardUserDefaults().removeObjectForKey("statement")
        NSUserDefaults.standardUserDefaults().removeObjectForKey("tia")
        NSUserDefaults.standardUserDefaults().removeObjectForKey("password")
        NSUserDefaults.standardUserDefaults().removeObjectForKey("campus")
        NSUserDefaults.standardUserDefaults().removeObjectForKey("name")
        NSUserDefaults.standardUserDefaults().removeObjectForKey("campusName")
    }
    
    
    // MARK: Server Communication
    
    private func getRequestParameters() -> [String:String] {
        let parameters = [
            "mat": self.user?.tia ?? " ",
            "pass": self.user?.password ?? " ",
            "token": self.makeToken(),
            "unidade": self.user?.campus ?? " "
        ]
        return parameters
    }
    
    func sendRequest(service:ServiceURL, completionHandler:(jsonData:AnyObject?, error: ErrorCode?) -> Void) {

        // Problem with Reachability Method, some times return false, bust connection is ok
//        if Reachability.isConnectedToNetwork() == false {
//            completionHandler(jsonData: nil, error: ErrorCode.NoInternetConnection)
//            return
//        }
//        print(#function, "URL: \(service.rawValue)\nPARAMETERS: \(self.getRequestParameters())")
        
        guard let _ = self.alamoFireManager else {
            print(#function, "Não foi possível criar objeto Manager para conexão web")
            completionHandler(jsonData: nil, error: ErrorCode.DomainNotFound)
            return
        }
        
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        
        alamoFireManager!.request(.POST, service.rawValue, parameters: self.getRequestParameters()).responseJSON { response in
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            
            if response.result.error != nil {
                print(#function, response.result.error)
                completionHandler(jsonData: nil, error: ErrorCode.DomainNotFound)
                return
            } else {
                if let jsonData = response.result.value {
                    completionHandler(jsonData: jsonData, error: nil)
                    return
                } else {
                    completionHandler(jsonData: nil, error: ErrorCode.OtherFailure(title: NSLocalizedString("error_noDataFound_title", comment: "No data found"), message: NSLocalizedString("error_noDataFound_message", comment: "No data found")))
                    return
                }
            }
        }
    }
}
