//
//  DateService.swift
//  Habit_Flow_V2
//
//  Created by Lena Ngo on 03.08.23.
//

import Foundation
import CoreData

class DateService: ObservableObject {
    private var dataController = DataController(name: "Model")
    @Published var dateKeeper:DateKeeper = DateKeeper()
    
    init() {
        fetchData()
    }
    
    func fetchData() {
        let request = NSFetchRequest<DateKeeper>(entityName: "DateKeeper")
        request.fetchLimit = 1
        do {
            if let fetchDateKeeper = try dataController.container.viewContext.fetch(request).first {
                dateKeeper = fetchDateKeeper
                return
            }
        } catch {
            print("CoreData error")
        }
        createHelper()
    }
    
    func save() {
        do {
            try dataController.container.viewContext.save()
            //print("saved!")
        } catch {
            print("DateService - speichern failed \(            error.localizedDescription)")
        }
    }
    
    func createHelper() {
        let dateKeeper = DateKeeper(context:dataController.container.viewContext)
        dateKeeper.id = UUID()
        dateKeeper.currentWeek = Int64(getCurrent(component: Calendar.Component.weekOfYear))
        dateKeeper.lastWeek = dateKeeper.currentWeek - 1
        dateKeeper.currentMonth = Int64(getCurrent(component: Calendar.Component.month))
        dateKeeper.currentYear = Int64(getCurrent(component: Calendar.Component.year))
        save()
        fetchData()
    }
    
    func getCurrent(component : Calendar.Component) -> Int {
        let calendar = Calendar(identifier: .gregorian)
        return calendar.component(component, from: Date())
    }
    
    func checkIfNewWeek() -> Bool {
        let currentWeek = getCurrent(component: Calendar.Component.weekOfYear)
        if dateKeeper.currentWeek != currentWeek {
            dateKeeper.lastWeek = dateKeeper.currentWeek
            dateKeeper.currentWeek = Int64(currentWeek)
            dateKeeper.nextWeekStarted = true
        } else {
            dateKeeper.nextWeekStarted = false
        }
        save()
        fetchData()
        return dateKeeper.nextWeekStarted
    }
    
    func checkIfNewMonth() -> Bool {
        let currentMonth = getCurrent(component: Calendar.Component.month)
        if dateKeeper.currentMonth != currentMonth {
            dateKeeper.currentMonth = Int64(currentMonth)
            save()
            fetchData()
            return true
        }
        return false
    }
    
    func checkIfNewYear() -> Bool {
        let currentYear = getCurrent(component: Calendar.Component.year)
        if dateKeeper.currentYear != currentYear {
            dateKeeper.currentYear = Int64(currentYear)
            save()
            fetchData()
            return true
        }
        return false
    }

    
    
    func numberOfDaysInCurrentMonth() -> Int {
        let calendar = Calendar.current
        let currentDate = Date()
        let currentMonth = calendar.component(.month, from: currentDate)
        let currentYear = calendar.component(.year, from: currentDate)
        
        guard let firstDayOfNextMonth = calendar.date(from: DateComponents(year: currentYear, month: currentMonth + 1, day: 1)) else {
            return 0
        }
        guard let lastDayOfMonth = calendar.date(byAdding: .day, value: -1, to: firstDayOfNextMonth) else {
            return 0
        }
        
        let numberOfDays = calendar.component(.day, from: lastDayOfMonth)
        return numberOfDays
    }
    
    
    
    func occurrencesOfWeekdaysInCurrentMonth(in weekdays: [String]) -> Int {
        let calendar = Calendar.current
        
        let currentDate = Date()
        
        let year = calendar.component(.year, from: currentDate)
        let month = calendar.component(.month, from: currentDate)
        
        var firstDateComponents = DateComponents()
        firstDateComponents.year = year
        firstDateComponents.month = month
        firstDateComponents.day = 1
        let firstDate = calendar.date(from: firstDateComponents)!
        
        var nextMonthComponents = DateComponents()
        nextMonthComponents.month = 1
        let nextMonthDate = calendar.date(byAdding: nextMonthComponents, to: firstDate)!
        
        var currentDateInLoop = firstDate
        var occurrences = 0
        
        while currentDateInLoop < nextMonthDate {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "E"
            dateFormatter.locale = Locale(identifier: "de_DE")
            let weekdayString = dateFormatter.string(from: currentDateInLoop).lowercased()
            
            if weekdays.contains(String(weekdayString.dropLast())) {
                occurrences += 1
            }
            
            currentDateInLoop = calendar.date(byAdding: .day, value: 1, to: currentDateInLoop)!
        }
        
        return occurrences
    }
    
    func occurrencesOfWeekdaysInCurrentMonth_dependentOnCurrentDay(in weekdays: [String]) -> Int {
        let calendar = Calendar.current
        
        var currentDate =  Date()
        
        
        let year = calendar.component(.year, from: currentDate)
        let month = calendar.component(.month, from: currentDate)
        
        var firstDateComponents = DateComponents()
        firstDateComponents.year = year
        firstDateComponents.month = month
        firstDateComponents.day = 2
        let firstDate = calendar.date(from: firstDateComponents)!
        
        var nextMonthComponents = DateComponents()
        nextMonthComponents.month = 1
        let nextMonthDate =  calendar.date(byAdding: nextMonthComponents, to: firstDate)!
        
        var currentDateInLoop = currentDate
        var occurrences = 0
        
        while deleteClockComponentFromDate(date: currentDateInLoop) < nextMonthDate {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "E"
            dateFormatter.locale = Locale(identifier: "de_DE")
            let weekdayString = dateFormatter.string(from: currentDateInLoop).lowercased()
            
            if weekdays.contains(String(weekdayString.dropLast())) {
                occurrences += 1
            }
            
            currentDateInLoop = calendar.date(byAdding: .day, value: 1, to: currentDateInLoop)!
        }
        
        return occurrences
    }
    
    
    func occurrencesOfWeekdaysInCurrentWeek_dependOnCurrentDay(in weekdays: [String]) -> Int {
        let calendar = Calendar.current
        
        let currentDate = Date()
        
        var startDate: Date = currentDate
        var interval: TimeInterval = 0
        _ = calendar.dateInterval(of: .weekOfYear, start: &startDate, interval: &interval, for: currentDate)
        let endDate = startDate.addingTimeInterval(interval - 1)
        
        var currentDateInLoop = currentDate
        var occurrences = 0
        
        while currentDateInLoop < endDate {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "E"
            dateFormatter.locale = Locale(identifier: "de_DE")
            let weekdayString = dateFormatter.string(from: currentDateInLoop).lowercased()
            
            if weekdays.contains(String(weekdayString.dropLast())) {
                occurrences += 1
            }
            
            currentDateInLoop = calendar.date(byAdding: .day, value: 1, to: currentDateInLoop)!
        }
        
        return occurrences
    }
    
    
    func occurrencesOfWeekdaysInCurrentYear(in weekdays: [String]) -> Int {
        let calendar = Calendar.current
        
        let currentDate = Date()
        
        let year = calendar.component(.year, from: currentDate)
        
        var firstDateComponents = DateComponents()
        firstDateComponents.year = year
        firstDateComponents.month = 1
        firstDateComponents.day = 2
        let firstDateOfYear = calendar.date(from: firstDateComponents)!
        
        var nextYearComponents = DateComponents()
        nextYearComponents.year = 1
        let nextYearDate = calendar.date(byAdding: nextYearComponents, to: firstDateOfYear)!
        
        var currentDateInLoop = firstDateOfYear
        var occurrences = 0
        
        while deleteClockComponentFromDate(date: currentDateInLoop) < nextYearDate {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "E"
            dateFormatter.locale = Locale(identifier: "de_DE")
            let weekdayString = dateFormatter.string(from: currentDateInLoop).lowercased()
            
            if weekdays.contains(String(weekdayString.dropLast())) {
                occurrences += 1
            }
            
            currentDateInLoop = calendar.date(byAdding: .day, value: 1, to: currentDateInLoop)!
        }
        
        return occurrences
    }
    
    func occurrencesOfWeekdaysInCurrentYear_dependOnCurrentDay(in weekdays: [String]) -> Int {
        let calendar = Calendar.current
        
        let currentDate = Date()
        
        let year = calendar.component(.year, from: currentDate)
        
        var firstDateComponents = DateComponents()
        firstDateComponents.year = year
        firstDateComponents.month = 1
        firstDateComponents.day = 2
        let firstDateOfYear = calendar.date(from: firstDateComponents)!
        
        var nextYearComponents = DateComponents()
        nextYearComponents.year = 1
        let nextYearDate = calendar.date(byAdding: nextYearComponents, to: firstDateOfYear)!
        
        var currentDateInLoop = currentDate
        var occurrences = 0
        
        while deleteClockComponentFromDate(date: currentDateInLoop) < nextYearDate {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "E"
            dateFormatter.locale = Locale(identifier: "de_DE")
            let weekdayString = dateFormatter.string(from: currentDateInLoop).lowercased()
            
            if weekdays.contains(String(weekdayString.dropLast())) {
                occurrences += 1
            }
            
            currentDateInLoop = calendar.date(byAdding: .day, value: 1, to: currentDateInLoop)!
        }
        
        return occurrences
    }
    
    func deleteClockComponentFromDate(date: Date) -> Date {
        let calendar = Calendar.current
        
        let dateComponents = calendar.dateComponents([.year, .month, .day], from: date)
        guard let extractedDate = calendar.date(from: dateComponents) else {
            fatalError("Fehler beim Extrahieren des Datums aus date")
        }
        
        var updatedDateComponents = calendar.dateComponents(in: TimeZone.current, from: extractedDate)
        updatedDateComponents.hour = 24
        updatedDateComponents.minute = 0
        updatedDateComponents.second = 0
        
        guard let updatedDate = calendar.date(from: updatedDateComponents) else {
            fatalError("Fehler beim Setzen der Uhrzeit auf Mitternacht")
        }
        
        return updatedDate
    }
    
    func numberOfDaysInCurrentYear() -> Int {
        let calendar = Calendar.current
        let currentDate = Date()
        let currentYear = calendar.component(.year, from: currentDate)
        
        var dateComponents = DateComponents(year: currentYear, month: 12, day: 31)
        
        guard let lastDayOfYear = calendar.date(from: dateComponents) else {
            return 0
        }
        
        let numberOfDays = calendar.dateComponents([.day], from: currentDate, to: lastDayOfYear).day ?? 0
        return numberOfDays + 1
    }
    
    func getWeekDayFromData(from date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "E"
        dateFormatter.locale = Locale(identifier: "de_DE")
        return String(dateFormatter.string(from: date).lowercased().dropLast())
    }
    
    
    func previousDay(from date: Date) -> Date {
        let calendar = Calendar.current
        return calendar.date(byAdding: .day, value: -1, to: date) ?? Date()
    }
    
    func areDatesOnSameDay(_ date1: Date, _ date2: Date) -> Bool {
        let calendar = Calendar.current
        let normalizedDate1 = calendar.startOfDay(for: date1)
        let normalizedDate2 = calendar.startOfDay(for: date2)
        
        return calendar.isDate(normalizedDate1, inSameDayAs: normalizedDate2)
    }
    
    
    
}

