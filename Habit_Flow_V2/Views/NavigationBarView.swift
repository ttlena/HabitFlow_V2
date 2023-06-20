//
//  NavigationBar.swift
//  HabitFlow
//
//  Created by Lena Ngo on 12.05.23.
//

import SwiftUI

struct NavigationBar: View {
    @StateObject var toDoListViewModel: ToDoListViewModel = ToDoListViewModel()
    
    var body: some View {
        TabView {
            HomeView()
                .tabItem() {
                    VStack {
                        Image("HomeIcon")
                        Text("Home")
                            .foregroundColor(.white)
                    }
                }
            CalendarView()
                .tabItem() {
                    Image("CalendarIcon")
                    Text("Kalender")
                        .foregroundColor(.white)

                }
            ToDoListView()
                .tabItem() {
                    Image("ToDoIcon")
                    Text("To Do")
                        .foregroundColor(.white)

                }
                .environmentObject(toDoListViewModel)
            HabitsView()
                .tabItem() {
                    Image("HabitsIcon")
                    Text("Habits")
                        .foregroundColor(.white)

                }
        }
        .background(.black)
    }
}

struct NavigationBar_Previews: PreviewProvider {
    static var previews: some View {
        NavigationBar()
    }
}
