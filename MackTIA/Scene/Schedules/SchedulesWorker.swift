//
//  SchedulesWorker.swift
//  MackTIA
//
//  Created by Luciano Moreira Turrini on 8/15/16.
//  Copyright (c) 2016 Mackenzie. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so you can apply
//  clean architecture to your iOS and Mac projects, see http://clean-swift.com
//

import UIKit

class SchedulesWorker {
    
    // MARK: Business Logic
    
    func fetchSchedules(completionHandler:(schedules:[Schedule], error: ErrorCode?) -> Void) {
        TIAServer.sharedInstance.sendRequest(.ClassSchedule) { (jsonData, error) in
            guard let _  = jsonData,
                response = jsonData!["resposta"] as? [NSDictionary] else {
                    
                    if let _ = jsonData?["erro"] as? String  {
                        let errorMessage = jsonData?["erro"]
                        print(#function, "Server report error: \(errorMessage)")
                        completionHandler(schedules: [], error: ErrorCode.InvalidLoginCredentials(title: NSLocalizedString("error_invalidLoginCredentials_title", comment: "User credentials error"), message: NSLocalizedString("error_invalidLoginCredentials_message", comment: "User credentials error")))
                        return
                    }
                    
                    let errorMessage = ErrorCode.OtherFailure(title: NSLocalizedString("schedules_InvalidDataTitle", comment: "Problem with grade data from API"), message: NSLocalizedString("schedules_InvalidDataMessage", comment: "Problem with absence data from API"))
                    
                    completionHandler(schedules: [], error: errorMessage)
                    return
            }
            
            if error != nil {
                completionHandler(schedules: [], error: error)
                return
            }
            
            
            completionHandler(schedules: self.parseJSON(response), error: nil)
        }
    }
    
    private func parseJSON(response:[AnyObject]) -> [Schedule] {
        
        var schedules:[Schedule] = []
        
        for scheduleData in response {
            
            // TODO: PEGAR O RESTO DOS ATRIBUTOS
            guard let
                discipline     = scheduleData["nome"] as? String,
                code           = scheduleData["codigo"] as? String,
                className      = scheduleData["turma"] as? String,
                collegeName    = scheduleData["escola_nome"] as? String,
                buildingNumber = scheduleData["predio"] as? String,
                numberRoom     = scheduleData["sala"] as? String,
                rangeTime      = scheduleData["hora"] as? String,
                day            = scheduleData["dia"] as? String,
                updateAt       = scheduleData["update"] as? String
            else {
                continue
            }
            
            // TODO: ADD OS ATRIBUTOS AQUI
            schedules.append(
                Schedule(code: code, discipline: discipline, day: day, className: className, collegeName: collegeName, buildingNumber: buildingNumber, numberRoom: numberRoom, rangeTime: rangeTime, updatedAt: updateAt)
            )
        }
        
        return schedules
    }
}
