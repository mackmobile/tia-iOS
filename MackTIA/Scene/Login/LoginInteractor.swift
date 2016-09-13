//
//  LoginInteractor.swift
//  MackTIA
//
//  Created by Joaquim Pessoa Filho on 14/04/16.
//  Copyright (c) 2016 Mackenzie. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so you can apply
//  clean architecture to your iOS and Mac projects, see http://clean-swift.com
//

import UIKit

protocol LoginInteractorInput {
    func validateLogin(_ request: LoginRequest)
}

protocol LoginInteractorOutput {
    func presentLoginError(_ response: LoginResponse)
    func presentLoginAccepted()
}

class LoginInteractor: LoginInteractorInput {
    var output: LoginInteractorOutput!
    var worker: LoginWorker!
    
    // MARK: Business logic
    
    func validateLogin(_ request: LoginRequest) {
        // NOTE: Create some Worker to do the work
        
        worker = LoginWorker()
        worker.validateLogin(request) { [unowned self] (response, error) in
            if response {
                self.output.presentLoginAccepted()
            } else {
                let response = LoginResponse(error: error)
                self.output.presentLoginError(response)
            }
        }
    }
}
