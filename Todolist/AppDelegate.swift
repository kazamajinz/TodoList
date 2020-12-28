//
//  AppDelegate.swift
//  Todolist
//
//  Created by 이정환 on 2020/12/26.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    /*
    func userNotificationCenter(
          _ center: UNUserNotificationCenter,
          willPresent notification: UNNotification,
          withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions)
          -> Void) {
        completionHandler([.banner, .badge, .sound, .list])
      }
    */

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        //application.applicationIconBadgeNumber = 0 // For Clear Badge Counts
        //let center = UNUserNotificationCenter.current()
        //center.removeAllDeliveredNotifications() // To remove all delivered notifications
        //center.removeAllPendingNotificationRequests() // To remove all pending notifications which are not delivered yet but scheduled.
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    
    /*
    func sceneDidBecomeActive(_ scene: UIScene) {
        UIApplication.shared.applicationIconBadgeNumber = 0
    }*/
}

