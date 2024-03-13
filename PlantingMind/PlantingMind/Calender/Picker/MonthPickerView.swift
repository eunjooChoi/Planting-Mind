//
//  MonthPickerView.swift
//  PlantingMind
//
//  Created by 최은주 on 3/13/24.
//

import SwiftUI

struct MonthPickerView: View {
    @Binding var pickedDate: Date
    @State var year: String = ""
    
    var dateRange: ClosedRange<Date> {
        let min = Calendar.current.date(from: DateComponents(year: 2024, month: 1, day: 1))!
        let max = Date()
        return min...max
    }
    
    var body: some View {
        HStack {
            Picker("", selection: $year) {
                ForEach(2024 ..< 2026) {year in
                    Text("\(year)")
                        .bold()
                }
            }
            .labelsHidden()
            .frame(width: 130, height: 200)
            
            Picker("", selection: $year) {
                ForEach(1 ..< 13) {month in
                    Text("\(month)")
                        .bold()
                }
            }
            .labelsHidden()
            .frame(width: 80, height: 200)
        }
        .pickerStyle(.wheel)
        .compositingGroup()
        .clipped()
    }
}

#Preview {
    MonthPickerView(pickedDate: .constant(Date()))
}
