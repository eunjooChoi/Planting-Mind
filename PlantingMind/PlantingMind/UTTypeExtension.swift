//
//  UTTypeExtension.swift
//  PlantingMind
//
//  Created by 최은주 on 4/9/24.
//

import Foundation
import UniformTypeIdentifiers

extension UTType {
    static var mind: UTType {
            UTType(exportedAs: "com.planting-mind.fileType")
        }
}
