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
    @Published var habits = [Habit]()
    
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
    
    func addData(name: String) {
        let newHabit = Habit(context: dataController.container.viewContext)
        newHabit.id = UUID()
        newHabit.name = name
        
        save()
        fetchData()
    }
    
    func addRandomHabit() {
        let task = ["clean", "wash", "study", "workout"]
        let chosenTask = task.randomElement()!
        let habit = Habit(context: dataController.container.viewContext)
        habit.id = UUID()
        habit.icon = "Waterdrop"
        habit.name = "\(chosenTask)"
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
        
    func save() {
        try? dataController.container.viewContext.save()
    }
}
