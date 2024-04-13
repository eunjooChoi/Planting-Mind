//
//  SettingsViewModel.swift
//  PlantingMind
//
//  Created by 최은주 on 4/9/24.
//

import Foundation
import CoreData
import Combine
import WidgetKit

class SettingsViewModel: ObservableObject {
    private let context: NSManagedObjectContext
    private let languageCode: String?
    
    private var cancellables: Set<AnyCancellable>
    private var result: [MoodRecord] = []
    
    @Published var showImportSuccessAlert: Bool = false
    @Published var showErrorAlert: Bool = false
    
    init(context: NSManagedObjectContext, languageCode: String? = "ko") {
        self.cancellables = []
        self.context = context
        self.languageCode = languageCode
        
        self.fetchAllData()
        self.bindSaveNotification()
    }
    
    func checkExportable() -> Bool {
        return self.result.isEmpty == false
    }
    
    func setupMindDocument() -> MindDocument? {
        do {
            let jsonData = try JSONEncoder().encode(self.result)
            return MindDocument(json: jsonData)
        } catch {
            self.showErrorAlert.toggle()
            CrashlyticsLog.shared.record(error: error)
            return nil
        }
    }
    
    func privacyPolicyURL() -> URL {
        if self.languageCode == "ko" {
            return URL(string:"https://planting-mind.notion.site/48f9b3289a5d4cd999d08955802f8d19")!
        } else {
            return URL(string:"https://planting-mind.notion.site/Privacy-Policy-af91fa5d528544ef9a30c1a95ec951c2?pvs=74")!
        }
    }
    
    func importData(url: URL) {
        do {
            let access = url.startAccessingSecurityScopedResource()
            guard access else { return }
            
            let jsonData = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            
            guard let userInfoKey = CodingUserInfoKey.context else { return }
            decoder.userInfo[userInfoKey] = self.context
            
            self.deleteAllData()
            self.result = try decoder.decode([MoodRecord].self, from: jsonData)
            
            url.stopAccessingSecurityScopedResource()
            try self.context.save()
            
        } catch {
            self.showErrorAlert.toggle()
            CrashlyticsLog.shared.record(error: error)
        }
    }
    
    private func deleteAllData() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "MoodRecord")
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try context.execute(batchDeleteRequest)
        } catch {
            self.showErrorAlert.toggle()
            CrashlyticsLog.shared.record(error: error)
        }
    }
    
    private func fetchAllData() {
        let fetchRequest = NSFetchRequest<MoodRecord>(entityName: "MoodRecord")
        fetchRequest.returnsObjectsAsFaults = false
        
        do {
            let result = try self.context.fetch(fetchRequest)
            self.result = result
        } catch {
            self.showErrorAlert.toggle()
            CrashlyticsLog.shared.record(error: error)
        }
    }
    
    private func bindSaveNotification() {
        NotificationCenter.default.publisher(for: Notification.Name.NSManagedObjectContextDidSave)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self = self else { return }
                self.showImportSuccessAlert.toggle()
                WidgetCenter.shared.reloadAllTimelines()
                NotificationCenter.default.post(name: .fetchNotification,
                                                object: nil)
            }
            .store(in: &cancellables)
    }
}
