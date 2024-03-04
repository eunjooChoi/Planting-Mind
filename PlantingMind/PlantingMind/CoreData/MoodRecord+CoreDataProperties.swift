//
//  MoodRecord+CoreDataProperties.swift
//  PlantingMind
//
//  Created by 최은주 on 3/4/24.
//
//

import Foundation
import CoreData


extension MoodRecord {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MoodRecord> {
        return NSFetchRequest<MoodRecord>(entityName: "MoodRecord")
    }

    @NSManaged public var date: Date
    @NSManaged public var mood: String
    @NSManaged public var reason: String?

}

extension MoodRecord : Identifiable {

}
