//
//  StringExtension.swift
//  PlantingMind
//
//  Created by 최은주 on 3/13/24.
//

import Foundation

extension String {
    var localized: String {
        NSLocalizedString(self, comment: "")
    }
    
    func localized(with arguments: [CVarArg] = []) -> String {
        return String(format: self.localized, arguments: arguments)
    }
}
