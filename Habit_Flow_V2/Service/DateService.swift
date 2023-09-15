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
    @Published var dateKeeper:DateKeeper = DateKeeper()
    
    init() {
        fetchData()
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
        print("!!!! neuer DateKeeper")
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
        dateKeeper.currentWeek = Int64(getCurrent(component: Calendar.Component.weekOfYear))
        dateKeeper.lastWeek = dateKeeper.currentWeek - 1
        dateKeeper.currentMonth = Int64(getCurrent(component: Calendar.Component.month))
        dateKeeper.currentYear = Int64(getCurrent(component: Calendar.Component.year))
        save()
        fetchData()
    }
    
//    func getCurrentWeek() -> Int{
//        let calendar = Calendar(identifier: .gregorian)
//        return calendar.component(.weekOfYear, from: Date())
//    }
//    
//    func getCurrentMonth() -> Int {
//        let calendar = Calendar(identifier: .gregorian)
//        return calendar.component(.month, from: Date())
//    }
//    
//    func getCurrentYear() -> Int {
//        let calendar = Calendar(identifier: .gregorian)
//        return calendar.component(.year, from: Date())
//    }
    
    func getCurrent(component : Calendar.Component) -> Int {
        let calendar = Calendar(identifier: .gregorian)
        return calendar.component(component, from: Date())
    }
    
    func checkIfNewWeek() -> Bool {
        let currentWeek = getCurrent(component: Calendar.Component.weekOfYear)
        if dateKeeper.currentWeek != currentWeek {
            dateKeeper.lastWeek = dateKeeper.currentWeek
            dateKeeper.currentWeek = Int64(currentWeek)
            dateKeeper.nextWeekStarted = true
        } else {
            dateKeeper.nextWeekStarted = false
        }
        save()
        fetchData()
        return dateKeeper.nextWeekStarted
    }
    
    func checkIfNewMonth() -> Bool {
        let currentMonth = getCurrent(component: Calendar.Component.month)
        print("------current month \(currentMonth) \(dateKeeper.currentMonth)")
        if dateKeeper.currentMonth != currentMonth {
            dateKeeper.currentMonth = Int64(currentMonth)
            save()
            fetchData()
            return true
        }
        return false
    }
    
    func checkIfNewYear() -> Bool {
        let currentYear = getCurrent(component: Calendar.Component.year)
        if dateKeeper.currentYear != currentYear {
            dateKeeper.currentYear = Int64(currentYear)
            save()
            fetchData()
            return true
        }
        return false
    }
    
}

