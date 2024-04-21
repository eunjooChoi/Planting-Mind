//
//  Mood.swift
//  PlantingMind
//
//  Created by 최은주 on 3/3/24.
//

import Foundation
import SwiftUI

enum Mood: String, CaseIterable {
    case nice
    case good
    case normal
    case notBad
    case bad
}

extension Mood {
    var emojiName: String {
        self.rawValue + "_emoji"
    }
    
    var color: Color {
        switch self {
        case .nice:
            Color.Custom.nice
        case .good:
            Color.Custom.good
        case .normal:
            Color.Custom.normal
        case .notBad:
            Color.Custom.notBad
        case .bad:
            Color.Custom.bad
        }
    }
    
    var moodString: String {
        self.rawValue.localized
    }
}
