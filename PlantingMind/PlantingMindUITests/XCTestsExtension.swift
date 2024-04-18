//
//  XCTestsExtension.swift
//  PlantingMindUITests
//
//  Created by 최은주 on 4/17/24.
//

import Foundation
import XCTest

extension XCTestCase {
    func tap(element: XCUIElement?, timeout: Double = 1.0) {
        XCTAssertTrue(element?.waitForExistence(timeout: timeout) == true)
        element?.tap()
    }
    
    func checkAlert(app: XCUIApplication, string: String) {
        let alert = app.alerts[string]
        XCTAssertTrue(alert.waitForExistence(timeout: 1.0))
    }
    
    func checkString(element: XCUIElement, expectedString: String, timeout: Double = 1.0) {
        XCTAssertTrue(element.waitForExistence(timeout: 1.0))
        XCTAssertEqual(element.label, expectedString)
    }
}

extension XCUIElementQuery {
    var lastMatch: XCUIElement { return self.element(boundBy: self.count - 1) }
}
