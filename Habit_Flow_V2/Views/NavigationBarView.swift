//
//  NavigationBar.swift
//  HabitFlow
//
//  Created by Lena Ngo on 12.05.23.
//

import SwiftUI

struct NavigationBar: View {
    @StateObject var navigationBarViewModel = NavigationBarViewModel()
    @StateObject var calendarViewModel = CalendarViewModel()
    @StateObject var toDosViewModel = ToDosViewModel()
    @StateObject var habitViewModel = HabitViewModel()

    var body: some View {
        TabView(selection: $navigationBarViewModel.selectedTabIndex) {
            HomeView(habitViewModel: habitViewModel, toDosViewModel: toDosViewModel, calendarViewModel: calendarViewModel)
                .tag(0)
                .tabItem() {
                    VStack {
                        Image("HomeIcon")
                        Text("Home")
                            .foregroundColor(.white)
                    }
                }
            CalendarView()
                .tag(1)
                .tabItem() {
                    Image("CalendarIcon")
                    Text("Kalender")
                        .foregroundColor(.white)

                }
                .environmentObject(calendarViewModel)
            ToDoListView(toDosViewModel: toDosViewModel)
                .tag(2)
                .tabItem() {
                    Image("ToDoIcon")
                    Text("To Do")
                        .foregroundColor(.white)

                }
                .environmentObject(toDosViewModel)
            HabitsView()
                .tag(3)
                .tabItem() {
                    Image("HabitsIcon")
                    Text("Habits")
                        .foregroundColor(.white)

                }
                .environmentObject(habitViewModel)
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
