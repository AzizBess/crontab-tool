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
