//
//  PlantingMindUITests_MoodRecord.swift
//  PlantingMindUITests
//
//  Created by 최은주 on 4/17/24.
//

import XCTest

final class PlantingMindUITests_MoodRecord: XCTestCase {
    let app = XCUIApplication()
    
    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    func test_01_감정기록_후_마음현황_체크() {
        app.launch()
        
        checkString(element: app.staticTexts[AccessibilityIdentifiers.emptyMoodText.rawValue],
                    expectedString: localized("mood_statistics_empty"))
        
        tapButton(element: app.buttons["1"])
        tapButton(element: app.buttons[AccessibilityIdentifiers.cancelButton.rawValue])
        
        tapButton(element: app.buttons["1"])
        checkString(element: app.staticTexts[AccessibilityIdentifiers.moodTitleText.rawValue],
                    expectedString: localized("mood_title"))
        
        tapButton(element: app.buttons[AccessibilityIdentifiers.nice.rawValue])
        
        let textEditor = app.textViews[AccessibilityIdentifiers.moodReasonTextEditor.rawValue]
        XCTAssertTrue(textEditor.waitForExistence(timeout: 1.0))
        textEditor.tap()
        textEditor.typeText("test string")
        
        tapButton(element: app.buttons[AccessibilityIdentifiers.saveButton.rawValue])
        let chart = app.otherElements[AccessibilityIdentifiers.moodChart.rawValue].firstMatch
        XCTAssertTrue(chart.waitForExistence(timeout: 1.0))
        XCTAssertTrue(chart.otherElements[localized("nice")].value as? String == "1")
    }
    
    func test_02_감정기록_수정_취소() {
        tapButton(element: app.buttons["1"])
        
        checkString(element: app.staticTexts[AccessibilityIdentifiers.moodTitleText.rawValue],
                    expectedString: localized("mood_title"))
        
        tapButton(element: app.buttons[AccessibilityIdentifiers.normal.rawValue])
        tapButton(element: app.buttons[AccessibilityIdentifiers.cancelButton.rawValue])
        XCTAssertTrue(app.staticTexts[localized("record_cancel_alert")].waitForExistence(timeout: 2.0))
        tapButton(element: app.buttons[AccessibilityIdentifiers.confirmButton.rawValue])
    }
    
    func test_03_감정기록_수정_저장_후_마음현황_체크() {
        tapButton(element: app.buttons["1"])
        
        checkString(element: app.staticTexts[AccessibilityIdentifiers.moodTitleText.rawValue],
                    expectedString: localized("mood_title"))
        
        tapButton(element: app.buttons[AccessibilityIdentifiers.normal.rawValue])
        tapButton(element: app.buttons[AccessibilityIdentifiers.saveButton.rawValue])
        
        let chart = app.otherElements[AccessibilityIdentifiers.moodChart.rawValue].firstMatch
        XCTAssertTrue(chart.waitForExistence(timeout: 1.0))
        XCTAssertTrue(chart.otherElements[localized("normal")].value as? String == "1")
    }
    
    func test_04_감정기록_삭제_후_마음현황_체크() {
        tapButton(element: app.buttons["1"])
        tapButton(element: app.buttons[AccessibilityIdentifiers.removeButton.rawValue])
        XCTAssertTrue(app.staticTexts[localized("delete_alert")].waitForExistence(timeout: 1.0))
        tapButton(element: app.buttons[AccessibilityIdentifiers.confirmButton.rawValue])
        checkString(element: app.staticTexts[AccessibilityIdentifiers.emptyMoodText.rawValue],
                    expectedString: localized("mood_statistics_empty"))
    }
    
    func localized(_ key: String) -> String {
        let uiTestBundle = Bundle(for: type(of: self))
        return NSLocalizedString(key, bundle: uiTestBundle, comment: "")
    }
}
