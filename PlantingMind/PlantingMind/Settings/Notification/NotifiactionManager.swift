//
//  NotifiactionManager.swift
//  PlantingMind
//
//  Created by 최은주 on 4/15/24.
//

import Foundation
import UserNotifications

enum UserDefaultsKeys: String {
    case hour
    case minute
}

struct LocalNotification {
    var id: String
    var title: String
}

protocol Notificable {
    var hour: Int { get }
    var minute: Int { get }
    
    func checkPermission(completionHandler: @escaping (Bool) -> Void) -> Void
    func addNotification(date: Date?) -> Void
}

class NotificationManager: Notificable {
    var hour: Int {
        UserDefaults.standard.integer(forKey: UserDefaultsKeys.hour.rawValue)
    }
    
    var minute: Int {
        UserDefaults.standard.integer(forKey: UserDefaultsKeys.minute.rawValue)
    }
    
    var notifications = [LocalNotification]()
    
    func checkPermission(completionHandler: @escaping (Bool) -> Void) -> Void {
        UNUserNotificationCenter.current()
            .getNotificationSettings { settings in
                completionHandler(settings.authorizationStatus == .authorized)
        }
    }
    
    func requestPermission() -> Void {
        UNUserNotificationCenter.current()
            .requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
                if let error = error {
                    CrashlyticsLog.shared.record(error: error)
                }
            }
    }
    
    func addNotification(date: Date?) -> Void {
        self.notifications.removeAll()
        self.notifications.append(LocalNotification(id: UUID().uuidString, title: ""))
        self.updateTime(date)
        self.schedule()
    }
    
    private func updateTime(_ time: Date?) {
        guard let time = time else { return }
        let calendar = Calendar.current
        UserDefaults.standard.set(calendar.component(.hour, from: time), forKey: UserDefaultsKeys.hour.rawValue)
        UserDefaults.standard.set(calendar.component(.minute, from: time), forKey: UserDefaultsKeys.minute.rawValue)
    }
    
    private func schedule() -> Void {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            switch settings.authorizationStatus {
            case .notDetermined:
                self.requestPermission()
            case .authorized, .provisional:
                self.scheduleNotifications()
            default:
                break
            }
        }
    }
    
    private func scheduleNotifications() -> Void {
        for notification in self.notifications {
            var dateComponents = DateComponents()
            dateComponents.calendar = Calendar.current
            
            let hour = self.hour
            dateComponents.hour = self.hour == 0 ? 22 : hour
            dateComponents.minute = self.minute
            
            let content = UNMutableNotificationContent()
            content.title = notification.title
            content.sound = UNNotificationSound.default
            content.body = "mood_title".localized
            content.badge = 1
            
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
            let request = UNNotificationRequest(identifier: notification.id, content: content, trigger: trigger)
            
            UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
            
            UNUserNotificationCenter.current().add(request) { error in
                if let error = error {
                    CrashlyticsLog.shared.record(error: error)
                }
            }
        }
    }
    
    
}
