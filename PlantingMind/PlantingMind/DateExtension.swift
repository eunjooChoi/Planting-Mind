//
//  DateExtension.swift
//  PlantingMind
//
//  Created by 최은주 on 3/9/24.
//

import Foundation

extension Date {
    var startOfMonth: Date? {
        Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: self))
    }
    
    var endOfMonth: Date? {
        guard let nextMonth = Calendar.current.date(byAdding: .month, value: 1, to: self),
              let startOfNextMonth = Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: nextMonth)) else {
            return nil
        }
        
        return Calendar.current.date(byAdding: .second, value: -1, to: startOfNextMonth)
    }
}
