//
//  LocalNotificationManager.swift
//  Todolist
//
//  Created by 이정환 on 2020/12/26.
//


import Foundation
import UserNotifications

struct JHNotification {
    var id: String
    var title: String
}

class LocalNotificationManager {
    var notifications = [JHNotification]()
    
    func requestPermission() -> Void {
        UNUserNotificationCenter
            .current()
            .requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
                if granted == true && error == nil {
                    // We have permission!
                }
        }
    }
    
    func addNotification(title: String) -> Void {
        notifications.append(JHNotification(id: UUID().uuidString, title: title))
    }
    func schedule() -> Void {
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
        
        func scheduleNotifications() -> Void {
            for notification in notifications {
                let content = UNMutableNotificationContent()
                content.title = notification.title
                content.sound = .default
                
                var dateComponents = DateComponents()
                dateComponents.calendar = Calendar.current
                dateComponents.hour = 0
                dateComponents.minute = 59
                let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
                let request = UNNotificationRequest(identifier: notification.id, content: content, trigger: trigger)
                
                UNUserNotificationCenter.current().add(request) { error in
                    guard error == nil else { return }
                    print("Scheduling notification with id: \(notification.id)")
                }
            }
        }
}
