//
//  AppDelegate.swift
//  Habit_Flow_V2
//
//  Created by Marc Bachmann on 02.08.23.
//

import Foundation
import UIKit


class AppDelegate: UIResponder, UIApplicationDelegate {
    
    let notificationManager = NotificationManager()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]?) -> Bool {
        notificationManager.requestAuthorization()
        print("Your code here")
        return true
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
           // Diese Methode wird jedes Mal ausgeführt, wenn die App in den Vordergrund geholt wird.
           UIApplication.shared.applicationIconBadgeNumber = 0
       }
}
