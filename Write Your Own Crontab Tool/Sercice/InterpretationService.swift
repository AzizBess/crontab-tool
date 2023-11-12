//
//  IntrepretationService.swift
//  Write Your Own Crontab Tool
//
//  Created by Aziz Bessrour on 2023-10-31.
//

import Foundation

class InterpretationService {
    static let shared = InterpretationService()
    
    // * * * * * Every Minute
    // 0 * * * * Every Hour
    // 1 * * * * At 1 minutes past the hour
    // 1,5 * * * * At 1 and 5 minutes past the hour
    // 1-5 * * * * Minutes 1 through 5 past the hour
    // */5 * * * * Every 5 minutes
    // 1/5 * * * * Every 5 minutes, starting at 1 minutes past the hour
    // 7-9, 15-25 * * * * Seconds 7 through 9 past the minute, minutes 15 through 25 past the hour
    
    
    // 7-9 => 7 through 9
    
    
    func translateCronExpression(_ expression: String) -> String {
        var result = [String]()
        
        result.append(contentsOf: translateMinutesAndHours(expression))
        
        Field.allCases
            .filter { $0 != .minutes && $0 != .hours }
            .forEach { field in
                if field.value(from: expression) != starSymbol {
                    let express = field.description(of: expression)
                    result.append(
                        express.description
                    )
                }
            }
        
        return result.joined(separator: ", ").capitalizedSentence
    }

    private func translateMinutesAndHours(_ expression: String) -> [String] {
        var result = [String]()
        guard let minutes = Field.minutes.value(from: expression) else { result.append("minutes is nil"); return result }
        guard let hours = Field.hours.value(from: expression) else { result.append("hours is nil"); return result }
        
        let minutesDescription = Field.minutes.description(of: expression)
        let hoursDescription = Field.hours.description(of: expression)
        
        if minutes == "0" {
            var value = hoursDescription
            value = value.replacingOccurrences(of: Field.hours.prefix, with: Field.minutes.prefix)
            result = [value]
            return result
        }
        
        if hours == starSymbol {
            if minutes == starSymbol {
                result = [minutesDescription]
            } else {
                result.append(minutesDescription)
                result.append("past the hour")
            }
        } else {
            if (minutes.isSimpleList || minutes.isInteger) && (hours.isSimpleList || hours.isInteger) {
                var minutesList = minutes.components(separatedBy: listSeparator)
                var hoursList = hours.components(separatedBy: listSeparator)
                
                minutesList = !minutes.isInteger ? minutesList : [minutes]
                hoursList = !hours.isInteger ? hoursList : [hours]
                let times = getTimes(hours: hoursList, minutes: minutesList)
                result.append(
                    ["At", times.joined(separator: whitespaceCharacter)].joined(separator: whitespaceCharacter)
                )
            } else {
                result.append(minutesDescription)
                result.append(hoursDescription)
            }
        }
        return result
    }

    private func getTimes(hours: [String], minutes: [String]) -> [String] {
        var result = [String]()
        for h in hours {
            for m in minutes {
                if let time = [h,m].formattedTime {
                    result.append(time)
                }
            }
        }
        
        return result
    }
}
