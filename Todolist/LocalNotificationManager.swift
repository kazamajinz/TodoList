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
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) {
                granted, error in
                    if granted == true && error == nil {
                    }
            }
    }
    
    func addNotification(title: String) -> Void {
        notifications.append(JHNotification(id: UUID().uuidString, title: title))
    }
    
    func deleteNotifications(){
        let center = UNUserNotificationCenter.current()
        center.removeAllDeliveredNotifications()
        center.removeAllPendingNotificationRequests()
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
            let todoListViewModel = TodoViewModel()
            let todayCount = todoListViewModel.todayTodos.count
            let todayTodosNotDone = todoListViewModel.todayTodosNotDone.count
            
            content.title = notification.title
            content.sound = .default
            
            if todayCount == 0 {
            } else {
                if todayTodosNotDone == 0 {
                   content.body = "오늘의 할일을 모두 완수하였습니다.🤗"
                } else {
                   content.body = "아직 할일이 \(todayTodosNotDone)개 남았습니다.😅"
                }
            }
            
            //시간설정
            var dateComponents = DateComponents()
            dateComponents.calendar = Calendar.current
            
            let plist = UserDefaults.standard
            dateComponents.hour = plist.integer(forKey: "hourAlert")
            dateComponents.minute = plist.integer(forKey: "minuteAlert")
            
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
            let request = UNNotificationRequest(identifier: notification.id, content: content, trigger: trigger)
            
            UNUserNotificationCenter.current().add(request) { error in
                guard error == nil else { return }
                print("Scheduling notification with id: \(notification.id)")
            }
        }
    }
}
