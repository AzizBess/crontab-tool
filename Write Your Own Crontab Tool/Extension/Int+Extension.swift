//
//  Int+Extension.swift
//  Write Your Own Crontab Tool
//
//  Created by Aziz Bessrour on 2023-11-11.
//

import Foundation

extension Int {
    var ordinal: String? {
        let ordinalFormatter = NumberFormatter()
        ordinalFormatter.numberStyle = .ordinal
        return ordinalFormatter.string(from: NSNumber(value: self))
    }
}
