//
//  XCTestsExtension.swift
//  PlantingMindUITests
//
//  Created by 최은주 on 4/17/24.
//

import Foundation
import XCTest

extension XCTestCase {
    func tapButton(element: XCUIElement) {
        XCTAssertTrue(element.waitForExistence(timeout: 1.0))
        element.tap()
    }
    
    func checkString(element: XCUIElement, expectedString: String) {
        XCTAssertTrue(element.waitForExistence(timeout: 1.0))
        XCTAssertEqual(element.label, expectedString)
    }
}
