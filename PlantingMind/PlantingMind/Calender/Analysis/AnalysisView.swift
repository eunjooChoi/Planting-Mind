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
                .accessibilityIdentifier(AccessibilityIdentifiers.emptyMoodText.rawValue)
        } else {
            Text("mood_statistics")
                .font(.title3)
                .bold()
                .padding([.top, .horizontal])
            
            Chart(viewModel.moodAnalysis, id: \.mood) { analysis in
                BarMark(x: .value("Count", analysis.count))
                    .foregroundStyle(by: .value("Category", analysis.mood.moodString))
                    .annotation(position: .overlay, alignment: .center) {
                        let color = analysis.mood == .nice ? Color.gray.opacity(0.8) : .white
                        Text("\(analysis.count)")
                            .foregroundStyle(color)
                            .font(.caption)
                            .bold()
                    }
            }
            .chartForegroundStyleScale([
                Mood.nice.moodString: Mood.nice.color,
                Mood.good.moodString: Mood.good.color,
                Mood.normal.moodString: Mood.normal.color,
                Mood.notBad.moodString: Mood.notBad.color,
                Mood.bad.moodString: Mood.bad.color
            ])
            .chartXScale(domain: 0...viewModel.recordsCount)
            .chartXAxis {
                AxisMarks(position: .bottom) { _ in
                    AxisGridLine().foregroundStyle(.clear)
                    AxisTick().foregroundStyle(.clear)
                }
            }
            .frame(height: 45)
            .accessibilityIdentifier(AccessibilityIdentifiers.moodChart.rawValue)
        }
    }
}

#Preview {
    AnalysisView(viewModel: AnalysisViewModel(moods: []))
}
