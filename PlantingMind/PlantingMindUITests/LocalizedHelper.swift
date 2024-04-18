//
//  LocalizedHelper.swift
//  PlantingMindUITests
//
//  Created by 최은주 on 4/18/24.
//

import Foundation

class LocalizedHelper {
    func localized(_ key: String) -> String {
        let uiTestBundle = Bundle(for: type(of: self))
        return NSLocalizedString(key, bundle: uiTestBundle, comment: "")
    }
}
