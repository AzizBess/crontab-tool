//
//  ValidationService.swift
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

class ValidationService {
    static let shared = ValidationService()
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
private extension ValidationService {
    func validateIntValue(_ value: Int, field: Field) -> CustomError? {
        var error: CustomError?
        let intRange = field.integerRange
        if !intRange.contains(value) {
            error = CustomErrorService.shared.generateError(for: field, value: String(value))
        }
        return error
    }
    
    func validateStringValue(_ value: String, field: Field) -> CustomError? {
        var error: CustomError?
        
        if value.count == 1 && !field.separationCharacters.contains(value) {
            let singleSpecialCharacters = field.singleSpecialCharacters
            if !singleSpecialCharacters.contains(value) {
                error = CustomErrorService.shared.generateError(for: field, value: value)
            }
        } else {
            let separators = value.filter({ field.separationCharacters.contains(String($0)) })
            if !separators.isEmpty {
                error = validateListSeparator(value, field: field) ??
                validateRangeSeparator(value, field: field) ??
                validateStepSeparator(value, field: field) ??
                validateHashtagSeparator(value, field: field)
            } else {
                error = validateSymbolValue(value, field: field)
            }
        }
        
        return error
    }

    func validateSymbolValue(_ value: String, field: Field) -> CustomError? {
        var error: CustomError?
        
        if let symbolRange = field.symbolRange, !symbolRange.contains(value) {
            error = CustomErrorService.shared.generateError(for: field, value: value)
        }
        
        return error
    }

    func validateListSeparator(_ value: String, field: Field) -> CustomError? {
        guard value.contains(listSeparator) else { return nil }
        var error: CustomError?
        
        let components = value.components(separatedBy: listSeparator).filter({ !$0.isEmpty })
        error = components.compactMap {
            validateValue($0, field: field)
        }.first
        
        return error
    }
    
    func validateRangeSeparator(_ value: String, field: Field) -> CustomError? {
        validateTwoValueSeparator(value, field: field, separator: rangeSeparator)
    }
    
    func validateStepSeparator(_ value: String, field: Field) -> CustomError? {
        validateTwoValueSeparator(value, field: field, separator: stepSeparator)
    }
    
    func validateHashtagSeparator(_ value: String, field: Field) -> CustomError? {
        guard field == .dayOfWeek else { return nil }
        return validateTwoValueSeparator(value, field: field, separator: hashtagSymbol)
    }
    
    func validateTwoValueSeparator(_ value: String, field: Field, separator: String) -> CustomError? {
        guard value.contains(separator) else { return nil }
        var error: CustomError?
        let components = value.components(separatedBy: separator).filter({ !$0.isEmpty })
        if components.count == 2 {
            error = components.compactMap {
                validateValue($0, field: field)
            }.first
        } else {
            error = CustomErrorService.shared.generate(for: field, value: value, customMessage: "You need to provide exactly two values around the '\(separator)' separator.")
        }

        return error
    }
}
