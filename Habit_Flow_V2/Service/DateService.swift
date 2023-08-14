//
//  DateService.swift
//  Habit_Flow_V2
//
//  Created by Lena Ngo on 03.08.23.
//

import Foundation
import CoreData

class DateService: ObservableObject {
    private var dataController = DataController(name: "Model")
    private var data:[Helper] = []
    @Published var dateHelper:Helper = Helper()
    init() {
        fetchData()
        print(data)
    }
    
    func fetchData() {
        let request = NSFetchRequest<Helper>(entityName: "Helper")
        request.fetchLimit = 1
        do {
            data = try dataController.container.viewContext.fetch(request)
        } catch {
            print("CoreData error")
        }
        if data.isEmpty {
            dateHelper = createHelper()
        } else {
            dateHelper = data.first ?? createHelper()
        }
    }
    
    func save() {
        do {
            try dataController.container.viewContext.save()
            //print("saved!")
        } catch {
            print("speichern failed")
        }
    }
    
    func createHelper() -> Helper {
        print("---------- create Helper!")
        let newHelper = Helper(context:dataController.container.viewContext)
        newHelper.nextWeekStarted = false
        save()
//        fetchData()
        return newHelper
    }
    
    func checkIfNewWeek() -> Bool {
        let date = Date()
        let calendar = Calendar.current
        let components = calendar.dateComponents([.weekday], from: date)
        let dayOfWeek = components.weekday
        print("Weekday \(dayOfWeek!)")
        print("nextWeekStarted \(dateHelper.nextWeekStarted)")
        if !dateHelper.nextWeekStarted && dayOfWeek == 2 {
            dateHelper.nextWeekStarted = true
            if let item = data.first(where: {$0.id == dateHelper.id}) {
                item.nextWeekStarted = true
            }
        } else {
            dateHelper.nextWeekStarted = false
            if let item = data.first(where: {$0.id == dateHelper.id}) {
                item.nextWeekStarted = false
            }
        }
        save()
        fetchData()
        return dateHelper.nextWeekStarted
    }
}

