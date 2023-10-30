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
    func validateField(_ field: Field, cronPattern: String) -> CustomError? {
        guard let value = field.value(from: cronPattern) else { return nil }
        return validateValue(
            value,
            field: field
        )
    }
    
    private func validateValue(_ value: String, field: Field) -> CustomError? {
        var error: CustomError?
        
        if let intValue = Int(value) {
            error = validateIntValue(intValue, field: field)
        } else {
            error = validateStringValue(value, field: field)
        }
        
        return error
    }
}

// MARK: - Type Validation
private extension ValidationManager {
    func validateIntValue(_ value: Int, field: Field) -> CustomError? {
        var error: CustomError?
        let intRange = field.integerRange
        if !intRange.contains(value) {
            error = ErrorGenerator.shared.generate(for: field, value: String(value))
        }
        return error
    }
    
    func validateStringValue(_ value: String, field: Field) -> CustomError? {
        var error: CustomError?
        
        if value.count == 1 {
            let singleSpecialCharacters = field.singleSpecialCharacters
            if !singleSpecialCharacters.contains(value) {
                error = ErrorGenerator.shared.generate(for: field, value: value)
            }
        } else {
            let separators = value.filter({ CronConfiguration.separationCharacters.contains(String($0)) })
            if !separators.isEmpty {
                error = validateListSeparator(value, field: field) ??
                validateRangeSeparator(value, field: field) ??
                validateStepSeparator(value, field: field)
            } else {
                error = validateSymbolValue(value, field: field)
            }
        }
        
        return error
    }

    func validateSymbolValue(_ value: String, field: Field) -> CustomError? {
        var error: CustomError?
        
        if let symbolRange = field.symbolRange, !symbolRange.contains(value) {
            error = ErrorGenerator.shared.generate(for: field, value: value)
        }
        
        return error
    }

    func validateListSeparator(_ value: String, field: Field) -> CustomError? {
        guard value.contains(CronConfiguration.listSeparator) else { return nil }
        var error: CustomError?
        
        let components = value.components(separatedBy: CronConfiguration.listSeparator).filter({ !$0.isEmpty })
        error = components.compactMap {
            validateValue($0, field: field)
        }.first
        
        return error
    }
    
    func validateRangeSeparator(_ value: String, field: Field) -> CustomError? {
        guard value.contains(CronConfiguration.rangeSeparator) else { return nil }
        var error: CustomError?
        let components = value.components(separatedBy: CronConfiguration.rangeSeparator).filter({ !$0.isEmpty })
        if components.count == 2 {
            error = components.compactMap {
                validateValue($0, field: field)
            }.first
        } else {
            error = ErrorGenerator.shared.generate(for: field, value: value, customMessage: "You need to provide exactly two values around the '\(CronConfiguration.rangeSeparator)' separator.")
        }
        return error
    }
    
    func validateStepSeparator(_ value: String, field: Field) -> CustomError? {
        guard value.contains(CronConfiguration.stepSeparator) else { return nil }
        var error: CustomError?
        let components = value.components(separatedBy: CronConfiguration.stepSeparator).filter({ !$0.isEmpty })
        if components.count == 2 {
            error = components.compactMap {
                validateValue($0, field: field)
            }.first
        } else {
            error = ErrorGenerator.shared.generate(for: field, value: value, customMessage: "You need to provide exactly two values around the '\(CronConfiguration.stepSeparator)' separator.")
        }
        
        return error
    }
}

// MARK: - Field Helpers
extension Field {
    func value(from cronPattern: String) -> String? {
        let fieldIndex = rawValue
        let components = cronPattern.components(separatedBy: " ").filter({ !$0.isEmpty })
        guard components.indices.contains(fieldIndex) else { return nil }
        return components[fieldIndex]
    }
    
    var integerRange:ClosedRange<Int> {
        switch self {
        case .minutes:
            return CronConfiguration.minutesRange
        case .hours:
            return CronConfiguration.hoursRange
        case .dayOfMonth:
            return CronConfiguration.dayOfMonthIntRange
        case .months:
            return CronConfiguration.monthsIntRange
        case .dayOfWeek:
            return CronConfiguration.dayOfWeekIntRange
        }
    }
    
    var singleSpecialCharacters: [String] {
        switch self {
        case .minutes:
            return CronConfiguration.singleSpecialCharacters
        case .hours:
            return CronConfiguration.singleSpecialCharacters
        case .dayOfMonth:
            return CronConfiguration.singleSpecialCharacters + [CronConfiguration.questionSymbol, CronConfiguration.LSymbol, CronConfiguration.WSymbol]
        case .months:
            return CronConfiguration.singleSpecialCharacters
        case .dayOfWeek:
            return CronConfiguration.singleSpecialCharacters + [CronConfiguration.questionSymbol, CronConfiguration.LSymbol, CronConfiguration.hashtagSymbol]
        }
    }
    
    var symbolRange: [String]? {
        switch self {
        case .months:
            return CronConfiguration.monthsSymbolRange
        case .dayOfWeek:
            return CronConfiguration.dayOfWeekSymbolRange
        default:
            return nil
        }
    }
}
