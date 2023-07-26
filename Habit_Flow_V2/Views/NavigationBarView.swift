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
    
    let tabItems:[TabItemData] = [
        TabItemData(image: "home_icon", selectedImage: "home_selected", title: "Home"),
        TabItemData(image: "calendar_icon", selectedImage: "calendar_selected", title: "Kalender"),
        TabItemData(image: "todos_icon", selectedImage: "todos_selected", title: "To Do's"),
        TabItemData(image: "habits_icon", selectedImage: "habits_selected", title: "Habits")
    ]
    var body: some View {
        VStack() {
            TabView(selection: $navigationBarViewModel.selectedTabIndex) {
                HomeView(habitViewModel: habitViewModel, toDosViewModel: toDosViewModel, calendarViewModel: calendarViewModel)
                    .toolbar(.hidden, for: .tabBar)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .tag(0)
                CalendarView()
                    .toolbar(.hidden, for: .tabBar)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .tag(1)
                    .environmentObject(calendarViewModel)
                ToDoListView(toDosViewModel: toDosViewModel)
                    .toolbar(.hidden, for: .tabBar)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .tag(2)
                    .environmentObject(toDosViewModel)
                HabitsView()
                    .toolbar(.hidden, for: .tabBar)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .tag(3)
                    .environmentObject(habitViewModel)
            }
            .environmentObject(navigationBarViewModel)
            
            TabBarView(tabBarItems: tabItems, selectedIndex: $navigationBarViewModel.selectedTabIndex)
                .ignoresSafeArea()
        }
        
        
        
//        TabView(selection: $navigationBarViewModel.selectedTabIndex) {
//            HomeView(habitViewModel: habitViewModel, toDosViewModel: toDosViewModel, calendarViewModel: calendarViewModel)
//                .tag(0)
//                .tabItem() {
//                    VStack {
//                        TabItemView(item: tabItems[0], isSelected: true)
//                    }
//                }
//            CalendarView()
//                .tag(1)
//                .tabItem() {
//                    Image("home_icon")
//                    Text("Home")
//
//                }
//                .environmentObject(calendarViewModel)
//            ToDoListView(toDosViewModel: toDosViewModel)
//                .tag(2)
//                .tabItem() {
//                    Image("todo_icon")
//                    Text("To Do")
//                        .foregroundColor(.white)
//
//                }
//                .environmentObject(toDosViewModel)
//            HabitsView()
//                .tag(3)
//                .tabItem() {
//                    Image("HabitsIcon")
//                    Text("Habits")
//                        .foregroundColor(.white)
//
//                }
//                .environmentObject(habitViewModel)
//        }
//        .background(.black)
//        .environmentObject(navigationBarViewModel)
    }
}

struct NavigationBar_Previews: PreviewProvider {
    static var previews: some View {
        NavigationBar()
    }
}
