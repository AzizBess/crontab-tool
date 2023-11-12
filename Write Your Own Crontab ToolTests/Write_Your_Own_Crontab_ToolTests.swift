//
//  Write_Your_Own_Crontab_ToolTests.swift
//  Write Your Own Crontab ToolTests
//
//  Created by Aziz Bessrour on 2023-10-22.
//

import XCTest
@testable import Write_Your_Own_Crontab_Tool

final class Write_Your_Own_Crontab_ToolTests: XCTestCase {

    // MARK: - Validation Tests
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
    
    // MARK: - Interpretation Tests
    
    // * * * * * -> Every Minute ✅
    // 0 * * * * -> Every Hour ✅
    // 0 0 * * * -> At 12 AM ✅
    // 1 * * * * At minute 1 past the hour ✅
    // 1,5 * * * * At minute 1 and 5  past the hour ✅
    // 1-5 * * * * At minute 1 through 5 past the hour✅
    // */5 * * * * Every 5 minutes✅
    // 1/5 * * * * Every 5 minutes, starting at 1 minutes past the hour✅
    // 7-9,15-25 * * * * Seconds 7 through 9 past the minute, minutes 15 through 25 past the hour ❌
    //  * 0 * * * -> At Every Minute Past 12:00 AM ✅
    // 1,2,3 * -> At Minute 1 and 2 and 3 Every Hour ✅
    // * 1,2,3 -> At Every Minute At 1:00 AM, 2:00 AM and 3:00 AM On MONDAY, TUESDAY and WEDNESDAY ✅ ❌
    // 1,2,3 5 -> 5:01, 5:02 and 5:03 and 5:04 ✅
    // 5 1,2,3 -> At 1:05 AM, 2:05 AM and 3:05 AM ✅
    // 2#5 -> on the fifth Tuesday of the month ✅
    // Tue#5-> on the fifth Tuesday of the month ✅ ❌
    
    
    func testTranslation_EveryMinute() throws {
        let cronPattern = "* * * * *"
        let output = InterpretationService.shared.translateCronExpression(cronPattern)
        let expectedOutput = "At every minute"
        XCTAssertEqual(output, expectedOutput)
    }
    
    func testTranslation_EveryHour() throws {
        let cronPattern = "0 * * * *"
        let output = InterpretationService.shared.translateCronExpression(cronPattern)
        let expectedOutput = "At every hour"
        XCTAssertEqual(output, expectedOutput)
    }
    
    func testTranslation_1Minute() throws {
        let cronPattern = "1 * * * *"
        let output = InterpretationService.shared.translateCronExpression(cronPattern)
        let expectedOutput = "At minute 1, past the hour"
        XCTAssertEqual(output, expectedOutput)
    }
    
    func testTranslation_Minute1And5() throws {
        let cronPattern = "1,5 * * * *"
        let output = InterpretationService.shared.translateCronExpression(cronPattern)
        let expectedOutput = "At minute 1 and 5, past the hour"
        XCTAssertEqual(output, expectedOutput)
    }
    
    func testTranslation_Minute1Through5() throws {
        let cronPattern = "1-5 * * * *"
        let output = InterpretationService.shared.translateCronExpression(cronPattern)
        let expectedOutput = "At every minute from 1 through 5, past the hour"
        XCTAssertEqual(output, expectedOutput)
    }
    
    func testTranslation_Every5thMinute() throws {
        let cronPattern = "*/5 * * * *"
        let output = InterpretationService.shared.translateCronExpression(cronPattern)
        let expectedOutput = "At every 5th minute, past the hour"
        XCTAssertEqual(output, expectedOutput)
    }
    
    func testTranslation_Every5MinutesStartingAt() throws {
        let cronPattern = "1/5 * * * *"
        let output = InterpretationService.shared.translateCronExpression(cronPattern)
        let expectedOutput = "At every 5th minute, starting at minute 1, past the hour"
        XCTAssertEqual(output, expectedOutput)
    }
    
    func testTranslation_ComplexMinutesList() throws {
        let cronPattern = "7-9,15-25,*/30 * * * *"
        let output = InterpretationService.shared.translateCronExpression(cronPattern)
        let expectedOutput = "At every minute from 7 through 9, every minute from 15 through 25, and every 30th minute, past the hour"
        XCTAssertEqual(output, expectedOutput)
    }
    
    func testTranslation_12Am() throws {
        let cronPattern = "0 0 * * *"
        let output = InterpretationService.shared.translateCronExpression(cronPattern)
        let expectedOutput = "At 12:00 AM"
        XCTAssertEqual(output, expectedOutput)
    }
    
    func testTranslation_EveryMinutePast12() throws {
        let cronPattern = "* 0 * * *"
        let output = InterpretationService.shared.translateCronExpression(cronPattern)
        let expectedOutput = "At every minute, past 12:00 AM"
        XCTAssertEqual(output, expectedOutput)
    }
    
    func testTranslation_EveryMinute12and3() throws {
        let cronPattern = "1,2,3 * * * *"
        let output = InterpretationService.shared.translateCronExpression(cronPattern)
        let expectedOutput = "At minute 1, 2, and 3, past the hour"
        XCTAssertEqual(output, expectedOutput)
    }
    
    func testTranslation_EveryHour12and3() throws {
        let cronPattern = "* 1,2,3 * * *"
        let output = InterpretationService.shared.translateCronExpression(cronPattern)
        let expectedOutput = "At every minute, past 1:00 AM, 2:00 AM, and 3:00 AM"
        XCTAssertEqual(output, expectedOutput)
    }
    
    // 1,2,3 5 -> 5:01, 5:02 and 5:03 and 5:04 ✅ ❌
    // 5 1,2,3 -> At 1:05 AM, 2:05 AM and 3:05 AM ✅ ❌
    func testTranslation_MinuteAndHours() throws {
        let cronPattern = "5 1,2,3 * * *"
        let output = InterpretationService.shared.translateCronExpression(cronPattern)
        let expectedOutput = "At 1:05 AM, 2:05 AM, and 3:05 AM"
        XCTAssertEqual(output, expectedOutput)
    }
    
    func testTranslation_MinutesAndHour() throws {
        let cronPattern = "1,2,3 5 * * *"
        let output = InterpretationService.shared.translateCronExpression(cronPattern)
        let expectedOutput = "At 5:01 AM, 5:02 AM, and 5:03 AM"
        XCTAssertEqual(output, expectedOutput)
    }
    
    func testTranslation_MinuteAndHour5Through9() throws {
        let cronPattern = "1 5-9 * * *"
        let output = InterpretationService.shared.translateCronExpression(cronPattern)
        let expectedOutput = "At minute 1, past every hour from 5:00 AM through 9:00 AM"
        XCTAssertEqual(output, expectedOutput)
    }
    
    func testTranslation_MinutesAndHour5Through9() throws {
        let cronPattern = "1,2,3 5-9 * * *"
        let output = InterpretationService.shared.translateCronExpression(cronPattern)
        let expectedOutput = "At minute 1, 2, and 3, past every hour from 5:00 AM through 9:00 AM"
        XCTAssertEqual(output, expectedOutput)
    }
    
    func testTranslation_fifthTuesdayOfTheMonth() throws {
        let cronPattern = "* * * * 2#5"
        let output = InterpretationService.shared.translateCronExpression(cronPattern)
        let expectedOutput = "At every minute, on the 5th Tuesday of the month"
        XCTAssertEqual(output, expectedOutput)
    }
    
    func testTranslation_fifthWedOfTheMonth() throws {
        let cronPattern = "0 0 * 9 WED#5"
        let output = InterpretationService.shared.translateCronExpression(cronPattern)
        let expectedOutput = "At 12:00 AM, on the 5th Wednesday of the month, in October"
        XCTAssertEqual(output, expectedOutput)
    }
    
    func testTranslation_weekDayOfTheMonth() throws {
        let cronPattern = "* * W * *"
        let output = InterpretationService.shared.translateCronExpression(cronPattern)
        let expectedOutput = "At every minute, on a week day of the month"
        XCTAssertEqual(output, expectedOutput)
    }
    
    
    func testTranslation_lastDayOfTheMonth() throws {
        let cronPattern = "* * L * *"
        let output = InterpretationService.shared.translateCronExpression(cronPattern)
        let expectedOutput = "At every minute, on the last day of the month"
        XCTAssertEqual(output, expectedOutput)
    }
    
    func testTranslation_lastDayOfTheWeek() throws {
        let cronPattern = "* * * * L"
        let output = InterpretationService.shared.translateCronExpression(cronPattern)
        let expectedOutput = "At every minute, on the last day of the week (Sunday)"
        XCTAssertEqual(output, expectedOutput)
    }
    
    
    func testTranslation_12345() throws {
        let cronPattern = "1 2 3 4 5"
        let output = InterpretationService.shared.translateCronExpression(cronPattern)
        let expectedOutput = "At 2:01 AM, on Friday, on The 3rd day of the month, in May"
        XCTAssertEqual(output, expectedOutput)
    }
}

/*
 
 ("At 2:01 AM, on Friday, on The 3rd day of the month, in May")
 ("At 2:01 AM, on the 3rd day of the month, on Friday, in May")
 */
