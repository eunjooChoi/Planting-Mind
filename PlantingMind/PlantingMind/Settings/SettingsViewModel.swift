//
//  SettingsViewModel.swift
//  PlantingMind
//
//  Created by 최은주 on 4/9/24.
//

import Foundation
import CoreData
import Combine

class SettingsViewModel: ObservableObject {
    private let context: NSManagedObjectContext
    private var cancellables: Set<AnyCancellable>
    private var result: [MoodRecord] = []
    
    @Published var showImportSuccessAlert: Bool = false
    
    init(context: NSManagedObjectContext) {
        self.cancellables = []
        self.context = context
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
            print(error.localizedDescription)
        }
        
        return nil
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
            print(error)
        }
    }
    
    private func deleteAllData() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "MoodRecord")
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try context.execute(batchDeleteRequest)
        } catch {
            print(error)
        }
    }
    
    private func fetchAllData() {
        let fetchRequest = NSFetchRequest<MoodRecord>(entityName: "MoodRecord")
        fetchRequest.returnsObjectsAsFaults = false
        
        do {
            let result = try self.context.fetch(fetchRequest)
            self.result = result
        } catch {
            print(error.localizedDescription)
        }
    }
    
    private func bindSaveNotification() {
        NotificationCenter.default.publisher(for: Notification.Name.NSManagedObjectContextDidSave)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self = self else { return }
                self.showImportSuccessAlert.toggle()
                NotificationCenter.default.post(name: .fetchNotification,
                                                object: nil)
            }
            .store(in: &cancellables)
    }
}
