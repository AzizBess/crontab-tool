//
//  CrontabViewModel.swift
//  Write Your Own Crontab Tool
//
//  Created by Aziz Bessrour on 2023-10-22.
//

import SwiftUI

class CrontabViewModel: ObservableObject {
    @Published var errors = [CustomError]()
    @Published var interpretation = String()
    
    let symbolsMeaning: [(symbol: String, meaning: String)] =
    [
        (symbol: starSymbol, meaning: "any value (wildcard)"),
        (symbol: listSeparator, meaning: "list separator (i.e.: 0, 15, 30, 45)"),
        (symbol: rangeSeparator, meaning: "ranger separator (i.e. 1-5)"),
        (symbol: stepSeparator, meaning: "step values (i.e. 1/10)"),
        (symbol: questionSymbol, meaning: "no specific value"),
        (symbol: LSymbol, meaning: "last, as in last day of the week"),
        (symbol: WSymbol, meaning: "weekday, Monday-Friday"),
        (symbol: hashtagSymbol, meaning: "specify 'the nth' XXX day of the month")
    ]

    func incomplete(_ cronPattern: String) -> Bool {
        cronPattern.components(separatedBy: whitespaceCharacter).filter({ !$0.isEmpty }).count != 5
    }
   
    func validityColor(for cronPattern: String) -> Color {
        if cronPattern.isEmpty {
            return Color.gray
        }
        if incomplete(cronPattern) {
            return Color.orange
        }
        if !errors.isEmpty {
            return Color.red
        } else {
            return Color.green
        }
    }
    

    var errorString: String? {
        guard !errors.isEmpty else { return nil }
        return errors.compactMap {
            [$0.title.capitalized, ": ", $0.errorDescription].joined()
        }
        .joined(separator: "\n")
    }
    
    func cronPatternDidChange(_ cronPattern: String) {
        guard cronPattern.components(separatedBy: whitespaceCharacter).filter({ !$0.isEmpty }).count == 5 else {
            // Display Error (cronPattern size is not complete YET !!!)
            return
        }

        errors.removeAll()

        errors = Field.allCases.compactMap {
            ValidationService.shared.validateField($0, cronPattern: cronPattern)
        }
        
        if errors.isEmpty {
            interpretation = InterpretationService.shared.translateCronExpression(cronPattern)
        } else {
            interpretation.removeAll()
        }
    }
}
