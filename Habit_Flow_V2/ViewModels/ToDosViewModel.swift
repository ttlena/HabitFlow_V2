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
    @Published var toDosToday: [ToDo] = []
   // @Published var toDosItemModels: [ItemModel] = []
    
    let notificationManager = NotificationManager()
    
    
    init() {
        fetchData()
        toDosToday = updateFilteredToDos(pickedDate: Date.now)
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
    
    func addItem(title: String, date: Date) {
        let newToDo = ToDo(context: dataController.container.viewContext)
        newToDo.id = UUID()
        newToDo.isCompleted = false
        newToDo.title = title
        newToDo.date = date
        //print(newToDo)
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
        //print("delete ToDo")
        if let item = toDos.firstIndex(where: {$0.id == obj.id}) {
            dataController.container.viewContext.delete(toDos.remove(at: item))
        }
        save()
        fetchData()
    }
    
    func updateItem(obj: ToDo) {
        //print("update ToDo")
        if let item = toDos.first(where: {$0.id == obj.id}) {
            item.isCompleted.toggle()
            save()
            fetchData()
        }
    }
    
    func shiftToNextDay (obj: ToDo) {
        let calendar = Calendar.current
        let nextDay = calendar.date(byAdding: .day, value: 1, to: obj.date ?? Date())!
        obj.date = nextDay
        if(calendar.component(.day, from: nextDay) == calendar.component(.day, from: Date.now)) {
            toDosToday = updateFilteredToDos(pickedDate: Date.now)
        }
        if(obj.isCompleted){
            obj.isCompleted.toggle()
        }
        save()
        fetchData()
    }
    
    func moveItem(from: IndexSet, to: Int) {
        toDos.move(fromOffsets: from, toOffset: to)
    }
    
    func save() {
        do {
            try dataController.container.viewContext.save()
            //print("saved!")
        } catch {
            print("speichern failed")
        }
    }
    
    func toDosTodayAllCompleted() -> Bool {
        for todo in toDosToday {
            if !todo.isCompleted {
                return false
            }
        }
        return true
    }
    
    func updateFilteredToDos(pickedDate : Date) -> [ToDo] {
        let calendar = Calendar.current
        
        let pickedDay = calendar.component(.day, from: pickedDate)
        let filteredToDos = toDos.filter({
            guard let date = $0.date else {
                return  false
            }
            
            return calendar.component(.day, from: date) == pickedDay})
        //wenn es nicht erledigte ToDos gibt, wird eine Notification geplant
        if(filteredToDos.filter{$0.isCompleted == false}.count > 0) {
            notificationManager.toDoNoification(numberOfUndoneToDos: filteredToDos.filter{$0.isCompleted == false}.count)
        //ändert sich die Liste in der zwischenzeit, werden vorher geplante Notifications gelöscht
        }else {
            notificationManager.removeNotification(with: "habitFlow.toDoNotification")
        }
        return filteredToDos
        
    }
}
