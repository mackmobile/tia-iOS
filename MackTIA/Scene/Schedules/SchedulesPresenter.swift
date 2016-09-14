//
//  SchedulesPresenter.swift
//  MackTIA
//
//  Created by Luciano Moreira Turrini on 8/15/16.
//  Copyright (c) 2016 Mackenzie. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so you can apply
//  clean architecture to your iOS and Mac projects, see http://clean-swift.com
//

import UIKit

protocol SchedulesPresenterInput {
    func presentFetchedSchedules(_ response: SchedulesResponse)
}

protocol SchedulesPresenterOutput: class {
    func displayFetchedSchedules(_ viewModel: SchedulesViewModel.Success)
    func displayFetchedSchedulesError(_ viewModel: SchedulesViewModel.Error)
}

class SchedulesPresenter: SchedulesPresenterInput {
    
    weak var output: SchedulesPresenterOutput!
    
    // MARK: Presentation logic
    
    func presentFetchedSchedules(_ response: SchedulesResponse) {
        
        guard response.error == nil else {
            let error:(title:String,message:String) = ErrorParser.parse(response.error!)
            let viewModel = SchedulesViewModel.Error(errorMessage: error.message, errorTitle: error.title)
            output.displayFetchedSchedulesError(viewModel)
            return
        }
        
        
        // Ordena as aulas para mesclar aulas consecutivas da mesma disciplina e local
        var orderedSchedule = response.schedules.sorted(by: {
            if ($0.day ?? "") == ($1.day ?? "") {
                return ($0.startTime ?? Date()) < ($1.startTime ?? Date())
            }
            return ($0.day ?? "") < ($1.day ?? "")
        })
        
        
        // Combina aulas consecutivas da mesma disciplina no mesmo local
        var index = 0
        while true {
            if orderedSchedule.count == (index + 1) {
                break
            }
            
            if orderedSchedule[index] == orderedSchedule[index+1] {
                orderedSchedule[index].endTime = orderedSchedule[index+1].endTime
                orderedSchedule.remove(at: index+1)
                continue
            }
            index += 1
        }
        
        
        // Cria um dicionario usando o dia da semana como chave
        // A view precisa que o dicionario tenha previsto todos os dias
        var filteredSchedules : [Int : [Schedule]] = [1:[],2:[],3:[],4:[],5:[],6:[],7:[]]
        
        for schedule in orderedSchedule {
            if let day = Int(schedule.day ?? "0") {
                var scds = filteredSchedules[day]
                scds = scds ?? [Schedule]()
                scds?.append(schedule)
                filteredSchedules[day] = scds
            }
        }
        
        let viewModel = SchedulesViewModel.Success(displayedSchedules: filteredSchedules)
        output.displayFetchedSchedules(viewModel)
        
    }
}
