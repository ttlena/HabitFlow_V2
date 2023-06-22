//
//  CalendarViewModel.swift
//  Habit_Flow_V2
//
//  Created by Lena Ngo on 22.06.23.
//

import Foundation

class CalendarViewModel: ObservableObject {
    @Published var pickedDate = Date()
    
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
