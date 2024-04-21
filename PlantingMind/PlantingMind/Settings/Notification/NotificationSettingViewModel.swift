//
//  NotificationSettingViewModel.swift
//  PlantingMind
//
//  Created by 최은주 on 4/15/24.
//

import Foundation
import Combine

class NotificationSettingViewModel: ObservableObject {
    private var cancellables: Set<AnyCancellable>
    
    @Published var permission: Bool = false
    @Published var pickedTime: Date
    
    let notificationManager: Notificable
    
    init(notificationManager: Notificable) {
        self.cancellables = []
        self.notificationManager = notificationManager
        
        let hour = self.notificationManager.hour
        let minute = self.notificationManager.minute
        self.pickedTime = Calendar.current.date(bySettingHour: hour, minute: minute, second: 0, of: Date()) ?? Date()
        
        self.$pickedTime.sink {[weak self] newValue in
            self?.notificationManager.addNotification(date: newValue)
        }
        .store(in: &cancellables)
    }
    
    func checkPermission() {
        self.notificationManager.checkPermission { isAuthorized in
            Just(isAuthorized)
                .receive(on: DispatchQueue.main)
                .assign(to: &self.$permission)
        }
    }
}
