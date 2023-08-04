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
    @Published var newEventEndDate = Date()
    
    @Published var newEventReminder: Bool = false
    @Published var newEventReminderMinutes: Int = 0
    @Published var newEventColor: String = "red"
    
    @Published var showingBottomSheet = false
    @Published var structuredAppointmentsMap: Dictionary<Date, [Appointment]> = [:]
    @Published var isAppointmentEdited = false
    private var cancellables: Set<AnyCancellable> = []
    @Published var editedAppointment: Appointment?
    @Published var editedTitle: String = ""
    @Published var editedDate: Date = Date()
    @Published var editedId: UUID = UUID()
    @Published var editedEndDate: Date = Date()
    
    @Published var editedEventReminder: Bool = false
    @Published var editedEventReminderMinutes: Int = 0
    @Published var editedEventColor: String = "red"
    
    let notificationManager = NotificationManager()
    
    
    init() {
        fetchData()
        //deleteAllAppointments()
        //structuredAppointmentsMap.removeAll()
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
                let date = deleteClockComponentFromDate(date: rawDate)
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
    
    func deleteClockComponentFromDate(date: Date) -> Date {
        let calendar = Calendar.current
        
        let dateComponents = calendar.dateComponents([.year, .month, .day], from: date)
        guard let extractedDate = calendar.date(from: dateComponents) else {
            fatalError("Fehler beim Extrahieren des Datums aus date")
        }
        return extractedDate
    }
    
    func extractTimeFromDate(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter.string(from: date)
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
    
    func setCurrentEditedAppointmentById(id: UUID) {
        if let appointment = getAppointmentById(id: id) {
            editedAppointment = appointment
            if let appointmentTitle = appointment.title {
                editedTitle = appointmentTitle
            }
            if let appointmentDate = appointment.date {
                editedDate = appointmentDate
            }
            if let appointmentId = appointment.id {
                editedId = appointmentId
            }
            if let appointmentEndDate = appointment.endDate {
                editedEndDate = appointmentEndDate
            }
            
            editedEventReminder = appointment.remindMe
            editedEventReminderMinutes = appointment.reminderMinutes
            
            if let appointmentColor = appointment.color {
                editedEventColor = appointmentColor
            }
            
        }
    }
    
    
    func getAppointmentById(id: UUID) -> Appointment? {
        if let appointment = appointments.first(where: { $0.id == id }) {
            return appointment
        } else {
            return nil
        }
    }
    
    
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
        newAppointment.endDate = newEventEndDate
        
        newAppointment.remindMe = newEventReminder
        newAppointment.reminderMinutes = newEventReminderMinutes
        newAppointment.color = newEventColor
        
        if(newAppointment.remindMe) {
            notificationManager.calendarNotification(minutesTilToDo: newEventReminderMinutes, terminTitle: newEventTitle, terminDate: newEventDate, terminId: newAppointment.id!)
        }
        
        save()
        fetchData()
        toggleBottomSheet()
        resetInput()
    }
    
    func editAppointment() {
        if((editedAppointment?.remindMe) != nil){
            notificationManager.removeNotification(with: editedId)
        }
        editedAppointment?.id = editedId
        editedAppointment?.date = editedDate
        editedAppointment?.title = editedTitle
        
        editedAppointment?.remindMe = editedEventReminder
        editedAppointment?.reminderMinutes = editedEventReminderMinutes
        if(editedEventReminder) {
            notificationManager.calendarNotification(minutesTilToDo: editedEventReminderMinutes, terminTitle: editedTitle, terminDate: editedDate, terminId: (editedAppointment?.id)!)
        }
        editedAppointment?.color = editedEventColor
        toggleBottomSheetEditAppointment()
        save()
        fetchData()
        resetInput()
    }
    
    
    func deleteAppointment( index: Int) {
        if let dailyAppointments = structuredAppointmentsMap[deleteClockComponentFromDate(date: pickedDate)] {
            let appointmentToDelete = dailyAppointments[index]
            if let appointmentIndex = appointments.firstIndex(where: { $0.id == appointmentToDelete.id }) {
                dataController.container.viewContext.delete(appointments.remove(at: appointmentIndex))
                structuredAppointmentsMap.removeAll()
            }
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
        newEventReminder = false
        newEventReminderMinutes = 0
    }
    
    func toggleBottomSheet() {
        showingBottomSheet.toggle()
        isAppointmentEdited = false
    }
    
    func toggleBottomSheetEditAppointment() {
        showingBottomSheet.toggle()
        isAppointmentEdited = true
    }
    
    func save() {
        try? dataController.container.viewContext.save()
    }
    
    private func setupListener() {
        setupPickedDateListener()
    }
    
    private func setupPickedDateListener() {
        $pickedDate
            .sink { [weak self] newDate in
                let currentDate = Date()
                if newDate > currentDate {
                    guard let currentTimeDate = self?.setTimeToCurrentTime(newDate) else { return }
                    self?.newEventDate = currentTimeDate
                    
                    if let unwrappedCurrentTime = self?.addOneHour(to: currentTimeDate) {
                        self?.newEventEndDate = unwrappedCurrentTime
                    }
                } else {
                    self?.newEventDate = currentDate
                    if let unwrappedCurrentDate = self?.addOneHour(to: currentDate) {
                        self?.newEventEndDate = unwrappedCurrentDate
                    }
                }
            }
            .store(in: &cancellables)
    }
    
    /* private func setupEndDateValidationListener() {
     $editedEndDate
     .sink { [weak self] newEndDate in
     guard let self = self else { return }
     
     let currentEditedDate = self?.editedDate
     
     if currentEditedDate >= newEndDate {
     self.editedEndDate = currentEditedDate
     } else {
     self.editedEndDate = newEndDate
     }
     }
     .store(in: &cancellables)
     }*/
    
    func addOneHour(to date: Date) -> Date? {
        let calendar = Calendar.current
        return calendar.date(byAdding: .hour, value: 1, to: date)
    }
    
    
    func setTimeToCurrentTime(_ date: Date) -> Date {
        let calendar = Calendar.current
        let currentTime = Date()
        let timeComponents = calendar.dateComponents([.hour, .minute, .second], from: currentTime)
        return calendar.date(bySettingHour: timeComponents.hour ?? 0, minute: timeComponents.minute ?? 0, second: timeComponents.second ?? 0, of: date) ?? date
    }
}

