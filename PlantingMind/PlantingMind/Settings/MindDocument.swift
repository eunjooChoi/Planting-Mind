//
//  MindDocument.swift
//  PlantingMind
//
//  Created by 최은주 on 4/10/24.
//

import Foundation
import SwiftUI
import UniformTypeIdentifiers

struct MindDocument: FileDocument {
    static var readableContentTypes: [UTType] { [.mind] }
    var jsonData: Data
    
    init(configuration: ReadConfiguration) throws {
        if let data = configuration.file.regularFileContents {
            self.jsonData = data
        } else {
            throw NSError()
        }
    }
    
    init(json: Data) {
        self.jsonData = json
    }
    
    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        FileWrapper(regularFileWithContents: self.jsonData)
    }
}
