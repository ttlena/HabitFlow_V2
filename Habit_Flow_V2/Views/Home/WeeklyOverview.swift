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
        ScrollView(.horizontal, showsIndicators: false){
            HStack(spacing: 10) {
                ForEach(weekdays, id: \.self) { day in
                    VStack {
                        Text(calendarViewModel.getDateWeekday(date:day))
                        Text(calendarViewModel.getDateDayNumber(date:day))
                    }
                    .frame(width: 35)
                    .padding()
                    .background(calendarViewModel.getDateDayNumber(date: day) == calendarViewModel.getDateDayNumber(date: Date.now) ? .orange : .gray)
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

struct WeeklyOverview_Previews: PreviewProvider {
    static var previews: some View {
        WeeklyOverview(calendarViewModel: CalendarViewModel())
            .environmentObject(NavigationBarViewModel())
    }
}
