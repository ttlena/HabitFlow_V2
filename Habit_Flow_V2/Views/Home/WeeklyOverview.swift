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
        let weekdays = getCurrentWeekdays()
        ScrollView(.horizontal, showsIndicators: false){
            HStack(spacing: 20) {
                ForEach(weekdays, id: \.self) { day in
                    VStack {
                        Text(getDateWeekday(date:day))
                        Text(getDateDayNumber(date:day))
                    }
                    .frame(width: 35)
                    .padding()
                    .background(.gray)
                    .cornerRadius(10)
                    .onTapGesture {
                        navigationBarViewModel.selectedTabIndex = 1
                        calendarViewModel.pickedDate = day
                    }
                }
            }
        }
    }
    
    func getCurrentWeekdays() -> [Date] {
        var calendar = Calendar.autoupdatingCurrent
        calendar.firstWeekday = 2
        let today = calendar.startOfDay(for: Date())
        var week = [Date]()
        if let weekInterval = calendar.dateInterval(of: .weekOfYear, for: today) {
            for i in 0...6 {
                if let day = calendar.date(byAdding: .day, value: i, to: weekInterval.start) {
                    week += [day]
                }
            }
        }
        return week
    }
    
    func getDateWeekday(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EE"
        dateFormatter.locale = Locale(identifier: "de_DE")
        let weekDay = dateFormatter.string(from: date)
        return weekDay
    }
    
    func getDateDayNumber(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd"
        let weekDay = dateFormatter.string(from: date)
        return weekDay
    }
}

struct WeeklyOverview_Previews: PreviewProvider {
    static var previews: some View {
        WeeklyOverview()
    }
}
