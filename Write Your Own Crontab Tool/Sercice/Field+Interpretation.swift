//
//  Field+Interpretation.swift
//  Write Your Own Crontab Tool
//
//  Created by Aziz Bessrour on 2023-11-12.
//

import Foundation

// MARK: - Interpretation - Field Helpers
extension Field {
    func description(of cronPattern: String, shouldPrefix: Bool = true) -> String {
        
        let value = value(from: cronPattern) ?? cronPattern
        let prefix = shouldPrefix ? prefix : nil
                
        if let integer = Int(value) {
            var description = [prefix]
            if self == .dayOfMonth {
                description.append(contentsOf: ["The", integer.ordinal ?? String(integer), displayName])
            } else if self == .months || self == .dayOfWeek {
                description.append(contentsOf: [(fullSymbolRange?[integer] ?? String(integer)).capitalized])
            } else if self == .hours {
                description.append(String(integer).formatHour)
            } else {
                description.append(contentsOf: [displayName, String(value)])
            }
            return description.compactMap{ $0 }.joined(separator: whitespaceCharacter)
        }
        
        if value.count == 1 {
            var description = [prefix]
            if value == starSymbol {
                description.append(contentsOf: ["every", displayName])
            } else {
                if self == .dayOfWeek {
                    if value == LSymbol {
                        description.append(contentsOf: ["the last",displayName,"(Sunday)"])
                    }
                } else if self == .dayOfMonth {
                    if value == LSymbol {
                        description.append(contentsOf: ["the last", displayName])
                    } else if value == WSymbol {
                        description.append(contentsOf: ["a week", displayName])
                    }
                } else {
                    description.append(contentsOf: [displayName, value])
                }
            }
            return description.compactMap{ $0 }.joined(separator: whitespaceCharacter)
        }
        
        if value.isRange {
            var description = [prefix]
            var values = value.components(separatedBy: rangeSeparator)
            if self == .months || self == .dayOfWeek {
                values = values.compactMap { Int($0) != nil ? fullSymbolRange?[Int($0) ?? 0] : $0 }
            } else if self == .hours {
                values = values.compactMap { $0.formatHour }
                description.append(contentsOf: ["every", displayName, "from"])
            } else {
                description.append(contentsOf: ["every", displayName, "from"])
            }
            description.append(contentsOf: [values[0], "through", values[1]])
            return description.compactMap{ $0 }.joined(separator: whitespaceCharacter)
        }
        
        // NOTE: - It's important to call check list seprator first!!!
        if value.isList {
            let components = value.components(separatedBy: listSeparator)
            if value.isComplexList {
                return components.compactMap {
                    let shouldPrefix = components.firstIndex(of: $0) == components.startIndex
                    return description(of: $0, shouldPrefix: shouldPrefix)
                }.commaRuleString
            } else {
                var description = [prefix, displayName]
                var values = components
                if self == .months || self == .dayOfWeek {
                    values = values.compactMap { Int($0) != nil ? fullSymbolRange?[Int($0) ?? 0] : $0 }
                    description.removeLast()
                } else if self == .hours {
                    values = values.compactMap { $0.formatHour }
                    description.removeLast()
                }
                let valuesDescription = values.commaRuleString
                description.append(valuesDescription)
                return description.compactMap{ $0 }.joined(separator: whitespaceCharacter)
            }
        }
        
        if value.isStep {
            let values = value.components(separatedBy: stepSeparator)
            let indexOfSymbol = symbolRange?.firstIndex(where: { $0.lowercased() == values.last })
            var desccription = [prefix, "every", (Int(values[1]) ?? indexOfSymbol)?.ordinal]
            if values.first != starSymbol {
                if self == .dayOfWeek || self == .months {
                    desccription.append(contentsOf: ["\(displayName),"])
                    let startDay = Int(values[0]) != nil ? fullSymbolRange?[Int(values[0]) ?? 0] : values[0]
                    desccription.append(contentsOf:[startDay?.capitalized, "through", fullSymbolRange?.last])
                } else if self == .hours {
                    desccription.append(contentsOf: ["\(displayName),", "starting", prefix, values[0].formatHour])
                } else {
                    desccription.append(contentsOf: ["\(displayName),", "starting", prefix, displayName, String(values[0])])
                }
            } else {
                desccription.append(self.displayName)
            }
            
            return desccription.compactMap { $0 }.joined(separator: whitespaceCharacter)
        }
        
        if value.isShortSymbol {
            var description = [prefix]
            if
                let indexOfSymbol = symbolRange?.firstIndex(where: { $0.lowercased() == value.lowercased() }),
                let correspondingDay = fullSymbolRange?[indexOfSymbol] {
                description.append(correspondingDay.capitalized)
            } else {
                description.append(value.capitalized)
            }
            return description.compactMap{ $0 }.joined(separator: whitespaceCharacter)
        }
        
        if self == .dayOfWeek && value.isHashtag {
            var description = [prefix, "the"]
            let values = value.components(separatedBy: hashtagSymbol)
            let first = values[0]
            let second = values[1]
            description.append((Int(second)?.ordinal) ?? second)
            
            if
                let indexOfSymbol = Int(first) ?? symbolRange?.firstIndex(where: { $0.lowercased() == first.lowercased() }),
                let correspondingDay = fullSymbolRange?[indexOfSymbol] {
                description.append(correspondingDay.capitalized)
            }
            description.append("of the month")
            return description.compactMap{ $0 }.joined(separator: whitespaceCharacter)
        }

        return ["unknown", value, prefix, displayName].compactMap { $0 }.joined(separator: whitespaceCharacter)
    }
}
