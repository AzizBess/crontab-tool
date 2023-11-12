//
//  Field.swift
//  Write Your Own Crontab Tool
//
//  Created by Aziz Bessrour on 2023-10-30.
//

import Foundation

enum Field: Int, CaseIterable {
    case minutes
    case hours
    case dayOfWeek
    case dayOfMonth
    case months
    
    var position: Int {
        switch self {
        case .minutes:
            return 0
        case .hours:
            return 1
        case .dayOfMonth:
            return 2
        case .months:
            return 3
        case .dayOfWeek:
            return 4
        }
    }
    
    var displayName: String {
        switch self {
        case .minutes:
            return "minute"
        case .hours:
            return "hour"
        case .dayOfMonth:
            return "day of the month"
        case .months:
            return "month"
        case .dayOfWeek:
            return "day of the week"
        }
    }
    
    var displayNamePluaral: String {
        switch self {
        case .dayOfMonth:
            return "days of the month"
        case .dayOfWeek:
            return "days of the week"
        default:
            return [displayName, "s"].joined()
        }
        
    }
    
    var prefix: String {
        switch self {
        case .minutes:
            return "at"
        case .hours:
            return "past"
        case .dayOfMonth, .dayOfWeek:
            return "on"
        case .months:
            return "in"
        }
    }
}

// MARK: - Validation - Field Helpers
extension Field {
    func value(from cronPattern: String) -> String? {
        let fieldIndex = position
        let components = cronPattern.components(separatedBy: whitespaceCharacter).filter({ !$0.isEmpty })
        guard components.indices.contains(fieldIndex) else { return nil }
        return components[fieldIndex]
    }
    
    var integerRange:ClosedRange<Int> {
        switch self {
        case .minutes:
            return minutesRange
        case .hours:
            return hoursRange
        case .dayOfMonth:
            return dayOfMonthIntRange
        case .months:
            return monthsIntRange
        case .dayOfWeek:
            return dayOfWeekIntRange
        }
    }
    
    var singleSpecialCharacters: [String] {
        switch self {
        case .minutes:
            return singleSpecialCharacterss
        case .hours:
            return singleSpecialCharacterss
        case .dayOfMonth:
            return singleSpecialCharacterss + [questionSymbol, LSymbol, WSymbol]
        case .months:
            return singleSpecialCharacterss
        case .dayOfWeek:
            return singleSpecialCharacterss + [questionSymbol, LSymbol, hashtagSymbol]
        }
    }
    
    var separationCharacters: [String] {
        switch self {
        case .dayOfWeek:
            return separationCharacterss + CollectionOfOne(hashtagSymbol)
        default:
            return separationCharacterss
        }
    }
    
    var symbolRange: [String]? {
        switch self {
        case .months:
            return monthsSymbolRange
        case .dayOfWeek:
            return dayOfWeekSymbolRange
        default:
            return nil
        }
    }
    
    var fullSymbolRange: [String]? {
        switch self {
        case .months:
            return monthsFullSymbolRange
        case .dayOfWeek:
            return dayOfWeekFullSymbolRange
        default:
            return nil
        }
    }
}
