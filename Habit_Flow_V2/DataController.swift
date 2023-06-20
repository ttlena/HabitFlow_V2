//
//  DataController.swift
//  Habit_Flow_V2
//
//  Created by Lena Ngo on 19.06.23.
//

import Foundation
import CoreData

class DataController: ObservableObject {
    static let shared = DataController(name: "Model")
    var container: NSPersistentContainer
    
    init(name:String) {
        container = NSPersistentContainer(name: name)
        container.loadPersistentStores { _, error in
            if let error = error {
                print("CoreData error: \(error.localizedDescription)")
            }
            
        }
    }
}
