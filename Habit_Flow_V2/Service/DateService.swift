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
//    private var data:[DateKeeper] = []
    @Published var dateKeeper:DateKeeper = DateKeeper()
    
    init() {
        fetchData()
        print(dateKeeper)
    }
    
    func fetchData() {
        let request = NSFetchRequest<DateKeeper>(entityName: "DateKeeper")
        request.fetchLimit = 1
        do {
            if let fetchDateKeeper = try dataController.container.viewContext.fetch(request).first {
                dateKeeper = fetchDateKeeper
                return
            }
        } catch {
            print("CoreData error")
        }
        createHelper()
    }
    
    func save() {
        do {
            try dataController.container.viewContext.save()
            //print("saved!")
        } catch {
            print("speichern failed")
        }
    }
    
    func createHelper() {
        print("---------- create Helper!")
        let dateKeeper = DateKeeper(context:dataController.container.viewContext)
        dateKeeper.id = UUID()
        dateKeeper.currentWeek = Int64(getCurrentWeek())
        dateKeeper.lastWeek = dateKeeper.currentWeek - 1
        save()
        fetchData()
    }
    
    func getCurrentWeek() -> Int{
        let calendar = Calendar(identifier: .gregorian)
        return calendar.component(.weekOfYear, from: Date())
    }
    
    func checkIfNewWeek() -> Bool {
        let date = Date()
        let calendar = Calendar.current
        let components = calendar.dateComponents([.weekday], from: date)
        let dayOfWeek = components.weekday
        print("Weekday \(dayOfWeek!)")
        print("nextWeekStarted \(dateKeeper.nextWeekStarted)")
        if dateKeeper.currentWeek != getCurrentWeek(){
            dateKeeper.lastWeek = dateKeeper.currentWeek
            dateKeeper.currentWeek = Int64(getCurrentWeek())
            dateKeeper.nextWeekStarted = true
        } else {
            dateKeeper.nextWeekStarted = false
        }
        save()
        fetchData()
        return dateKeeper.nextWeekStarted
    }
}

