//
//  PlantingMindUITests_Settings.swift
//  PlantingMindUITests
//
//  Created by 최은주 on 4/17/24.
//

import XCTest

final class PlantingMindUITests_Settings: XCTestCase {
    let app = XCUIApplication()
    let localizedHelper = LocalizedHelper()
    
    override func setUpWithError() throws {
        continueAfterFailure = false
    }
    
    func test_01_설정화면_진입() {
        app.launch()
        tap(element: app.buttons[AccessibilityIdentifiers.settingsButton.rawValue])
        
        let expectedString = localizedHelper.localized("settings")
        checkString(element: app.staticTexts[expectedString], expectedString: expectedString)
    }
    
    func test_02_알림설정_시간조작() {
        tap(element: app.buttons[localizedHelper.localized("notification_setting")])
        tap(element: app.datePickers[AccessibilityIdentifiers.timePicker.rawValue])
        
        if Locale().identifier == "ko" {
            app.pickers.pickerWheels.firstMatch.adjust(toPickerWheelValue: "PM")
        } else {
            app.pickers.pickerWheels.lastMatch.adjust(toPickerWheelValue: "PM")
        }
        
        tap(element: app.buttons["PopoverDismissRegion"])
        tap(element: app.navigationBars.buttons.firstMatch)
        
        tap(element: app.buttons[localizedHelper.localized("notification_setting")])
        tap(element: app.datePickers[AccessibilityIdentifiers.timePicker.rawValue])
        
        if Locale().identifier == "ko" {
            let description = app.pickers.pickerWheels.firstMatch.debugDescription
            XCTAssertTrue(description.contains("PM"))
        } else {
            let description = app.pickers.pickerWheels.lastMatch.debugDescription
            XCTAssertTrue(description.contains("PM"))
        }
        
        tap(element: app.buttons["PopoverDismissRegion"])
        tap(element: app.navigationBars.buttons.firstMatch)
    }
    
    func test_03_개인정보처리방침_사파리이동() {
        tap(element: app.buttons[localizedHelper.localized("privacy_policy")])
        
        sleep(5)
        let safariApp = XCUIApplication(bundleIdentifier: "com.apple.mobilesafari")
        XCTAssertTrue(safariApp.exists)
        app.activate()
                                            
    }
    
    func test_04_기록백업_기록없음_alert() {
        tap(element: app.buttons[localizedHelper.localized("export")])
        
        checkAlert(app: app, string: localizedHelper.localized("empty_record"))
        tap(element: app.buttons[localizedHelper.localized("ok")])
    }
    
    func test_05_기록저장후_기록백업() {
        tap(element: app.navigationBars.buttons.firstMatch)
        
        tap(element: app.buttons["1"])
        checkString(element: app.staticTexts[AccessibilityIdentifiers.moodTitleText.rawValue],
                    expectedString: localizedHelper.localized("mood_title"))
        tap(element: app.buttons[AccessibilityIdentifiers.saveButton.rawValue])
        
        tap(element: app.buttons[AccessibilityIdentifiers.settingsButton.rawValue])
        tap(element: app.buttons[localizedHelper.localized("export")])
        
        sleep(2)
        XCTAssertTrue(app.buttons["DOC.itemCollectionMenuButton.Ellipsis"].exists)
        
        print("---------------------")
        print(app.debugDescription)
        print("---------------------")
        
        tap(element: app.navigationBars["FullDocumentManagerViewControllerNavigationBar"].buttons.lastMatch)
        checkAlert(app: app, string: localizedHelper.localized("export_success"))
        tap(element: app.buttons[localizedHelper.localized("ok")])
    }
    
    func test_06_기록삭제() {
        tap(element: app.navigationBars.buttons.firstMatch)
        
        tap(element: app.buttons["1"])
        checkString(element: app.staticTexts[AccessibilityIdentifiers.moodTitleText.rawValue],
                    expectedString: localizedHelper.localized("mood_title"))
        tap(element: app.buttons[AccessibilityIdentifiers.removeButton.rawValue])
        
        checkAlert(app: app, string: localizedHelper.localized("delete_alert"))
        tap(element: app.buttons[AccessibilityIdentifiers.confirmButton.rawValue])
        
        checkString(element: app.staticTexts[AccessibilityIdentifiers.emptyMoodText.rawValue],
                    expectedString: localizedHelper.localized("mood_statistics_empty"))
    }
    
    func test_07_기록복원() {
        tap(element: app.buttons[AccessibilityIdentifiers.settingsButton.rawValue])
        tap(element: app.buttons[localizedHelper.localized("import")])
        
        sleep(3)
        tap(element: app.tabBars["DOC.browsingModeTabBar"].buttons["Recents"])
        
        let fileView = app.collectionViews["File View"]
        XCTAssertTrue(fileView.exists)
        if fileView.value as? String == "Icon Mode" {
            let buttons = app.navigationBars["FullDocumentManagerViewControllerNavigationBar"].buttons
            tap(element: buttons.element(boundBy: buttons.count-2))
            tap(element: app.collectionViews.buttons["List"])
        }
        
//        let searchFields = app.searchFields.firstMatch
//        tap(element: searchFields)
//        searchFields.typeText("Planting-Mind-Backup.mind")
//        
//        print("---------------------")
//        print(app.debugDescription)
//        print("---------------------")
//        
//        app.collectionViews.element(matching: NSPredicate(format: "label CONTAINS[c] 'Search results'")).staticTexts["Planting-Mind-Backup.mind"].tap()
//        
//        sleep(3)
//        checkAlert(app: app, string: localizedHelper.localized("import_remove_all_record_alert"))
//        tap(element: app.buttons[localizedHelper.localized("ok")])
//        
//        checkAlert(app: app, string: localizedHelper.localized("import_success"))
//        tap(element: app.buttons[localizedHelper.localized("ok")])
//        
//        tap(element: app.navigationBars.buttons.firstMatch)
//        
//        let chart = app.otherElements[AccessibilityIdentifiers.moodChart.rawValue].firstMatch
//        XCTAssertTrue(chart.waitForExistence(timeout: 1.0))
//        XCTAssertTrue(chart.otherElements[localizedHelper.localized("normal")].value as? String == "1")
    }
}
