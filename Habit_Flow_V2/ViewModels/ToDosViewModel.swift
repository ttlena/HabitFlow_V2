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
    @Published var toDos: [ToDo] = []
//    @Published var toDosItemModels: [ItemModel] = []
    
    init() {
        fetchData()
    }
    
    func fetchData() {
        let request = NSFetchRequest<ToDo>(entityName: "ToDo")
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        do {
            toDos = try dataController.container.viewContext.fetch(request)
        } catch {
            print("CoreData Error")
        }
    }
    
    func addItem(title: String) {
        let newToDo = ToDo(context: dataController.container.viewContext)
        newToDo.id = UUID()
        newToDo.isCompleted = false
        newToDo.title = title
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
    
    func deleteItem(obj: ToDo) {
        print("delete ToDo")
        if let item = toDos.firstIndex(where: {$0.id == obj.id}) {
            dataController.container.viewContext.delete(toDos.remove(at: item))
        }
        save()
        fetchData()
    }
    
    func updateItem(obj: ToDo) {
        print("update ToDo")
        if let item = toDos.first(where: {$0.id == obj.id}) {
            item.isCompleted = true
            save()
            fetchData()
        }
    }
    
    func moveItem(from: IndexSet, to: Int) {
        toDos.move(fromOffsets: from, toOffset: to)
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
