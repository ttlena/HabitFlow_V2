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
    
    
    init() {
        fetchData()
        deleteAll()
        
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
    
    func calcMonthGoalStatistics(habit: Habit) -> Int16 {
        //habitMonthGoal = habit.goal * Int16(numberOfDaysInCurrentMonth())
        let goal = habit.goal * Int16(numberOfDaysInCurrentMonth())
        
        return goal
    }
    
    func calcYearGoalStatistics(habit: Habit) -> Int16 {
        return habit.goal * Int16(numberOfDaysInCurrentYear())
    }
    
    func calcMonthProgressStatistic(habit: Habit) -> Int16 {
        /* guard let previousCurrentsFromCurrentMonth = habit.previousCurrents?[currentMonth()] else {
         return 0
         }
         
         var monthProgress: Int16 = 0
         for current in previousCurrentsFromCurrentMonth {
         monthProgress += current
         }
         
         return monthProgress*/
        
        return 0
    }
    
    
    func addCurrentToCurrentInMonth(habit: Habit) {
        /*let currentMonthKey = currentMonth()
         var previousCurrents = habit.previousCurrents
         
         if var previousCurrentsFromCurrentMonth = previousCurrents[currentMonthKey] {
         previousCurrentsFromCurrentMonth.append(habit.current)
         previousCurrents[currentMonthKey] = previousCurrentsFromCurrentMonth
         } else {
         previousCurrents[currentMonthKey] = [habit.current]
         }
         
         habit.previousCurrents = previousCurrents
         
         do {
         try habit.managedObjectContext?.save()
         } catch {
         // Fehlerbehandlung
         }*/
        
        habit.currentInMonth += habit.current
    }
    
    /* func addCurrentToPreviousGoalsList(habit: Habit) {
     let goalMonthKey = currentMonth()
     var previousGoals = habit.previousGoals ?? [:]
     var previousGoalsFromCurrentMonth = previousGoals[goalMonthKey] ?? []
     previousGoalsFromCurrentMonth.append(habit.goal)
     previousGoals[goalMonthKey] = previousGoalsFromCurrentMonth
     habit.previousGoals = previousGoals
     
     do {
     try habit.managedObjectContext?.save()
     } catch {
     // Fehlerbehandlung
     }
     }*/
    
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
        if selectedDays.contains(day) {
            selectedDays.removeAll(where: {$0 == day})
            newHabitDuration = Int16(selectedDays.count)
        } else {
            selectedDays.append(day)
            newHabitDuration = Int16(selectedDays.count)
        }
    }
    
    func addData() {
        let newHabit = Habit(context: dataController.container.viewContext)
        newHabit.id = UUID()
        newHabit.title = newHabitTitle
        if let unpackedNewHabitDuration = newHabitDuration {
            newHabit.goal = unpackedNewHabitDuration
        }
        save()
        fetchData()
    }
    
    func addRandomHabit() {
        let task = ["clean", "wash", "study", "workout"]
        let chosenTask = task.randomElement()!
        let habit = Habit(context: dataController.container.viewContext)
        habit.id = UUID()
        habit.icon = "Waterdrop"
        habit.title = "\(chosenTask)"
        habit.current = Int16.random(in: 0...10)
        habit.goal = Int16.random(in: 5...100)
        habit.progress = Double(habit.current) / Double(habit.goal)
        save()
        fetchData()
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
    }
    
    func setCurrentTo0(habit: Habit) {
        if (habit.current == habit.goal) {
            habit.current = 0
            habit.progress = Double(habit.current) / Double(habit.goal)
        }
        if (habit.currentInMonth == calcMonthGoalStatistics(habit: habit)) {
            habit.currentInMonth = 0
        }
        
        if(habit.currentInYear == calcYearGoalStatistics(habit: habit)) {
            habit.currentInYear = 0
        }
        
        save()
        fetchData()
    }
}
