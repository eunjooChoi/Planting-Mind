//
//  NotificationSettingsViewModelTests.swift
//  PlantingMindTests
//
//  Created by 최은주 on 4/15/24.
//

import XCTest
@testable import PlantingMind

final class NotificationSettingsViewModelTests: XCTestCase {
    func test_checkPermission() {
        let notificationManager = NotificationManagerSpy(testSuccessOrFail: true)
        let viewModel = NotificationSettingViewModel(notificationManager: notificationManager)
        viewModel.checkPermission()
        
        let permissionExpectation = XCTestExpectation(description: "permissionExpectation")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
            XCTAssertTrue(viewModel.permission)
            permissionExpectation.fulfill()
        })
        wait(for: [permissionExpectation], timeout: 1)
    }
    
    func test_sink_테스트() {
        let notificationManager = NotificationManagerSpy(testSuccessOrFail: true)
        let viewModel = NotificationSettingViewModel(notificationManager: notificationManager)
        viewModel.pickedTime = Date()
        XCTAssertTrue(notificationManager.addNotificationIsCalled)
    }
}

class NotificationManagerSpy: Notificable {
    var hour: Int = 0
    var minute: Int = 0
    let testSuccessOrFail: Bool
    var addNotificationIsCalled: Bool = false
    
    init(testSuccessOrFail: Bool) {
        self.testSuccessOrFail = testSuccessOrFail
    }
    
    func checkPermission(completionHandler: @escaping (Bool) -> Void) {
        completionHandler(self.testSuccessOrFail)
    }
    
    func addNotification(date: Date?) {
        self.addNotificationIsCalled = true
    }
    
    
}
