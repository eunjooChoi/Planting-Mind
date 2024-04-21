//
//  CrashlyticsLog.swift
//  PlantingMind
//
//  Created by 최은주 on 4/12/24.
//

import Foundation
import FirebaseCrashlytics

class CrashlyticsLog {
    static let shared = CrashlyticsLog()
    
    func record(error: Error) {
        Crashlytics.crashlytics().record(error: error)
    }
}
