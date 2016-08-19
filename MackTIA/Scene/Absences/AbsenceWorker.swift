//
//  AbsenceWorker.swift
//  MackTIA
//
//  Created by Aleph Retamal on 4/15/16.
//  Copyright (c) 2016 Mackenzie. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so you can apply
//  clean architecture to your iOS and Mac projects, see http://clean-swift.com
//

import UIKit

class AbsenceWorker {
    
    // MARK: Business Logic
    
    func fetchAbsences(completionHandler:(absences:[Absence], error: ErrorCode?) -> Void) {
        TIAServer.sharedInstance.sendRequest(.Absence) { (jsonData, error) in
            guard let _  = jsonData,
                response = jsonData!["resposta"] as? [NSDictionary] else {
                    
                    if let _ = jsonData?["erro"] as? String  {
                        let errorMessage = jsonData?["erro"]
                        print(#function, "Server report error: \(errorMessage)")
                        completionHandler(absences: [], error: ErrorCode.InvalidLoginCredentials(title: NSLocalizedString("error_invalidLoginCredentials_title", comment: "User credentials error"), message: NSLocalizedString("error_invalidLoginCredentials_message", comment: "User credentials error")))
                        return
                    }
                    
                    let errorMessage = ErrorCode.OtherFailure(title: NSLocalizedString("absence_InvalidDataTitle", comment: "Problem with grade data from API"), message: NSLocalizedString("absence_InvalidDataMessage", comment: "Problem with absence data from API"))
                    
                    completionHandler(absences: [], error: errorMessage)
                    return
            }
            
            if error != nil {
                completionHandler(absences: [], error: error)
                return
            }
            
            
            completionHandler(absences: self.parseJSON(response), error: nil)
        }
    }
    
    private func parseJSON(response:[AnyObject]) -> [Absence] {
        var absences:[Absence] = []
        
        for absenceData in response {
            
            // TODO: PEGAR O RESTO DOS ATRIBUTOS
            guard let
                atualizacao = absenceData["atualizacao"] as? String,
                codigo      = absenceData["codigo"] as? String,
                dadas       = absenceData["dadas"] as? Int,
                disciplina  = absenceData["disciplina"] as? String,
                faltas      = absenceData["faltas"] as? Int,
                percentual  = absenceData["percentual"] as? Float,
                permit      = absenceData["permit"] as? Int,
                permit20    = absenceData["permit20"] as? Int,
                turma       = absenceData["turma"] as? String
                else {
                    continue
            }
            
            // TODO: ADD OS ATRIBUTOS AQUI
            absences.append(
                Absence(atualizacao: atualizacao,
                    codigo: codigo,
                    dadas: dadas,
                    disciplina: disciplina,
                    faltas: faltas,
                    percentual: percentual,
                    permit: permit,
                    permit20: permit20,
                    turma: turma)
            )
        }
        
        return absences
    }
}
