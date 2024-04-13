//
//  SettingsViewModelTests.swift
//  PlantingMindTests
//
//  Created by 최은주 on 4/10/24.
//

import XCTest
import CoreData
@testable import PlantingMind

final class SettingsViewModelTests: XCTestCase {
    //Import 잘 되는지 + Import하고 노티 받아지는지, 기존 기록 삭제 다 됐는지 Export 잘 되는지
    
    var context: NSManagedObjectContext!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        context = CoreDataStack(.inMemory).persistentContainer.viewContext
    }

    func test_exportable_기록_있는_경우_true() throws {
        try setupCoreData()
        let viewModel = SettingsViewModel(context: context)
        XCTAssertTrue(viewModel.checkExportable())
    }

    func test_exportable_기록_없는_경우_false() throws {
        let viewModel = SettingsViewModel(context: context)
        XCTAssertFalse(viewModel.checkExportable())
    }
    
    func test_import_data_들어가는지_확인후_context_save_노티_체크() throws {
        let notiMock = FetchNotificationSpy(context: context)
        let viewModel = SettingsViewModel(context: context)
        
        XCTAssertFalse(notiMock.bindNoticiationIsCalled)
        XCTAssertFalse(viewModel.checkExportable())
        
        let url = try XCTUnwrap(Bundle(for: type(of: self)).url(forResource: "test", withExtension: "mind"))
        viewModel.importData(url: url)
        XCTAssertTrue(viewModel.checkExportable())
        
        let notiExpectation = XCTestExpectation(description: "notiExpectation")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
            XCTAssertTrue(notiMock.bindNoticiationIsCalled)
            notiExpectation.fulfill()
        })
        wait(for: [notiExpectation], timeout: 1)
        
    }
    
    func test_MindDocument_정상생성() throws {
        try setupCoreData()
        let viewModel = SettingsViewModel(context: context)
        XCTAssertTrue(viewModel.checkExportable())
        XCTAssertNotNil(viewModel.setupMindDocument())
    }
    
    func test_privacy_policy() throws {
        let viewModel = SettingsViewModel(context: context, languageCode: "ko")
        let expectedURL = try XCTUnwrap(URL(string: "https://planting-mind.notion.site/48f9b3289a5d4cd999d08955802f8d19"))
        XCTAssertEqual(viewModel.privacyPolicyURL(), expectedURL)
        
        let viewModel2 = SettingsViewModel(context: context, languageCode: "en")
        let expectedURL2 = try XCTUnwrap(URL(string: "https://planting-mind.notion.site/Privacy-Policy-af91fa5d528544ef9a30c1a95ec951c2?pvs=74"))
        XCTAssertEqual(viewModel2.privacyPolicyURL(), expectedURL2)
    }

    private func setupCoreData() throws {
        let date1 = try XCTUnwrap(Calendar.current.date(from: DateComponents(year: 2024,
                                                                             month: 2,
                                                                             day: 24)))
        
        let date2 = try XCTUnwrap(Calendar.current.date(from: DateComponents(year: 2024,
                                                                             month: 1,
                                                                             day: 1)))
        
        let date3 = try XCTUnwrap(Calendar.current.date(from: DateComponents(year: 2024,
                                                                             month: 1,
                                                                             day: 6)))
        
        let date4 = try XCTUnwrap(Calendar.current.date(from: DateComponents(year: 2024,
                                                                             month: 1,
                                                                             day: 24)))
        
        let timestapms = [date1, date2, date3, date4]
        let moods: [Mood] = [.nice, .normal, .notBad, .bad]
        let reasons: [String?] = ["happy birthday", nil, "developing...", "eww"]
        
        for idx in 0..<4 {
            let moodRecord = MoodRecord(context: context)
            moodRecord.timestamp = timestapms[idx]
            moodRecord.mood = moods[idx].rawValue
            moodRecord.reason = reasons[idx]
        }
        
        do {
            try context.save()
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
}
