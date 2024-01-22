//
//  DayCellView.swift
//  PlantingMind
//
//  Created by 최은주 on 1/19/24.
//

import SwiftUI

struct DayCellView: View {
    var calendarModel: CalendarModel
    
    var body: some View {
        RoundedRectangle(cornerRadius: 10)
            .fill(.clear)
            .overlay {
                Text("\(calendarModel.day)")
                    .frame(width: 30, height: 30)
                    .fontWeight(.semibold)
                    .background(calendarModel.isToday ? .black : .clear)
                    .foregroundStyle(calendarModel.isToday ? .white : .black)
                    .clipShape(Circle())
            }
            .frame(height: 50)
    }
}

struct DayCellView_Previews: PreviewProvider {
  static var previews: some View {
      DayCellView(calendarModel: CalendarModel(year: 2024, month: 2, day: 24, isToday: true))
  }
}
