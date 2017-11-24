//
//  ListGradeModels.swift
//  MackTIA
//
//  Created by Joaquim Pessoa Filho on 14/04/16.
//  Copyright (c) 2016 Mackenzie. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so you can apply
//  clean architecture to your iOS and Mac projects, see http://clean-swift.com
//

import UIKit

struct ListGradeRequest {
}

struct ListGradeResponse {
    var grades:[Grade]
    var error:ErrorCode?
}

struct ListGradeViewModel {
    struct Success {
        var grades:[Grade]
    }
    struct Error {
        var errorMessage:String
        var errorTitle:String
    }
}
