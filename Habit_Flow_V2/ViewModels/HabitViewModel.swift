//
//  HabitViewModel.swift
//  Habit_Flow_V2
//
//  Created by Lena Ngo on 20.06.23.
//

import Foundation
import CoreData

class HabitViewModel:ObservableObject {
    private var dataController = DataController(name: "Model")
    @Published var habits: [Habit] = []
    @Published var habitsToday: [Habit] = []
    @Published var newHabitTitle = ""
    @Published var newHabitDuration: Int16?
    @Published var showAlert: Bool = false
    @Published var alertTitle = ""
    @Published var selectedDays: [String] = []
    @Published var habitMonthGoal: Int16?
    @Published var habitYearGoal: Int16?
    @Published var habitMonthProgress: Int16?
    @Published var habitYearProgress: Int16?
    @Published var editHabitTitle = ""
    @Published var plusButtonClicked = false
    @Published var newWeekStarted = false
    @Published var pickedTodayHabits: [Habit] = []
    
    @Published var habitsTodayRemovingList: [Habit] = []
    
    
    private var dateService:DateService
    private let notificationCenter = NotificationCenter.default
    
    init() {
        self.dateService = DateService()
        fetchData()
    }
    
    func fetchData() {
        let request = NSFetchRequest<Habit>(entityName: "Habit")
        do {
            habits = try dataController.container.viewContext.fetch(request)
            habitsToday = getHabitsBasedOnWeekday(pickedDate: Date())
            
        } catch {
            print("CoreData Error")
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.habitsTodayRemovingList = self.habitsToday
            self.habitsTodayRemovingList = self.showOnlyUncheckedHabits(habitsToday: self.habitsTodayRemovingList)
        }
    }
    
    func checkIfResetNecessary() {
        if dateService.checkIfNewWeek() {
            for habit in habits {
                habit.current = 0
                habit.progress = Double(habit.current) / Double(habit.goal)
                habit.goal = Int16(habit.weekdays?.count ?? 0)
            }
        }
        
        if dateService.checkIfNewMonth() {
            for habit in habits {
                habit.currentInMonth = 0
                habit.goalInMonth = Int16(dateService.occurrencesOfWeekdaysInCurrentMonth(in: habit.weekdays ?? []))
            }
        }
        
        if dateService.checkIfNewYear() {
            for habit in habits {
                habit.currentInYear = 0
                habit.goalInYear = Int16(dateService.occurrencesOfWeekdaysInCurrentYear(in: habit.weekdays ?? []))
            }
        }
        save()
        fetchData()
    }
    
    func getHabitsBasedOnWeekday(pickedDate: Date) -> [Habit] {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "E"
        dateFormatter.locale = Locale(identifier: "de_DE")
        var weekdayHabits: [Habit] = []
        
        for habit in habits {
            if let weekdays = habit.weekdays {
                for weekday in weekdays {
                    if weekday == dateService.getWeekDayFromData(from: pickedDate) {
                        weekdayHabits.append(habit)
                    }
                }
            }
        }
        return weekdayHabits
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
    
    func toggleDaySelection( day: String) {
        if selectedDays.contains(day.lowercased()) {
            selectedDays.removeAll(where: {$0 == day.lowercased()})
            newHabitDuration = Int16(selectedDays.count)
        } else {
            selectedDays.append(day.lowercased())
            newHabitDuration = Int16(selectedDays.count)
        }
    }
    
    func addData() {
        let newHabit = Habit(context: dataController.container.viewContext)
        newHabit.id = UUID()
        newHabit.title = newHabitTitle
        newHabit.weekdays = selectedDays
        newHabit.goal = Int16(dateService.occurrencesOfWeekdaysInCurrentWeek_dependOnCurrentDay(in: selectedDays))//unpackedNewHabitDuration
        print(newHabit.goal)
        newHabit.goalInMonth = Int16(dateService.occurrencesOfWeekdaysInCurrentMonth_dependentOnCurrentDay(in: selectedDays))
        print(newHabit.goalInMonth)
        newHabit.goalInYear = Int16(dateService.occurrencesOfWeekdaysInCurrentYear_dependOnCurrentDay(in: selectedDays))
        save()
        fetchData()
        resetHabitEntry()
    }
    
    func deleteAll() {
        for habit in habits {
            dataController.container.viewContext.delete(habit)
        }
        save()
        fetchData()
    }
    
    func deleteItems(at offsets:IndexSet) {
        for offset in offsets {
            let habit = habits[offset]
            dataController.container.viewContext.delete(habit)
        }
        save()
        fetchData()
    }
    
    func deleteHabit(habit: Habit) {
        guard let habitID = habit.objectID.isTemporaryID ? nil : habit.objectID else {
            return
        }
        
        dataController.container.viewContext.perform { [self] in
            do {
                if let habitToDelete = try self.dataController.container.viewContext.existingObject(with: habitID) as? Habit {
                    dataController.container.viewContext.delete(habitToDelete)
                    self.save()
                    self.fetchData()
                } else {
                }
            } catch {
            }
        }
    }
    
    func saveNewHabit() {
        print("adding new Habit")
        if textIsAppropiate() {
            addData()
        }
    }
    
    func textIsAppropiate() -> Bool {
        if newHabitTitle.count < 3 {
            alertTitle = "Der Titel sollte mindestens eine Länge von 3 Zeichen haben!"
            showAlert.toggle()
            return false
        }
        return true
    }
    
    func resetHabitEntry() {
        newHabitTitle = ""
        newHabitDuration = 0
        showAlert = false
        selectedDays.removeAll()
    }
    
    func save() {
        do {
            try dataController.container.viewContext.save()
        } catch {
            print("HabitVM - speichern failed")
        }
    }
    
    func countUpHabbitDuration(habit: Habit) {
        if(habit.current < habit.goal) {
            habit.current += 1
            habit.currentInMonth += 1
            habit.currentInYear += 1
            
        }
        habit.progress = Double(habit.current) / Double(habit.goal)
        
        habit.lastHabitDone = Date()
        
        
        save()
        fetchData()
        
    }
    
    func showOnlyUncheckedHabits(habitsToday: [Habit]) -> [Habit] {
        let currentDate = Date()
        var dailyHabitList = [Habit]()
        
        for habitToday in habitsToday {
            if(!dateService.areDatesOnSameDay(currentDate, habitToday.lastHabitDone ?? dateService.previousDay(from: Date()))) {
                dailyHabitList.append(habitToday)
            }
        }
        
        return dailyHabitList
    }
    
    
    func setEditHabit(habit: Habit) {
        editHabitTitle = habit.title ?? "Unknown"
        selectedDays = habit.weekdays ?? []
        
    }
}
