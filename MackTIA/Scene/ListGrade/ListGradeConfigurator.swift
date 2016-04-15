//
//  ListGradeConfigurator.swift
//  MackTIA
//
//  Created by Joaquim Pessoa Filho on 14/04/16.
//  Copyright (c) 2016 Mackenzie. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so you can apply
//  clean architecture to your iOS and Mac projects, see http://clean-swift.com
//

import UIKit

// MARK: Connect View, Interactor, and Presenter

extension ListGradeTableViewController: ListGradePresenterOutput {
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        router.passDataToNextScene(segue)
    }
}

extension ListGradeInteractor: ListGradeTableViewControllerOutput {
}

extension ListGradePresenter: ListGradeInteractorOutput {
}

class ListGradeConfigurator {
    // MARK: Object lifecycle
    
    class var sharedInstance: ListGradeConfigurator {
        struct Static {
            static var instance: ListGradeConfigurator?
            static var token: dispatch_once_t = 0
        }
        
        dispatch_once(&Static.token) {
            Static.instance = ListGradeConfigurator()
        }
        
        return Static.instance!
    }
    
    // MARK: Configuration
    
    func configure(viewController: ListGradeTableViewController) {
        let router = ListGradeRouter()
        router.viewController = viewController
        
        let presenter = ListGradePresenter()
        presenter.output = viewController
        
        let interactor = ListGradeInteractor()
        interactor.output = presenter
        
        viewController.output = interactor
        viewController.router = router
    }
}
