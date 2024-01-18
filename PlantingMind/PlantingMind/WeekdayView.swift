//
//  WeekdayView.swift
//  PlantingMind
//
//  Created by 최은주 on 1/18/24.
//

import SwiftUI

struct WeekdayView: View {
    static let weekdaySymbols = Calendar.current.veryShortWeekdaySymbols
    
    var body: some View {
        VStack {
            HStack {
                ForEach(Self.weekdaySymbols, id: \.self) { symbol in
                    Text(symbol)
                        .frame(maxWidth: .infinity)
                }
                .padding(.bottom, 10)
            }
            
            Divider()
        }
    }
}

struct WeekdayView_Previews: PreviewProvider {
  static var previews: some View {
      WeekdayView()
  }
}
