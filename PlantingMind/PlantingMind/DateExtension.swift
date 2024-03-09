//
//  DateExtension.swift
//  PlantingMind
//
//  Created by 최은주 on 3/9/24.
//

import Foundation

extension Date {
    func timeStampString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        return dateFormatter.string(from: self)
    }
}
