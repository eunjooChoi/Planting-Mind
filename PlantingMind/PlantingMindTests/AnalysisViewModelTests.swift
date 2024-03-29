//
//  AnalysisViewModelTests.swift
//  PlantingMindTests
//
//  Created by 최은주 on 3/29/24.
//

import XCTest
@testable import PlantingMind

final class AnalysisViewModelTests: XCTestCase {
    var viewModel: AnalysisViewModel!
    
    override func setUpWithError() throws {
        let context = CoreDataStack(.inMemory).persistentContainer.viewContext
        
        let record1 = MoodRecord(context: context)
        record1.mood = Mood.nice.rawValue
        
        let record2 = MoodRecord(context: context)
        record2.mood = Mood.bad.rawValue
        
        var records: [MoodRecord] = [record1, record2]
        
        viewModel = AnalysisViewModel(moods: records)
    }
    
    func test_MoodRecord_to_MoodAnalysis_변환_체크() throws {
        let expectedCount = [1, 0, 0, 0, 1]
        let result = viewModel.moodAnalysis.map { $0.count }
        
        XCTAssertEqual(expectedCount, result)
    }
    
    func test_전체_기록_카운트() {
        XCTAssertEqual(viewModel.recordsCount, 2)
    }
}
