//
//  CalendarViewModel.swift
//  Habit_Flow_V2
//
//  Created by Lena Ngo on 22.06.23.
//

import Foundation
import CoreData
import Combine

class CalendarViewModel: ObservableObject {
    
    
    struct DailyAppointments {
        var appointments: [Appointment] = []
    }
    
    private var dataController = DataController(name: "Model")
    @Published var appointments: [Appointment] = []
    @Published var pickedDate: Date = Date()
    @Published var newEventTitle = ""
    @Published var newEventDate = Date()
    @Published var showingBottomSheet = false
    @Published var structuredAppointmentsMap: Dictionary<Date, [Appointment]> = [:]
    private var cancellables: Set<AnyCancellable> = []


    
    init() {
        fetchData()
        deleteAllAppointments()
        structuredAppointmentsMap.removeAll()
        setupListener()
    }
    
    func fetchData() {
        let request = NSFetchRequest<Appointment>(entityName: "Appointment")
        
        do {
            appointments = try dataController.container.viewContext.fetch(request)
        } catch {
            print("CoreData Error at aAppointmets")
        }
        createStructuredAppointments()
    }
    
    func createStructuredAppointments() {
        for event in appointments {
            if let rawDate = event.date {
                let date = extractClockComponentFromDate(date: rawDate)
                if var appointmentsForDate = structuredAppointmentsMap[date] {
                    if !appointmentsForDate.contains(event) {
                        appointmentsForDate.append(event)
                        structuredAppointmentsMap[date] = appointmentsForDate
                    }
                } else {
                    structuredAppointmentsMap[date] = [event]
                }
            } else {
                print("date nicht vorhanden")
            }
        }
    }
    
    func extractClockComponentFromDate(date: Date) -> Date {
        let calendar = Calendar.current

        let dateComponents = calendar.dateComponents([.year, .month, .day], from: date)
        guard let extractedDate = calendar.date(from: dateComponents) else {
            fatalError("Fehler beim Extrahieren des Datums aus date")
        }
        return extractedDate
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
        toggleBottomSheet()
        resetInput()
    }
    
    func deleteAppointment(obj: Appointment) {
        print("delete Appointment")
        if let item = appointments.firstIndex(where: {$0.id == obj.id}) {
            dataController.container.viewContext.delete(appointments.remove(at: item))
        }
        save()
        fetchData()
    }
    
    func deleteAllAppointments() {
        for item in appointments {
            dataController.container.viewContext.delete(item)
        }
        save()
        fetchData()

    }
    
    func resetInput() {
        newEventTitle = ""
    }
    
    func toggleBottomSheet() {
        showingBottomSheet.toggle()
    }
    
    func save() {
        try? dataController.container.viewContext.save()
    }
    
    private func setupListener() {
        setupPickedDateListener()
    }
    
    private func setupPickedDateListener() {
        $pickedDate
            .sink(receiveValue: { [weak self] newDate in
                let currentDate = Date()
                if let pickedDate = self?.pickedDate {
                    if newDate > currentDate {
                        self?.newEventDate = newDate
                    } else {
                        self?.newEventDate = currentDate
                    }
                }
            })
            .store(in: &cancellables)
    }
}
