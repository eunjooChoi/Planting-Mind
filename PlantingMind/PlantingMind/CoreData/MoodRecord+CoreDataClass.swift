//
//  MoodRecord+CoreDataClass.swift
//  PlantingMind
//
//  Created by 최은주 on 3/4/24.
//
//

import Foundation
import CoreData

@objc(MoodRecord)
public class MoodRecord: NSManagedObject, Codable {
    enum CodingKeys: String, CodingKey {
        case timestamp, mood, reason
    }
    
    public required convenience init(from decoder: Decoder) throws {
        guard let key = CodingUserInfoKey.context,
              let context = decoder.userInfo[key] as? NSManagedObjectContext else {
            throw ContextError.noContextFound
        }
        
        self.init(context: context)
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.timestamp = try container.decode(Date.self, forKey: .timestamp)
        self.mood = try container.decode(String.self, forKey: .mood)
        self.reason = try container.decode(String?.self, forKey: .reason)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.timestamp, forKey: .timestamp)
        try container.encode(self.mood, forKey: .mood)
        try container.encode(self.reason, forKey: .reason)
    }
}

extension CodingUserInfoKey {
    static let context = CodingUserInfoKey(rawValue: "managedObjectContext")
}

enum ContextError: Error {
    case noContextFound
}

