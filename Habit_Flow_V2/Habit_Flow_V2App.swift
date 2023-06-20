//
//  Habit_Flow_V2App.swift
//  Habit_Flow_V2
//
//  Created by Lena Ngo on 19.06.23.
//

import SwiftUI

@main
struct Habit_Flow_V2App: App {
    @StateObject private var dataController = DataController.shared
    var body: some Scene {
        WindowGroup {
//            ContentView()
            NavigationBar()
                .environment(\.managedObjectContext, dataController.container.viewContext)
        }
    }
}
