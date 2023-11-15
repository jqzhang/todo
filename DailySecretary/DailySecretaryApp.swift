//
//  DailySecretaryApp.swift
//  DailySecretary
//
//  Created by Vii on 2023/6/21.
//

import SwiftUI

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        // Show local notification in foreground
        UNUserNotificationCenter.current().delegate = self
        return true
    }
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return .portrait
    }
}
// Conform to UNUserNotificationCenterDelegate to show local notification in foreground
extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.badge, .sound, .banner, .list])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        // 获取通知的标识符（例如任务的ID）
        let notificationID = response.notification.request.identifier
        
        // 在这里可以根据notificationID来设置selectedTask，跳转到相应的任务详情页面
        // 这样用户点击通知后，就会自动跳转到相应的任务详情页面
        print("notificationID : ", notificationID) // 假设fetchTaskByID是获取任务信息的方法
        // 发送自定义通知，通知内容可以携带通知的userInfo
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            NotificationCenter.default.post(name: NSNotification.Name("SelectedTaskNotification"), object: notificationID)
        }
        
        // 调用completionHandler
        completionHandler()
    }
}

@main
struct DailySecretaryApp: App {
    
    @StateObject var toastManager = ToastManager()
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(toastManager)
                .environmentObject(ViewEnv())
        }
    }
}
