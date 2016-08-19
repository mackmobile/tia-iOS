//
//  ListGradeWorker.swift
//  MackTIA
//
//  Created by Joaquim Pessoa Filho on 14/04/16.
//  Copyright (c) 2016 Mackenzie. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so you can apply
//  clean architecture to your iOS and Mac projects, see http://clean-swift.com
//

import UIKit

class ListGradeWorker {
    
    // MARK: Business Logic
    
    func fetchGrades(completionHandler: (grades: [Grade], error: ErrorCode?)->Void) {
        TIAServer.sharedInstance.sendRequet(ServiceURL.Grades) { (jsonData, error) in
        
            if error != nil {
                completionHandler(grades: [], error: error)
                return
            }

            let grades = self.parseJSON(jsonData)
            
            guard let safeGrades = grades else {
                completionHandler(grades: [],error: ErrorCode.OtherFailure(title: NSLocalizedString("grade_InvalidDataTitle", comment: "Problem with grade data from API"), message: NSLocalizedString("grade_InvalidDataMessage", comment: "Problem with grade data from API")))
                return
            }
            
            if let _ = jsonData?["erro"] as? String  {
                let errorMessage = jsonData?["erro"]
                print(#function, "Server report error: \(errorMessage)")
                completionHandler(grades: [], error: ErrorCode.InvalidLoginCredentials(title: NSLocalizedString("error_invalidLoginCredentials_title", comment: "User credentials error"), message: NSLocalizedString("error_invalidLoginCredentials_message", comment: "User credentials error")))
                return
            }
            
            completionHandler(grades: safeGrades, error: nil)
        }
    }
    
    private func parseJSON(response:AnyObject?) -> [Grade]? {
        
        guard let jsonData = response as? [String:AnyObject] else {
            print(#function, "JSON format is incorrect")
            return nil
        }
        
        guard let json = jsonData["resposta"] as? [AnyObject] else {
            print(#function, "JSON doesn't have \"resposta\" key")
            return nil
        }
        
        // Auxiliar variables
        var grades:[Grade] = []
        let emptyField = "-"
        
        for gradeData in json {
            guard let gradeAux = gradeData as? [String:AnyObject] else {
                print(#function, "Error during parse grade")
                return nil
            }
            
            let classCode   = gradeAux["codigo"] as? String ?? emptyField
            let className   = gradeAux["disciplina"] as? String ?? emptyField
            let schoolName  = gradeAux["escola_nome"] as? String ?? emptyField
            let schoolCode  = gradeAux["escola"] as? String ?? emptyField
            let formula     = gradeAux["formula"] as? String ?? emptyField
            let gradeDetail = gradeAux["notas"] as? [String:String] ?? ["-":"-"]
            
            let grade = Grade(classCode: classCode, className: className, schoolName: schoolName, schoolCode: schoolCode, formula: formula, grades: gradeDetail)
            grades.append(grade)
        }
        
        return grades
    }
}
