//
//  NotificationManager.swift
//  Habit_Flow_V2
//
//  Created by Marc Bachmann on 02.08.23.
//

import Foundation
import UserNotifications

class NotificationManager {
    
    static let instance = NotificationManager()
    
    func requestAuthorization() {
        let options: UNAuthorizationOptions = [.alert, .sound, .badge]
        UNUserNotificationCenter.current().requestAuthorization(options: options) {(success, error) in
            if let error = error {
                print("ERROR: \(error)")
            }else {
                print("SUCCESS")
            }
        }
    }
    
    func toDoNoification(numberOfUndoneToDos: Int) {
        
        removeNotification(with: "habitFlow.toDoNotification")
        
        let content = UNMutableNotificationContent()
        content.title = "Du hast noch offene ToDo's!"
        content.subtitle = "Erlelige noch " + String(numberOfUndoneToDos) + " ToDo's, um deinen Tag erfolgreich zu beenden!"
        content.sound = .default
        content.badge = 1
        
        //let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5.0, repeats: false)
        var dateComponents = DateComponents()
        dateComponents.hour = 21
        dateComponents.minute = 00
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        
        let request = UNNotificationRequest(
            identifier: "habitFlow.toDoNotification",
            content: content,
            trigger: trigger)
        UNUserNotificationCenter.current().add(request)
    }
    
    
    func removeNotification(with identifier: String) {
        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(withIdentifiers: [identifier])
        
    }
}
