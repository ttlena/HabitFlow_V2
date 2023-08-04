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
    
    private let notificationCenter = NotificationCenter.default
    
    
    
    init() {
        let nextWeekDate = Calendar.current.date(byAdding: .weekOfYear, value: 1, to: Date())!
        
        
        fetchData()
        //deleteAll()
    }
    
    func fetchData() {
        let request = NSFetchRequest<Habit>(entityName: "Habit")
        //        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        do {
            habits = try dataController.container.viewContext.fetch(request)
        } catch {
            print("CoreData Error")
        }
    }
    
    func getHabitsBasedOnWeekday(habits: [Habit], pickedDate: Date) -> [Habit] {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "E"
        dateFormatter.locale = Locale(identifier: "de_DE")
        var weekdayHabits: [Habit] = []
        
        for habit in habits {
            if let weekdays = habit.weekdays {
                for weekday in weekdays {
                    if weekday == getWeekDayFromData(from: pickedDate) {
                        weekdayHabits.append(habit)
                    }
                }
            }
        }
        return weekdayHabits
    }
    
    func getWeekDayFromData(from date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "E"
        dateFormatter.locale = Locale(identifier: "de_DE")
        return String(dateFormatter.string(from: date).lowercased().dropLast())
    }
    
    func currentMonth() -> Int {
        let calendar = Calendar.current
        let currentDate = Date()
        let currentMonth = calendar.component(.month, from: currentDate)
        return currentMonth
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
        // Hole den aktuellen Kalender
        let calendar = Calendar.current
        
        // Hole das aktuelle Datum
        let currentDate = Date()
        
        // Hole das Jahr und den Monat aus dem aktuellen Datum
        let year = calendar.component(.year, from: currentDate)
        let month = calendar.component(.month, from: currentDate)
        
        
        // Erstelle ein DateComponents-Objekt mit dem ersten Tag des aktuellen Monats
        var firstDateComponents = DateComponents()
        firstDateComponents.year = year
        firstDateComponents.month = month
        firstDateComponents.day = 1
        let firstDate = calendar.date(from: firstDateComponents)!
        
        // Erstelle ein DateComponents-Objekt mit dem ersten Tag des nächsten Monats
        var nextMonthComponents = DateComponents()
        nextMonthComponents.month = 1
        let nextMonthDate = calendar.date(byAdding: nextMonthComponents, to: firstDate)!
        
        // Schleife über alle Tage des aktuellen Monats
        var currentDateInLoop = firstDate
        var occurrences = 0
        
        while currentDateInLoop < nextMonthDate {
            // Hole den Wochentag des aktuellen Datums (z.B. "mo", "di" usw.)
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "E"
            dateFormatter.locale = Locale(identifier: "de_DE")
            let weekdayString = dateFormatter.string(from: currentDateInLoop).lowercased()
            
            // Prüfe, ob der Wochentag in der Eingabe enthalten ist
            if weekdays.contains(String(weekdayString.dropLast())) {
                occurrences += 1
            }
            
            // Gehe zum nächsten Tag
            currentDateInLoop = calendar.date(byAdding: .day, value: 1, to: currentDateInLoop)!
        }
        
        return occurrences
    }
    
    func occurrencesOfWeekdaysInCurrentMonth_dependentOnCurrentDay(in weekdays: [String]) -> Int {
        // Hole den aktuellen Kalender
        let calendar = Calendar.current
        
        // Hole das aktuelle Datum
        var currentDate =  Date()
        
        
        // Hole das Jahr und den Monat aus dem aktuellen Datum
        let year = calendar.component(.year, from: currentDate)
        let month = calendar.component(.month, from: currentDate)
        
        // Erstelle ein DateComponents-Objekt mit dem ersten Tag des aktuellen Monats
        var firstDateComponents = DateComponents()
        firstDateComponents.year = year
        firstDateComponents.month = month
        firstDateComponents.day = 2
        let firstDate = calendar.date(from: firstDateComponents)!
        
        // Erstelle ein DateComponents-Objekt mit dem ersten Tag des nächsten Monats
        var nextMonthComponents = DateComponents()
        nextMonthComponents.month = 1
        let nextMonthDate =  calendar.date(byAdding: nextMonthComponents, to: firstDate)!
        
        // Schleife über alle Tage des aktuellen Monats
        var currentDateInLoop = currentDate
        var occurrences = 0
        
        while deleteClockComponentFromDate(date: currentDateInLoop) < nextMonthDate {
            // Hole den Wochentag des aktuellen Datums (z.B. "mo", "di" usw.)
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "E"
            dateFormatter.locale = Locale(identifier: "de_DE")
            let weekdayString = dateFormatter.string(from: currentDateInLoop).lowercased()
            
            // Prüfe, ob der Wochentag in der Eingabe enthalten ist
            if weekdays.contains(String(weekdayString.dropLast())) {
                occurrences += 1
            }
            
            // Gehe zum nächsten Tag
            currentDateInLoop = calendar.date(byAdding: .day, value: 1, to: currentDateInLoop)!
        }
        
        return occurrences
    }
    
    
    func occurrencesOfWeekdaysInCurrentWeek_dependOnCurrentDay(in weekdays: [String]) -> Int {
        // Hole den aktuellen Kalender
        let calendar = Calendar.current
        
        // Hole das aktuelle Datum
        let currentDate = Date()
        
        // Ermittle den Start- und Endtag der aktuellen Woche
        var startDate: Date = currentDate
        var interval: TimeInterval = 0
        _ = calendar.dateInterval(of: .weekOfYear, start: &startDate, interval: &interval, for: currentDate)
        let endDate = startDate.addingTimeInterval(interval - 1)
        
        // Schleife über alle Tage der aktuellen Woche
        var currentDateInLoop = currentDate
        var occurrences = 0
        
        while currentDateInLoop < endDate {
            // Hole den Wochentag des aktuellen Datums (z.B. "mo", "di" usw.)
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "E"
            dateFormatter.locale = Locale(identifier: "de_DE")
            let weekdayString = dateFormatter.string(from: currentDateInLoop).lowercased()
            
            // Prüfe, ob der Wochentag in der Eingabe enthalten ist
            if weekdays.contains(String(weekdayString.dropLast())) {
                occurrences += 1
            }
            
            // Gehe zum nächsten Tag
            currentDateInLoop = calendar.date(byAdding: .day, value: 1, to: currentDateInLoop)!
        }
        
        return occurrences
    }
    
    
    func occurrencesOfWeekdaysInCurrentYear(in weekdays: [String]) -> Int {
        // Hole den aktuellen Kalender
        let calendar = Calendar.current
        
        // Hole das aktuelle Datum
        let currentDate = Date()
        
        // Hole das Jahr aus dem aktuellen Datum
        let year = calendar.component(.year, from: currentDate)
        
        // Erstelle ein DateComponents-Objekt mit dem ersten Tag des aktuellen Jahres
        var firstDateComponents = DateComponents()
        firstDateComponents.year = year
        firstDateComponents.month = 1
        firstDateComponents.day = 2
        let firstDateOfYear = calendar.date(from: firstDateComponents)!
        
        // Erstelle ein DateComponents-Objekt mit dem ersten Tag des nächsten Jahres
        var nextYearComponents = DateComponents()
        nextYearComponents.year = 1
        let nextYearDate = calendar.date(byAdding: nextYearComponents, to: firstDateOfYear)!
        
        // Schleife über alle Tage des aktuellen Jahres
        var currentDateInLoop = firstDateOfYear
        var occurrences = 0
        
        while deleteClockComponentFromDate(date: currentDateInLoop) < nextYearDate {
            // Hole den Wochentag des aktuellen Datums (z.B. "mo", "di" usw.)
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "E"
            dateFormatter.locale = Locale(identifier: "de_DE")
            let weekdayString = dateFormatter.string(from: currentDateInLoop).lowercased()
            
            // Prüfe, ob der Wochentag in der Eingabe enthalten ist
            if weekdays.contains(String(weekdayString.dropLast())) {
                occurrences += 1
            }
            
            // Gehe zum nächsten Tag
            currentDateInLoop = calendar.date(byAdding: .day, value: 1, to: currentDateInLoop)!
        }
        
        return occurrences
    }
    
    func occurrencesOfWeekdaysInCurrentYear_dependOnCurrentDay(in weekdays: [String]) -> Int {
        // Hole den aktuellen Kalender
        let calendar = Calendar.current
        
        // Hole das aktuelle Datum
        let currentDate = Date()
        
        // Hole das Jahr aus dem aktuellen Datum
        let year = calendar.component(.year, from: currentDate)
        
        // Erstelle ein DateComponents-Objekt mit dem ersten Tag des aktuellen Jahres
        var firstDateComponents = DateComponents()
        firstDateComponents.year = year
        firstDateComponents.month = 1
        firstDateComponents.day = 2
        let firstDateOfYear = calendar.date(from: firstDateComponents)!
        
        // Erstelle ein DateComponents-Objekt mit dem ersten Tag des nächsten Jahres
        var nextYearComponents = DateComponents()
        nextYearComponents.year = 1
        let nextYearDate = calendar.date(byAdding: nextYearComponents, to: firstDateOfYear)!
        
        // Schleife über alle Tage des aktuellen Jahres
        var currentDateInLoop = currentDate
        var occurrences = 0
        
        while deleteClockComponentFromDate(date: currentDateInLoop) < nextYearDate {
            // Hole den Wochentag des aktuellen Datums (z.B. "mo", "di" usw.)
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "E"
            dateFormatter.locale = Locale(identifier: "de_DE")
            let weekdayString = dateFormatter.string(from: currentDateInLoop).lowercased()
            
            // Prüfe, ob der Wochentag in der Eingabe enthalten ist
            if weekdays.contains(String(weekdayString.dropLast())) {
                occurrences += 1
            }
            
            // Gehe zum nächsten Tag
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
        
        // Setze die Uhrzeit auf 0:00 Uhr (Mitternacht)
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
    
    
    
    //habitDuration auf monatstage rechnen
    //habitDuration auf Jahrestage rechnen
    //Jahre und monate konservieren
    //Gesamt ?
    
    
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
        // if let unpackedNewHabitDuration = newHabitDuration {
        newHabit.goal = Int16(occurrencesOfWeekdaysInCurrentWeek_dependOnCurrentDay(in: selectedDays))//unpackedNewHabitDuration
        print(newHabit.goal)
        //}
        newHabit.goalInMonth = Int16(occurrencesOfWeekdaysInCurrentMonth_dependentOnCurrentDay(in: selectedDays))
        print(newHabit.goalInMonth)
        newHabit.goalInYear = Int16(occurrencesOfWeekdaysInCurrentYear_dependOnCurrentDay(in: selectedDays))
        
        save()
        fetchData()
    }
    
    //    func addRandomHabit() {
    //        let task = ["clean", "wash", "study", "workout"]
    //        let chosenTask = task.randomElement()!
    //        let habit = Habit(context: dataController.container.viewContext)
    //        habit.id = UUID()
    //        habit.icon = "Waterdrop"
    //        habit.title = "\(chosenTask)"
    //        habit.current = Int16.random(in: 0...10)
    //        habit.goal = Int16.random(in: 5...100)
    //        habit.progress = Double(habit.current) / Double(habit.goal)
    //        save()
    //        fetchData()
    //    }
    
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
    }
    
    func save() {
        try? dataController.container.viewContext.save()
    }
    
    func countUpHabbitDuration(habit: Habit) {
        if(habit.current < habit.goal) {
            habit.current += 1
            habit.currentInMonth += 1
            habit.currentInYear += 1
            
        }

        habit.progress = Double(habit.current) / Double(habit.goal)
        
        /*if (habit.current == habit.goal) {
         //addCurrentToCurrentInMonth(habit: habit)
         habit.current = 0
         }*/
        
        
        save()
        fetchData()
       // plusButtonClicked = false
    }
    
    func setCurrentTo0(habit: Habit) {
        if (habit.current == habit.goal) {
            habit.current = 0
            habit.progress = Double(habit.current) / Double(habit.goal)
            habit.goal = Int16(habit.weekdays?.count ?? 0)
            
        }
        if (habit.currentInMonth == habit.goalInMonth) {
            habit.currentInMonth = 0
            habit.goalInMonth = Int16(occurrencesOfWeekdaysInCurrentMonth(in: habit.weekdays ?? []))

            
        }
        
        if(habit.currentInYear == habit.goalInYear) {
            habit.currentInYear = 0
            habit.goalInYear = Int16(occurrencesOfWeekdaysInCurrentYear(in: habit.weekdays ?? []))
        }
        
        save()
        fetchData()
       // plusButtonClicked = false
    }
    
    func setEditHabit(habit: Habit) {
        editHabitTitle = habit.title ?? "Unknown"
        selectedDays = habit.weekdays ?? []
    
    }
    
    /*
     //    private let notificationCenter = NotificationCenter.default
     
     /*init() {
      // Observer registrieren, um auf Datumänderungen zu reagieren
      notificationCenter.addObserver(self, selector: #selector(handleDateChangeNotification(_:)), name: UIApplication.significantTimeChangeNotification, object: nil)
      }*/
     
     deinit {
     // Observer entfernen, um Speicherlecks zu vermeiden
     notificationCenter.removeObserver(self, name: UIApplication.significantTimeChangeNotification, object: nil)
     }
     
     // Funktion, die prüft, ob eine neue Woche begonnen hat
     func isNewWeek() -> Bool {
     let calendar = Calendar.current
     let today = Date()
     let lastWeek = calendar.date(byAdding: .weekOfYear, value: -1, to: today)!
     
     let todayComponents = calendar.dateComponents([.weekOfYear], from: today)
     let lastWeekComponents = calendar.dateComponents([.weekOfYear], from: lastWeek)
     
     // Wenn die Kalenderwoche der letzten Woche kleiner ist als die aktuelle Kalenderwoche, ist eine neue Woche gestartet.
     return todayComponents.weekOfYear! > lastWeekComponents.weekOfYear!    }
     // Funktion, die bei einer Datumänderung aufgerufen wird
     @objc private func handleDateChangeNotification(_ notification: Notification) {
     if isNewWeek() {
     print("Eine neue Woche hat begonnen. Führe bestimmte Aktionen aus.")
     // Hier kannst du die gewünschten Aktionen einfügen, die ausgeführt werden sollen, wenn eine neue Woche startet.
     }
     }
     
     
     func setSimulationDate(date: Date) {
     let calendar = Calendar.current
     let components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
     let newDate = calendar.date(from: components)!
     
     if #available(iOS 14.0, *) {
     let selector = NSSelectorFromString("_setManualSystemDate:")
     if ProcessInfo.processInfo.responds(to: selector) {
     ProcessInfo.processInfo.perform(selector, with: newDate)
     }
     }
     }
     
     }
     
     /*
      class WeekChangeObserver {
      init() {
      NotificationCenter.default.addObserver(self, selector: #selector(weekDidChange), name: .NSCalendarDayChanged, object: nil)
      }
      
      @objc private func weekDidChange() {
      // Diese Methode wird aufgerufen, wenn eine neue Woche beginnt
      print("Neue Woche hat begonnen!")
      // Führe hier die gewünschten Aktionen für den Wochenwechsel aus
      }
      }
      */
     import UIKit
     
     
     class MyViewController: UIViewController {
     
     override func viewDidLoad() {
     super.viewDidLoad()
     
     // Observer registrieren, um auf Datumänderungen zu reagieren
     NotificationCenter.default.addObserver(self, selector: #selector(handleDateChangeNotification(_:)), name: UIApplication.significantTimeChangeNotification, object: nil)
     }
     
     // Funktion, die prüft, ob eine neue Woche begonnen hat
     func isNewWeek() -> Bool {
     let calendar = Calendar.current
     let today = Date()
     let lastWeek = calendar.date(byAdding: .weekOfYear, value: -1, to: today)!
     
     let todayComponents = calendar.dateComponents([.weekOfYear], from: today)
     let lastWeekComponents = calendar.dateComponents([.weekOfYear], from: lastWeek)
     
     // Wenn die Kalenderwoche der letzten Woche kleiner ist als die aktuelle Kalenderwoche, ist eine neue Woche gestartet.
     return todayComponents.weekOfYear! > lastWeekComponents.weekOfYear!
     
     }
     
     // Funktion, die bei einer Datumänderung aufgerufen wird
     @objc func handleDateChangeNotification(_ notification: Notification) {
     if isNewWeek() {
     print("Eine neue Woche hat begonnen. Führe bestimmte Aktionen aus.")
     // Hier kannst du die gewünschten Aktionen einfügen, die ausgeführt werden sollen, wenn eine neue Woche startet.
     }
     }
     
     deinit {
     // Observer entfernen, um Speicherlecks zu vermeiden
     NotificationCenter.default.removeObserver(self, name: UIApplication.significantTimeChangeNotification, object: nil)
     }
     }
     */
}
