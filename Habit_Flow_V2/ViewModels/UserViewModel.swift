//
//  UserViewModel.swift
//  Habit_Flow_V2
//
//  Created by Marc Bachmann on 04.08.23.
//

import Foundation
import CoreData

class UserViewModel: ObservableObject {
    @Published var user: User = User()
    
    init() {
        fetchData()
    }
    
    private var dataController = DataController(name: "Model")
    
    func fetchData() {
        let request = NSFetchRequest<User>(entityName: "User")
        request.fetchLimit = 1
        do {
            if let fetchUser = try dataController.container.viewContext.fetch(request).first {
                user = fetchUser
                return
            }
        } catch {
            print("CoreData error")
        }
        createUser()
    }
    
    func createUser() {
        let user = User(context: dataController.container.viewContext)
        user.id = UUID()
        user.firstStart = true
        save()
        fetchData()
    }
    
    func save() {
        do {
            try dataController.container.viewContext.save()
            //print("saved!")
        } catch {
            print("speichern failed")
        }
    }
    
    func toggleFirstStarted() {
        user.firstStart = false
        save()
        fetchData()
    }
}

