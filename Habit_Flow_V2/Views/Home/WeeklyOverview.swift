//
//  WeeklyOverview.swift
//  Habit_Flow_V2
//
//  Created by Lena Ngo on 20.06.23.
//

import SwiftUI

struct WeeklyOverview: View {
    @EnvironmentObject var navigationBarViewModel: NavigationBarViewModel
    @StateObject var calendarViewModel: CalendarViewModel
    
    var body: some View {
        
        let weekdays = navigationBarViewModel.selectedTabIndex == 0 ? calendarViewModel.getCurrentWeekdays() : calendarViewModel.getSevenWeekdays()
        Text("Wochenübersicht")
            .frame(maxWidth: .infinity, alignment: .leading)
            .foregroundColor(.white)
        ScrollView(.horizontal, showsIndicators: false){
            HStack(spacing: 10) {
                ForEach(weekdays, id: \.self) { day in
                    VStack {
                        Text(calendarViewModel.getDateWeekday(date:day))
                        Text(calendarViewModel.getDateDayNumber(date:day))
                    }
                    .frame(width: 35)
                    .padding()
                    .background(backgroundColor(for: day , pickedDate: calendarViewModel.pickedDate))
                    //.background(calendarViewModel.getDateDayNumber(date: day) == calendarViewModel.getDateDayNumber(date: Date.now) ? Color(UIColor(red: 1, green: 0.6, blue: 0, alpha: 1)) : Color(UIColor.systemGray5))
                    .cornerRadius(10)
                    .onTapGesture {
                        if(navigationBarViewModel.selectedTabIndex == 0){
                            navigationBarViewModel.selectedTabIndex = 1
                            calendarViewModel.pickedDate = day
                        }else if(navigationBarViewModel.selectedTabIndex == 2) {
                            calendarViewModel.pickedDate = day
                        }
                        //calendarViewModel.pickedDate = day
                        
                    }
                }
            }
        }
    }
    
    
}


func backgroundColor (for date: Date, pickedDate: Date) -> Color {
    let calendar = Calendar.current
    
    let dayNumber = calendar.component(.day, from: date)
    let todayNumber = calendar.component(.day, from: Date())
    let selectedNumber = calendar.component(.day, from: pickedDate)
    
    
    if dayNumber != todayNumber && dayNumber != selectedNumber{
        return Color(UIColor.systemGray5) // Graue Farbe für vergangene Tage
    } else if dayNumber == selectedNumber {
        return Color(UIColor(red: 1, green: 0.6, blue: 0, alpha: 1)) // Orange Farbe für den ausgewählten Tag
    } else {
        return Color(UIColor(red: 1, green: 0.6, blue: 0, alpha: 0.5)) // Leichtes Orange für aktuellen Tag
    }
}


struct WeeklyOverview_Previews: PreviewProvider {
    static var previews: some View {
        WeeklyOverview(calendarViewModel: CalendarViewModel())
            .environmentObject(NavigationBarViewModel())
    }
}
