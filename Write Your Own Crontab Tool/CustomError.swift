//
//  CustomError.swift
//  Write Your Own Crontab Tool
//
//  Created by Aziz Bessrour on 2023-10-30.
//

import Foundation

struct CustomError: LocalizedError {
    var title: String
    var errorDescription: String { return _description }
    var failureReason: String? { return _description }
    
    private var _description: String
    
    init(title: String, description: String) {
        self.title = title
        self._description = description
    }
}
