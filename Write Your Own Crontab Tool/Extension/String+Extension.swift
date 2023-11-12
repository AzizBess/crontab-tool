//
//  String+Extension.swift
//  Write Your Own Crontab Tool
//
//  Created by Aziz Bessrour on 2023-11-11.
//

import Foundation

extension [String] {
    var commaRuleString: String {
        [dropLast().joined(separator: ", "), last]
            .compactMap { $0 }
            .joined(separator: self.count == 2 ? " and " : ", and ")
    }
    
    var formattedTime: String? {
        let hoursFromGmt = String(TimeZone.current.secondsFromGMT() / 3600)
        let value = self.joined(separator: ":") + hoursFromGmt
        let firstDateFormatter = DateFormatter()
        firstDateFormatter.dateFormat = "H:m" + Array(repeating: "X", count: hoursFromGmt.count).joined()
        
        guard let date = firstDateFormatter.date(from: value) else { return nil }
        let secondDateFormatter = DateFormatter()
        secondDateFormatter.dateStyle = .none
        secondDateFormatter.timeStyle = .short
        return secondDateFormatter.string(from: date)
    }
}
extension String {
    var formatHour: String {
        [self,"00"].formattedTime ?? self
    }
    var isInteger: Bool {
        Int(self) != nil
    }
    var isShortSymbol: Bool {
        monthsSymbolRange.contains(self) || dayOfWeekSymbolRange.contains(self)
    }
    
    var isRange: Bool {
        self.components(separatedBy: rangeSeparator)
            .filter { !$0.isEmpty }
            .count == 2
    }
    
    var isStep: Bool {
        self.components(separatedBy: stepSeparator)
            .filter { !$0.isEmpty }
            .count == 2
    }
    
    var isList: Bool {
        self.components(separatedBy: listSeparator)
            .filter { !$0.isEmpty }
            .count > 1
    }
    var isSimpleList: Bool {
        isList && !isComplexList
    }
    
    var isComplexList: Bool {
        components(separatedBy: listSeparator)
            .filter { !$0.isEmpty }
            .first(where: { $0.isStep || $0.isRange || $0.isHashtag }) != nil
    }
    
    var isHashtag: Bool {
        self.components(separatedBy: hashtagSymbol)
            .filter { !$0.isEmpty }
            .count == 2
    }

    var capitalizedSentence: String {
        let firstLetter = prefix(1).capitalized
        let remainingLetters = dropFirst()
        return firstLetter + remainingLetters
    }
}
