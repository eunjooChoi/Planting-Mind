//
//  ColorExtension.swift
//  PlantingMind
//
//  Created by 최은주 on 1/23/24.
//

import Foundation
import SwiftUI

private enum CustomColor: String {
    case background
    case widgetBackground
    case select
    case line
    case general
    case point
    case bad
    case notBad
    case normal
    case good
    case nice
}

extension Color {
    struct Custom {
        // Basic Color
        static let background = Color(CustomColor.background.rawValue)
        static let widgetBackground = Color(CustomColor.widgetBackground.rawValue)
        static let select = Color(CustomColor.select.rawValue)
        static let line = Color(CustomColor.line.rawValue)
        static let general = Color(CustomColor.general.rawValue)
        static let point = Color(CustomColor.point.rawValue)
        
        // Mood Color
        static let bad = Color(CustomColor.bad.rawValue)
        static let notBad = Color(CustomColor.notBad.rawValue)
        static let normal = Color(CustomColor.normal.rawValue)
        static let good = Color(CustomColor.good.rawValue)
        static let nice = Color(CustomColor.nice.rawValue)
    }
}
