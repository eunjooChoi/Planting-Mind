//
//  PlantingMindUITests_Calendar.swift
//  PlantingMindUITests
//
//  Created by 최은주 on 1/3/24.
//

import XCTest

final class PlantingMindUITests_Calendar: XCTestCase {
    let app = XCUIApplication()
    
    override func setUpWithError() throws {
        continueAfterFailure = false
    }
    
    func test_00_app_launch() throws {
        // UI tests must launch the application that they test.
        app.launch()
        self.removeNotificationAllowAlert()
    }
    
    func test_01_달력_Picker로_이동() {
        let monthPickerButton = app.buttons[AccessibilityIdentifiers.monthPickerButton.rawValue]
        tapButton(element: monthPickerButton)
        
        let yearPicker = app.pickers[AccessibilityIdentifiers.yearPicker.rawValue].pickerWheels.firstMatch
        XCTAssertTrue(yearPicker.waitForExistence(timeout: 1.0))
        
        let monthPicker = app.pickers[AccessibilityIdentifiers.monthPicker.rawValue].pickerWheels.firstMatch
        XCTAssertTrue(monthPicker.waitForExistence(timeout: 1.0))
        
        yearPicker.adjust(toPickerWheelValue: "2024")
        monthPicker.adjust(toPickerWheelValue: "01")
        
        tapButton(element: app.buttons[AccessibilityIdentifiers.doneButton.rawValue])
        checkString(element: monthPickerButton, expectedString: "2024. 01")
    }
    
    func test_02_좌우버튼으로_이동() {
        let monthPickerButton = app.buttons[AccessibilityIdentifiers.monthPickerButton.rawValue]
        
        tapButton(element: app.buttons[AccessibilityIdentifiers.nextMonthButton.rawValue])
        checkString(element: monthPickerButton, expectedString: "2024. 02")
        
        tapButton(element: app.buttons[AccessibilityIdentifiers.previousMonthButton.rawValue])
        checkString(element: monthPickerButton, expectedString: "2024. 01")
    }
    
    func test_03_드래그로_이동() {
        let monthPickerButton = app.buttons[AccessibilityIdentifiers.monthPickerButton.rawValue]
        
        let gridView = app.otherElements[AccessibilityIdentifiers.calendarGridView.rawValue]
        gridView.swipeLeft()
        checkString(element: monthPickerButton, expectedString: "2024. 02")
        
        gridView.swipeRight()
        checkString(element: monthPickerButton, expectedString: "2024. 01")
    }
    
    private func removeNotificationAllowAlert() {
        addUIInterruptionMonitor(withDescription: "Allow push") { (alerts) -> Bool in
            let firstMatchButton = alerts.buttons.element(boundBy: 1)
            if(firstMatchButton.exists){
                firstMatchButton.tap();
            }
            return true;
        }
        
        XCUIApplication().tap()
    }
}
