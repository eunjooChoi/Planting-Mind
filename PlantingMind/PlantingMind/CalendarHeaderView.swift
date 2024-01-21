//
//  CalendarHeaderView.swift
//  PlantingMind
//
//  Created by 최은주 on 1/18/24.
//

import SwiftUI

struct CalendarHeaderView: View {
    @Binding var currentDate: Date
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy. MM"
        return formatter
    }()
    
    var body: some View {
        HStack(spacing: 15, content: {
            Button(action: {
                changeMonth(value: -1)
            }, label: {
                Image(systemName: "chevron.left")
                    .font(.title)
                    .foregroundStyle(.black)
            })
            
            Text(currentDate, formatter: dateFormatter)
                .font(.title)
                .fontWeight(.bold)
            
            Button(action: {
                changeMonth(value: 1)
            }, label: {
                Image(systemName: "chevron.right")
                    .font(.title)
                    .foregroundStyle(.black)
            })
        })
        .padding(.bottom, 25)
    }
    
    func changeMonth(value: Int) {
        guard let newMonth = Calendar.current.date(byAdding: .month, value: value, to: currentDate) else {
            return
        }
        
        currentDate = newMonth
    }
}

struct CalendarHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarHeaderView(currentDate: .constant(Date()))
    }
}

