//
//  CronExpression.swift
//  Write Your Own Crontab Tool
//
//  Created by Aziz Bessrour on 2023-11-11.
//

import Foundation

enum CronExpression {
    case integer(_ value: Int, _ field: Field)
    case character(_ value: Character, _ field: Field)
    case shortSymbol(_ symbol: String, _ field: Field)
    case range(_ values: [String], _ field: Field)
    case list(_ values: [String], _ field: Field)
    case complexList(_ values: [String], _ field: Field)
    case step(_ values: [String], _ field: Field)
    
    case unknown(_ value: String, _ field: Field)
    
    init(from cronPattern: String, _ field: Field) {
        guard let value = field.value(from: cronPattern) else {
            self = .unknown(cronPattern, field)
            return
        }
        
        if let integer = Int(value) {
            self = .integer(integer, field)
            return
        }
        if value.count == 1 {
            self = .character(Character(value), field)
            return
        }
        
        if value.isRange {
            let components = value.components(separatedBy: rangeSeparator)
            self = .range(components, field)
            return
        }
        
        // NOTE: - It's important to call check list seprator first!!!
        if value.contains(listSeparator) {
            let components = value.components(separatedBy: listSeparator)
            if value.isComplexList {
                self = .complexList(components, field)
                return
            } else {
                self = .list(components, field)
                return
            }
        }
        
        if value.isStep {
            let components = value.components(separatedBy: stepSeparator)
            self = .step(components, field)
            return
        }
        
        if value.isShortSymbol {
            self = .shortSymbol(value, field)
            return
        }
        self = .unknown(cronPattern, field)
    }
    
}
