//
//  AbsencePresenter.swift
//  MackTIA
//
//  Created by Aleph Retamal on 4/15/16.
//  Copyright (c) 2016 Mackenzie. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so you can apply
//  clean architecture to your iOS and Mac projects, see http://clean-swift.com
//

import UIKit

protocol AbsencePresenterInput {
    func presentFetchedAbsences(response: AbsenceResponse)
}

protocol AbsencePresenterOutput: class {
    func displayFetchedAbsences(viewModel: AbsenceViewModel.Success)
    func displayFetchedAbsencesError(viewModel: AbsenceViewModel.Error)
}

class AbsencePresenter: AbsencePresenterInput
{
    weak var output: AbsencePresenterOutput!
    
    // MARK: Presentation logic
    
    func presentFetchedAbsences(response: AbsenceResponse) {
        
        guard response.error == nil else {
            let error:(title:String,message:String) = ErrorParser.parse(response.error!)
            let viewModel = AbsenceViewModel.Error(errorMessage: error.message, errorTitle: error.title)
            output.displayFetchedAbsencesError(viewModel)
            return
        }
        
        // Remove absences without presence classe
        var absences = response.absences.filter { (absence) -> Bool in
            return absence.dadas > 0
        }
        
        absences = absences.map { (absence) -> Absence in
            var ab = absence
            if absence.atualizacao == "00/00/0000" {
                // TODO: localizable.string
                ab.atualizacao = "sem novidades"
            }
            return ab
        }
        
        let viewModel = AbsenceViewModel.Success(displayedAbsences: absences)
        output.displayFetchedAbsences(viewModel)
    }
}
