//
//  WeeklyOverview.swift
//  Habit_Flow_V2
//
//  Created by Lena Ngo on 20.06.23.
//

import SwiftUI

struct WeeklyOverview: View {
    @EnvironmentObject var navigationBarViewModel: NavigationBarViewModel
    @EnvironmentObject var calendarViewModel: CalendarViewModel

    var body: some View {
        let weekdays = calendarViewModel.getCurrentWeekdays()
        ScrollView(.horizontal, showsIndicators: false){
            HStack(spacing: 20) {
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
                        navigationBarViewModel.selectedTabIndex = 1
                        calendarViewModel.pickedDate = day
                    }
                }
            }
        }
    }
    
    
}

struct WeeklyOverview_Previews: PreviewProvider {
    static var previews: some View {
        WeeklyOverview()
    }
}
