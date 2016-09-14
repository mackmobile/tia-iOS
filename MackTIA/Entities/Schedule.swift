//
//  Schedule.swift
//  MackTIA
//
//  Created by Luciano Moreira Turrini on 8/17/16.
//  Copyright © 2016 Mackenzie. All rights reserved.
//

import Foundation

struct Schedule {
    
    var code: String?
    var discipline: String?
    var day: String?
    var className: String?
    var collegeName: String?
    var buildingNumber: String?
    var numberRoom: String?
    var startTime: Date?
    var endTime: Date?
    var updatedAt: String?

}

extension Schedule {
    static func ==(left:Schedule, right:Schedule) -> Bool {
        if left.code != right.code {
            return false
        }
        
        if left.discipline != right.discipline {
            return false
        }
        
        if left.day != right.day {
            return false
        }
        
        if left.buildingNumber != right.buildingNumber {
            return false
        }
        
        if left.numberRoom != right.numberRoom {
            return false
        }
        
        if left.endTime != right.startTime {
            return false
        }
        
        return true
    }
    
    static func <(left:Schedule, right:Schedule) -> Bool {
        if (left.day ?? "") == (right.day ?? "") {
            return (left.startTime ?? Date()) < (right.startTime ?? Date())
        }
        
        return (left.day ?? "") < (right.day ?? "")
    }
}
