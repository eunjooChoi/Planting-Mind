//
//  DateExtension.swift
//  PlantingMind
//
//  Created by 최은주 on 3/9/24.
//

import Foundation

extension Date {
    var startOfMonth: Date? {
        Calendar.current.dateInterval(of: .month, for: self)?.start
    }
    
    var endOfMonth: Date? {
        Calendar.current.dateInterval(of: .month, for: self)?.end
    }
}
