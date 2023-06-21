//
//  ToDoViewModel.swift
//  Habit_Flow_V2
//
//  Created by Lena Ngo on 19.06.23.
//

import Foundation
import CoreData

class ToDosViewModel:ObservableObject {
    private var dataController = DataController(name: "Model")
    @Published var toDos = [ToDo]()
    
    init() {
        fetchData()
    }
    
    func fetchData() {
        let request = NSFetchRequest<ToDo>(entityName: "ToDo")
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        do {
            toDos = try dataController.container.viewContext.fetch(request)
        } catch {
            print("CoreData Error")
        }
    }
    
    func addData(name: String) {
        let newToDo = ToDo(context: dataController.container.viewContext)
        newToDo.id = UUID()
        newToDo.name = name
        save()
        fetchData()
    }
    
    func deleteItems(at offsets:IndexSet) {
        for offset in offsets {
            let toDo = toDos[offset]
            dataController.container.viewContext.delete(toDo)
        }
        save()
        fetchData()
    }
    
    func updateItem(obj: ToDo) {
        print("update")
        if let item = toDos.firstIndex(where: {$0.id == obj.id}) {
            dataController.container.viewContext.delete(toDos.remove(at: item))
        }
        save()
        fetchData()
    }
    
    func save() {
        do {
            try dataController.container.viewContext.save()
            print("saved!")
        } catch {
            print("speichern failed")
        }
    }
}
