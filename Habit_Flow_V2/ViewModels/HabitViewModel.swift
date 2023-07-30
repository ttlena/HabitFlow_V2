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
    @Published var newHabitDuration: Int16 = 0
    @Published var showAlert: Bool = false
    @Published var alertTitle = ""
    
    init() {
        fetchData()
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
    
    func addData() {
        let newHabit = Habit(context: dataController.container.viewContext)
        newHabit.id = UUID()
        newHabit.title = newHabitTitle
        newHabit.goal = newHabitDuration
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
        }
        habit.progress = Double(habit.current) / Double(habit.goal)
        save()
        fetchData()
    }
}
