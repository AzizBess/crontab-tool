//
//  CronConfiguration.swift
//  Write Your Own Crontab Tool
//
//  Created by Aziz Bessrour on 2023-10-30.
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

final class CronConfiguration {
    // MARK: - Allowed Symbols
    static let listSeparator = ","
    static let rangeSeparator = "-"
    static let stepSeparator = "/"
    static let anySymbol = "*"
    static let questionSymbol = "?"
    static let LSymbol = "L"
    static let WSymbol = "W"
    static let hashtagSymbol = "#"
        
    static let separationCharacters = [CronConfiguration.listSeparator, CronConfiguration.rangeSeparator, CronConfiguration.stepSeparator]
    static let singleSpecialCharacters: [String] = [CronConfiguration.anySymbol]
    
    // MARK: - Allowed Short Symbols
    static let monthsSymbolRange = DateFormatter().shortMonthSymbols.compactMap { String($0).uppercased() }
    static let dayOfWeekSymbolRange = DateFormatter().shortWeekdaySymbols.compactMap { String($0).uppercased() }

    // MARK: - Allowed Integers
    static let minutesRange = 0...59
    static let hoursRange = 0...23
    static let dayOfMonthIntRange = 1...31
    static let monthsIntRange = 1...12
    static let dayOfWeekIntRange = 0...6
}
