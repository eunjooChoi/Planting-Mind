//
//  CalendarModel.swift
//  PlantingMind
//
//  Created by 최은주 on 1/22/24.
//

import Foundation

struct CalendarModel: Hashable {
    let year: Int?
    let month: Int?
    let day: Int
    let isToday: Bool
}
