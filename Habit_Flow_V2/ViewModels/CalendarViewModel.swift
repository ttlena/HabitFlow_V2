//
//  CalendarViewModel.swift
//  Habit_Flow_V2
//
//  Created by Lena Ngo on 22.06.23.
//

import Foundation
import CoreData

class CalendarViewModel: ObservableObject {
    private var dataController = DataController(name: "Model")
    @Published var appointments: [Appointment] = []
    @Published var pickedDate = Date()
    @Published var newEventTitle = ""
    @Published var newEventDate = Date()
    @Published var showingBottomSheet = false

    
    init() {
        fetchData()
    }
    
    func fetchData() {
        let request = NSFetchRequest<Appointment>(entityName: "Appointment")
        
        do {
            appointments = try dataController.container.viewContext.fetch(request)
        } catch {
            print("CoreData Error at aAppointmets")
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
    /*
    func getPreAndNextDays() -> [Date] {
        var calendar = Calendar.autoupdatingCurrent
        let today = calendar.startOfDay(for: Date())
        var week : [Date] = []
        
        for i in -3...3 {
            if let day = calendar.date(byAdding: .day, value: i, to: weekInterval.start) {
                week += [day]
            }
        }
        return week
    }
     */
    
    
    
    func getSevenWeekdays() -> [Date] {
        let calendar = Calendar.current
        let today = Date()

        var weekdays: [Date] = []
        
        // Füge die drei Wochentage vor dem aktuellen Tag hinzu
        if let threeDaysAgo = calendar.date(byAdding: .day, value: -3, to: today) {
            for i in 0..<3 {
                if let day = calendar.date(byAdding: .day, value: i, to: threeDaysAgo) {
                    weekdays.append(day)
                }
            }
        }
        
        // Füge den aktuellen Tag hinzu
        weekdays.append(today)
        
        // Füge die drei Wochentage nach dem aktuellen Tag hinzu
        if let threeDaysLater = calendar.date(byAdding: .day, value: 1, to: today) {
            for i in 0..<3 {
                if let day = calendar.date(byAdding: .day, value: i, to: threeDaysLater) {
                    weekdays.append(day)
                }
            }
        }

        return weekdays
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
    
    func addNewAppointment() {
        let newAppointment = Appointment(context: dataController.container.viewContext)
        newAppointment.id = UUID()
        newAppointment.title = newEventTitle
        newAppointment.date = newEventDate
        save()
        fetchData()
        newDate()
    }
    
    func resetInput() {
        newEventTitle = ""
        newEventDate = Date()
    }
    
    func newDate() {
        showingBottomSheet.toggle()
    }
    
    func save() {
        try? dataController.container.viewContext.save()
    }
}
