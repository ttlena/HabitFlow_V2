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
           // Führe hier den gewünschten Code aus.

           // Beispiel: Zeige eine Nachricht in der Konsole an.
           UIApplication.shared.applicationIconBadgeNumber = 0
           print("Die App wurde geöffnet!")
       }
}
