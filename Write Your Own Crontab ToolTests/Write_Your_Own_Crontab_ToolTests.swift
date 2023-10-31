//
//  Write_Your_Own_Crontab_ToolTests.swift
//  Write Your Own Crontab ToolTests
//
//  Created by Aziz Bessrour on 2023-10-22.
//

import XCTest
@testable import Write_Your_Own_Crontab_Tool

final class Write_Your_Own_Crontab_ToolTests: XCTestCase {

    func testMinutes_Valid() throws {
        let cronPattern = "1,2,3-7,*/5 * * * *"
        let error = ValidationService.shared.validateField(.dayOfWeek, cronPattern: cronPattern)
        XCTAssertNil(error)
    }
    
    func testMinutes_Invalid() throws {
        let cronPattern = "1,2,3-90,*/5 * * * *"
        let error = ValidationService.shared.validateField(.dayOfWeek, cronPattern: cronPattern)
        XCTAssertNil(error)
    }
    
    func testHashtag_Valid() throws {
        let cronPattern = "* * * * 1#2" // on the second Monday of the month
        let error = ValidationService.shared.validateField(.dayOfWeek, cronPattern: cronPattern)
        XCTAssertNil(error)
    }
    
    func testHashtag_Invalid() throws {
        let cronPattern = "* * * * #"
        let error = ValidationService.shared.validateField(.dayOfWeek, cronPattern: cronPattern)
        XCTAssertNotNil(error)
    }
}
