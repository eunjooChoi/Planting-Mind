//
//  DayCellView.swift
//  PlantingMind
//
//  Created by 최은주 on 1/19/24.
//

import SwiftUI

struct DayCellView: View {
    @State var showMoodRecordView: Bool = false
    var calendarModel: CalendarModel
    
    var body: some View {
        Button(action: {
            showMoodRecordView.toggle()
        }, label: {
            Text("\(calendarModel.day)")
                .frame(width: 30, height: 30)
                .fontWeight(.semibold)
                .background(calendarModel.isToday ? Color.Custom.general : .clear)
                .foregroundStyle(calendarModel.isToday ? Color.Custom.point : Color.Custom.general)
                .clipShape(Circle())
        })
        .frame(height: 50)
        .sheet(isPresented: $showMoodRecordView) {
            MoodRecordView()
        }
    }
}

struct DayCellView_Previews: PreviewProvider {
  static var previews: some View {
      DayCellView(calendarModel: CalendarModel(year: 2024, month: 2, day: 24, isToday: true))
  }
}
