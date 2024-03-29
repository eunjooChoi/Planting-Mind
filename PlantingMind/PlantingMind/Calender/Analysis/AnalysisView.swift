//
//  AnalysisView.swift
//  PlantingMind
//
//  Created by 최은주 on 3/29/24.
//

import SwiftUI
import Charts

struct AnalysisView: View {
    var viewModel: AnalysisViewModel
    
    var body: some View {
        if viewModel.recordsCount == 0 {
            Text("mood_statistics_empty")
                .multilineTextAlignment(.center)
                .font(.title3)
                .bold()
                .padding()
        } else {
            Text("mood_statistics")
                .font(.title3)
                .bold()
                .padding([.top, .horizontal])
            
            Chart(viewModel.moodAnalysis, id: \.self) {
                BarMark(x: .value("Count", $0.count))
                .foregroundStyle(by: .value("Category", $0.mood))
            }
            .chartForegroundStyleScale([
                "nice": Mood.nice.color,
                "good": Mood.good.color,
                "normal": Mood.normal.color,
                "notBad": Mood.notBad.color,
                "bad": Mood.bad.color
            ])
            .frame(height: 60)
            .padding()
        }
    }
}

#Preview {
    AnalysisView(viewModel: AnalysisViewModel(moods: []))
}
