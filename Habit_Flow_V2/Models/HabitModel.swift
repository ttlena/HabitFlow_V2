//
//  HabitModel.swift
//  Habit_Flow_V2
//
//  Created by Marc Bachmann on 06.07.23.
//

import Foundation

struct HabitModel: Identifiable, Codable {
    let id: String
    let title: String
    let duration: String
    let isCompleted: Bool
    
    init(id: String = UUID().uuidString, title: String, duration: String, isCompleted: Bool) {
        self.id = id
        self.title = title
        self.duration = duration
        self.isCompleted = isCompleted
    }
    
    func updateCompletion() -> HabitModel {
        return HabitModel(id: id, title: title, duration: duration, isCompleted: !isCompleted)
    }
}
