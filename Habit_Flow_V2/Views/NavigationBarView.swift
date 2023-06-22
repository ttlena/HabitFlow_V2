//
//  NavigationBar.swift
//  HabitFlow
//
//  Created by Lena Ngo on 12.05.23.
//

import SwiftUI

struct NavigationBar: View {
    @StateObject var toDoListViewModel: ToDoListViewModel = ToDoListViewModel()
    @StateObject var navigationBarViewModel = NavigationBarViewModel()
    @StateObject var calendarViewModel = CalendarViewModel()

    var body: some View {
        TabView(selection: $navigationBarViewModel.selectedTabIndex) {
            HomeView()
                .tag(0)
                .tabItem() {
                    VStack {
                        Image("HomeIcon")
                        Text("Home")
                            .foregroundColor(.white)
                    }
                }
                .environmentObject(calendarViewModel)
            CalendarView()
                .tag(1)
                .tabItem() {
                    Image("CalendarIcon")
                    Text("Kalender")
                        .foregroundColor(.white)

                }
                .environmentObject(calendarViewModel)
            ToDoListView()
                .tag(2)
                .tabItem() {
                    Image("ToDoIcon")
                    Text("To Do")
                        .foregroundColor(.white)

                }
                .environmentObject(toDoListViewModel)
            HabitsView()
                .tag(3)
                .tabItem() {
                    Image("HabitsIcon")
                    Text("Habits")
                        .foregroundColor(.white)

                }
        }
        .background(.black)
        .environmentObject(navigationBarViewModel)
    }
}

struct NavigationBar_Previews: PreviewProvider {
    static var previews: some View {
        NavigationBar()
    }
}
