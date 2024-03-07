//
//  DayCellView.swift
//  PlantingMind
//
//  Created by 최은주 on 1/19/24.
//

import SwiftUI

struct DayCellView: View {
    @Environment(\.managedObjectContext) var context
    @State var showMoodRecordView: Bool = false
    
    var dayCellModel: DayCellModel
    
    var body: some View {
        VStack(spacing: -5) {
            Button(action: {
                showMoodRecordView.toggle()
            }, label: {
                Text("\(dayCellModel.calendarModel.day)")
                    .frame(width: 30, height: 30)
                    .fontWeight(.semibold)
                    .background(dayCellModel.calendarModel.isToday ? Color.Custom.general : .clear)
                    .foregroundStyle(dayCellModel.calendarModel.isToday ? Color.Custom.point : Color.Custom.general)
                    .clipShape(Circle())
            })
            .frame(height: 50)
            .sheet(isPresented: $showMoodRecordView) {
                MoodRecordView(viewModel: MoodRecordViewModel(context: context, calendarModel: dayCellModel.calendarModel))
                    .interactiveDismissDisabled(true)
            }
            
            if let mood = dayCellModel.mood {
                RoundedRectangle(cornerRadius: 5)
                    .frame(height: 16)
                    .foregroundStyle(mood.color)
                    .overlay {
                        Image(mood.emojiName, bundle: nil)
                    }
            } else {
                Rectangle()
                    .frame(height: 16)
                    .foregroundStyle(Color.clear)
            }
        }
    }
}

#Preview {
    DayCellView(dayCellModel: DayCellModel(calendarModel: CalendarModel(year: 2024, month: 2, day: 24, isToday: true),
                                            moodRecord: MoodRecord(context: CoreDataStack(.inMemory).persistentContainer.viewContext)))
}
