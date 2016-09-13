//
//  ErrorParser.swift
//  MackTIA
//
//  Created by Joaquim Pessoa Filho on 18/04/16.
//  Copyright © 2016 Mackenzie. All rights reserved.
//

import UIKit

class ErrorParser: NSObject {
    class func parse(_ error:ErrorCode) -> (title:String,message:String) {
        var errorTitle:String = ""
        var errorMessage:String = ""
        
        switch error {
        case let .invalidLoginCredentials(title,message):
            errorTitle = title
            errorMessage = message
        case .noInternetConnection:
            errorTitle = NSLocalizedString("error_noInternetConnection_title", comment: "Internet problem")
            errorMessage = NSLocalizedString("error_noInternetConnection_message", comment: "Internet problem")
        case .domainNotFound:
            errorTitle = NSLocalizedString("error_domainNotFound_title", comment: "Domain problem")
            errorMessage = NSLocalizedString("error_domainNotFound_message", comment: "Domain problem")
        case let .otherFailure(title, message):
            errorTitle = title
            errorMessage = message
        }
        
        return (title:errorTitle, message:errorMessage)
    }
}
