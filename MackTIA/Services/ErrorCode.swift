//
//  ErrorCode.swift
//  MackTIA
//
//  Created by Joaquim Pessoa Filho on 14/04/16.
//  Copyright © 2016 Mackenzie. All rights reserved.
//

import Foundation

enum ErrorCode {
    case noInternetConnection
    case invalidLoginCredentials(title:String,message:String)
    case domainNotFound
    case otherFailure(title:String,message:String)
}
