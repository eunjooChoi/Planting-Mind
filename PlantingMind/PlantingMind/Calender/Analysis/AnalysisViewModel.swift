//
//  AnalysisViewModel.swift
//  PlantingMind
//
//  Created by 최은주 on 3/29/24.
//

import Foundation

struct AnalysisViewModel {
    let moodAnalysis: [MoodAnalysis]
    
    var recordsCount: Int {
        moodAnalysis.map { $0.count }.reduce(0,+)
    }
    
    init(moods: [MoodRecord]) {
        var result: [MoodAnalysis] = []
        for mood in Mood.allCases {
            let count = moods.filter { $0.mood == mood.rawValue }.count
            result.append(MoodAnalysis(mood: mood.rawValue, count: count))
        }
        
        self.moodAnalysis = result
    }
}
