//
//  PlantingMindUITests_MoodRecord.swift
//  PlantingMindUITests
//
//  Created by 최은주 on 4/17/24.
//

import XCTest

final class PlantingMindUITests_MoodRecord: XCTestCase {
    let app = XCUIApplication()
    let localizedHelper = LocalizedHelper()
    
    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    func test_01_감정기록_후_마음현황_체크() {
        app.launch()
        
        checkString(element: app.staticTexts[AccessibilityIdentifiers.emptyMoodText.rawValue],
                    expectedString: localizedHelper.localized("mood_statistics_empty"))
        
        tap(element: app.buttons["1"])
        tap(element: app.buttons[AccessibilityIdentifiers.cancelButton.rawValue])
        
        tap(element: app.buttons["1"])
        checkString(element: app.staticTexts[AccessibilityIdentifiers.moodTitleText.rawValue],
                    expectedString: localizedHelper.localized("mood_title"))
        
        tap(element: app.buttons[AccessibilityIdentifiers.nice.rawValue])
        
        let textEditor = app.textViews[AccessibilityIdentifiers.moodReasonTextEditor.rawValue]
        XCTAssertTrue(textEditor.waitForExistence(timeout: 1.0))
        textEditor.tap()
        textEditor.typeText("test string")
        
        tap(element: app.buttons[AccessibilityIdentifiers.saveButton.rawValue])
        let chart = app.otherElements[AccessibilityIdentifiers.moodChart.rawValue].firstMatch
        XCTAssertTrue(chart.waitForExistence(timeout: 1.0))
        XCTAssertTrue(chart.otherElements[localizedHelper.localized("nice")].value as? String == "1")
    }
    
    func test_02_감정기록_수정_취소() {
        tap(element: app.buttons["1"])
        
        checkString(element: app.staticTexts[AccessibilityIdentifiers.moodTitleText.rawValue],
                    expectedString: localizedHelper.localized("mood_title"))
        
        tap(element: app.buttons[AccessibilityIdentifiers.normal.rawValue])
        tap(element: app.buttons[AccessibilityIdentifiers.cancelButton.rawValue])
        
        XCTAssertTrue(app.staticTexts[localizedHelper.localized("record_cancel_alert")].waitForExistence(timeout: 2.0))
        tap(element: app.buttons[AccessibilityIdentifiers.confirmButton.rawValue])
    }
    
    func test_03_감정기록_수정_저장_후_마음현황_체크() {
        tap(element: app.buttons["1"])
        
        checkString(element: app.staticTexts[AccessibilityIdentifiers.moodTitleText.rawValue],
                    expectedString: localizedHelper.localized("mood_title"))
        
        tap(element: app.buttons[AccessibilityIdentifiers.normal.rawValue])
        tap(element: app.buttons[AccessibilityIdentifiers.saveButton.rawValue])
        
        let chart = app.otherElements[AccessibilityIdentifiers.moodChart.rawValue].firstMatch
        XCTAssertTrue(chart.waitForExistence(timeout: 1.0))
        XCTAssertTrue(chart.otherElements[localizedHelper.localized("normal")].value as? String == "1")
    }
    
    func test_04_감정기록_삭제_후_마음현황_체크() {
        tap(element: app.buttons["1"])
        tap(element: app.buttons[AccessibilityIdentifiers.removeButton.rawValue])
        
        checkAlert(app: app, string: localizedHelper.localized("delete_alert"))
        tap(element: app.buttons[AccessibilityIdentifiers.confirmButton.rawValue])
        
        checkString(element: app.staticTexts[AccessibilityIdentifiers.emptyMoodText.rawValue],
                    expectedString: localizedHelper.localized("mood_statistics_empty"))
    }
}
