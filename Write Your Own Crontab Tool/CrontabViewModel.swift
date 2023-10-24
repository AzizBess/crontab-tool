//
//  CrontabViewModel.swift
//  Write Your Own Crontab Tool
//
//  Created by Aziz Bessrour on 2023-10-22.
//

import SwiftUI

class CrontabViewModel: ObservableObject {
    @Published var errors = [CustomError?]()
    
    let symbolsMeaning: [(symbol: String, meaning: String)] =
    [
        (symbol: "*", meaning: "any value (wildcard)"),
        (symbol:",", meaning: "list separator (i.e.: 0, 15, 30, 45)"),
        (symbol:"-", meaning: "ranger separator (i.e. 1-5)"),
        (symbol:"/", meaning: "step values (i.e. 1/10)")
    ]

    func cronPatternDidChange(_ cronPattern: String) {
        guard cronPattern.components(separatedBy: " ").count == 5 else {
            // Display Error (cronPattern size is not complete YET !!!)
            return
        }

        errors.removeAll()

        errors = Field.allCases.compactMap {
            ValidationManager.shared.validateField($0, cronPattern: cronPattern)
        }
    }
}
