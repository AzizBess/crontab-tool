//
//  ErrorGenerator.swift
//  Write Your Own Crontab Tool
//
//  Created by Aziz Bessrour on 2023-10-30.
//

import Foundation

class ErrorGenerator {
    static let shared = ErrorGenerator()
    
    func generate(for field: Field, value: String) -> CustomError {
        return CustomError(
            title: ["(", field.displayName.capitalized, ")"].joined(),
            description: "Expression '\(value)' is not a valid value. Accepted values are [\(rangeDescriptor(value: value, field: field) ?? "Error Generating the range desciption")]"
        )
    }
    
    func generate(for field: Field, value: String, customMessage: String) -> CustomError {
        return CustomError(
            title: ["(", field.displayName.capitalized, ")"].joined(),
            description: "Expression '\(value)' is not a valid value. \(customMessage)"
        )
    }
    
    private func rangeDescriptor(value: String, field: Field) -> String? {
        if let intValue = Int(value) {
            return field.integerRange.description
        } else {
            if value.count == 1 {
                return field.singleSpecialCharacters.joined(separator: ", ")
            } else {
                if let symbolRange = field.symbolRange {
                    return symbolRange.joined(separator: ", ")
                }
            }
        }

        return nil
    }
}
