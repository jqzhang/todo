//
//  NotificationManager.swift
//  DailySecretary
//
//  Created by Vii on 2023/7/21.
//

import SwiftUI
import UserNotifications

// 显示一个 Notification
func scheduleNotification(for date: Date, withTitle title: String, andBody body: String, notificationID: String) {
    let center = UNUserNotificationCenter.current()
    center.requestAuthorization(options: [.alert, .sound]) { _, _ in }
    
    let content = UNMutableNotificationContent()
    content.title = title
    content.body = body
    content.sound = .default
    
    let calendar = Calendar.current
    let components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
    
    let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
    
    let request = UNNotificationRequest(identifier: notificationID, content: content, trigger: trigger)
    center.add(request)
}

// 更新 Notification
func updateNotification(withIdentifier identifier: String, title: String, body: String, newTriggerDate: Date) {
    let center = UNUserNotificationCenter.current()
    
    // 获取旧的通知请求
    center.getPendingNotificationRequests { requests in
        guard requests.first(where: { $0.identifier == identifier }) != nil else {
            return // 没有找到对应的通知请求，无法更新通知
        }
        
        // 更新通知内容
        let updatedContent = UNMutableNotificationContent()
        updatedContent.title = title
        updatedContent.body = body
        updatedContent.sound = .default
        
        // 创建新的触发器，并用新的触发器替换旧的触发器
        let newTrigger = UNCalendarNotificationTrigger(dateMatching: Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: newTriggerDate), repeats: false)
        
        // 创建新的通知请求，并用新内容和触发器替换旧的内容和触发器
        let updatedRequest = UNNotificationRequest(identifier: identifier, content: updatedContent, trigger: newTrigger)
        center.add(updatedRequest, withCompletionHandler: nil)
    }
}

// 移除 Notification
func removeNotification(withIdentifier identifier: String) {
    let center = UNUserNotificationCenter.current()
    
    // 移除指定标识符的通知请求
    center.removePendingNotificationRequests(withIdentifiers: [identifier])
}


