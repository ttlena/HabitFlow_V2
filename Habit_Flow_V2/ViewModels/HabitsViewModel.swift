//
//  HabitsViewModel.swift
//  Habit_Flow_V2
//
//  Created by Marc Bachmann on 06.07.23.
//

import Foundation
import CoreData

class HabitsViewModel: ObservableObject {
    private var dataController = DataController(name: "Model")
    @Published var habits = [Habit]()
    
    init() {
        fetchData()
    }
    
    func fetchData() {
        let request = NSFetchRequest<Habit>(entityName: "Habit")
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
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
    
    func deleteItems(at offsets:IndexSet) {
        for offset in offsets {
            let Habit = habits[offset]
            dataController.container.viewContext.delete(Habit)
        }
        save()
        fetchData()
    }
    
    func updateItem(obj: ToDo) {
        print("update")
        if let item = habits.firstIndex(where: {$0.id == obj.id}) {
            dataController.container.viewContext.delete(habits.remove(at: item))
        }
        save()
        fetchData()
    }
    
    func save() {
        do {
            try dataController.container.viewContext.save()
            print("saved")
        } catch {
            print("speichern failed")
        }
    }
}
