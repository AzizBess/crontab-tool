//
//  ValidationManager.swift
//  Write Your Own Crontab Tool
//
//  Created by Aziz Bessrour on 2023-10-24.
//

import Foundation

//# ┌───────────── minute (0–59)
//# │ ┌───────────── hour (0–23)
//# │ │ ┌───────────── day of the month (1–31)
//# │ │ │ ┌───────────── month (1–12)
//# │ │ │ │ ┌───────────── day of the week (0–6) (Sunday to Saturday;
//# │ │ │ │ │                                   7 is Sunday on some systems)
//# │ │ │ │ │
//# │ │ │ │ │
//# * * * * * <command>

class ValidationManager {
    static let shared = ValidationManager()

    private let separationCharacters = ["-", ",", "/"]
    private let singleSpecialCharacters: [String] = ["*"]
    
    private let minutesRange = 0...59
    private let hoursRange = 0...23
    private let dayOfMonthIntRange = 1...31
    
    private let monthsIntRange = 1...12
    private let monthsSymbolRange = DateFormatter().shortMonthSymbols.compactMap { String($0).uppercased() }
    private let dayOfWeekIntRange = 0...6
    let dayOfWeekSymbolRange = DateFormatter().shortWeekdaySymbols.compactMap { String($0).uppercased() }
    
    func validateField(_ field: Field, cronPattern: String) -> CustomError? {
        validateValue(
            value(for: field, cronPattern),
            field: field,
            intRange: integerRange(for: field),
            singleSpecialCharacters: singleSpecialCharacters(for: field)
        )
    }
    
    private func validateValue(
        _ value: String,
        field: Field,
        intRange: ClosedRange<Int>,
        singleSpecialCharacters: [String]
    ) -> CustomError? {
        
        var error: CustomError?
        
        if let intValue = Int(value) {
            error = validateIntValue(intValue, field: field, intRange: intRange)
        } else {
            error = validateStringValue(value, field: field, intRange: intRange)
        }
        
        return error
    }
    
    private func validateIntValue(_ value: Int, field: Field, intRange: ClosedRange<Int>) -> CustomError? {
        var error: CustomError?
        if !intRange.contains(value) {
            error = generateError(for: field, value: String(value), rangeDescription: intRange.description)
        }
        return error
    }
    
    private func validateStringValue(_ value: String, field: Field, intRange: ClosedRange<Int>) -> CustomError? {
        var error: CustomError?
        
        if value.count == 1 {
            if !singleSpecialCharacters.contains(value) {
                error = generateError(for: field, value: value, rangeDescription: "[\(singleSpecialCharacters.joined(separator: ", "))]")
            }
        } else {
            let separators = Set(value.map { String($0) }).intersection(Set(separationCharacters))
            if !separators.isEmpty {
                error = separators.compactMap {
                    value.components(separatedBy: $0).compactMap {
                        return validateValue(
                            $0,
                            field: field,
                            intRange: intRange,
                            singleSpecialCharacters: singleSpecialCharacters
                        )
                    }.first
                }.first
            } else {
                error = validateSymbolValue(value, field: field)
            }
        }
        
        return error
    }
    
    private func validateSymbolValue(_ value: String, field: Field) -> CustomError? {
        var error: CustomError?
        
        if let symbolRange = symbolRange(for: field), !symbolRange.contains(value) {
            error = generateError(for: field, value: value, rangeDescription: "[\(symbolRange.joined(separator: ", "))]")
        }
        
        return error
    }
    
    private func value(for field: Field, _ cronPattern: String) -> String {
        cronPattern.components(separatedBy: " ")[field.rawValue]
    }
    
    private func integerRange(for field: Field) -> ClosedRange<Int> {
        switch field {
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
    
    private func singleSpecialCharacters(for field: Field) -> [String] {
        switch field {
        case .minutes:
            return singleSpecialCharacters
        case .hours:
            return singleSpecialCharacters
        case .dayOfMonth:
            return singleSpecialCharacters + ["?", "L", "W"]
        case .months:
            return singleSpecialCharacters
        case .dayOfWeek:
            return singleSpecialCharacters + ["?", "L", "#"]
        }
    }
    
    private func symbolRange(for field: Field) -> [String]? {
        switch field {
        case .months:
            return monthsSymbolRange
        case .dayOfWeek:
            return dayOfWeekSymbolRange
        default:
            return nil
        }
    }
    
    private func generateError(for field: Field, value: String, rangeDescription: String) -> CustomError {
        return CustomError(
            title: ["(", field.displayName.capitalized, ")"].joined(),
            description: "Expression '\(value)' is not a valid increment value. Accepted values are \(rangeDescription)"
        )
    }
}

struct CustomError: LocalizedError {
    var title: String
    var errorDescription: String { return _description }
    var failureReason: String? { return _description }
    
    private var _description: String
    
    init(title: String, description: String) {
        self.title = title
        self._description = description
    }
}

enum Field: Int, CaseIterable {
    case minutes
    case hours
    case dayOfMonth
    case months
    case dayOfWeek
    
    var displayName: String {
        switch self {
        case .minutes:
            return "Minutes"
        case .hours:
            return "Hours"
        case .dayOfMonth:
            return "Day Of Month"
        case .months:
            return "Months"
        case .dayOfWeek:
            return "Day Of Week"
        }
    }
}
