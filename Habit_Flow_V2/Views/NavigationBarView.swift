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
    @StateObject var userViewModel = UserViewModel()
    
    let tabItems:[TabItemData] = [
        TabItemData(image: "home_icon", selectedImage: "home_selected", title: "Home"),
        TabItemData(image: "calendar_icon", selectedImage: "calendar_selected", title: "Kalender"),
        TabItemData(image: "todos_icon", selectedImage: "todos_selected", title: "To Do's"),
        TabItemData(image: "habits_icon", selectedImage: "habits_selected", title: "Habits")
    ]
    var body: some View {
        TabView(selection: $navigationBarViewModel.selectedTabIndex) {
            HomeView(habitViewModel: habitViewModel, toDosViewModel: toDosViewModel, calendarViewModel: calendarViewModel, userViewModel: userViewModel)
                .tag(0)
            CalendarView(habitVM: habitViewModel)
                .tag(1)
                .environmentObject(calendarViewModel)
            ToDoListView(calendarViewModel: calendarViewModel)
                .tag(2)
                .environmentObject(toDosViewModel)
            HabitsView()
                .tag(3)
                .environmentObject(habitViewModel)
        }
        .environmentObject(navigationBarViewModel)
        .safeAreaInset(edge: .bottom) {
            TabBarView(tabBarItems: tabItems, selectedIndex: $navigationBarViewModel.selectedTabIndex)
        }
    }
}

struct NavigationBar_Previews: PreviewProvider {
    static var previews: some View {
        NavigationBar()
    }
}
