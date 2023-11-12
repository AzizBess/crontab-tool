//
//  CronConfigurationm.swift
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


// MARK: - Allowed Symbols
let listSeparator = ","
let rangeSeparator = "-"
let stepSeparator = "/"
let starSymbol = "*"
let questionSymbol = "?"
let LSymbol = "L"
let WSymbol = "W"
let hashtagSymbol = "#"
let whitespaceCharacter = " "

let separationCharacterss = [listSeparator, rangeSeparator, stepSeparator]
let singleSpecialCharacterss: [String] = [starSymbol]

// MARK: - Allowed Short Symbols
let monthsSymbolRange = DateFormatter().shortMonthSymbols.compactMap { String($0).uppercased() }
let monthsFullSymbolRange = DateFormatter().monthSymbols.compactMap { String($0).uppercased() }
let dayOfWeekSymbolRange = DateFormatter().shortWeekdaySymbols.compactMap { String($0).uppercased() }
let dayOfWeekFullSymbolRange = DateFormatter().weekdaySymbols.compactMap { String($0).uppercased() }

// MARK: - Allowed Integers
let minutesRange = 0...59
let hoursRange = 0...23
let dayOfMonthIntRange = 1...31
let monthsIntRange = 1...12
let dayOfWeekIntRange = 0...6
