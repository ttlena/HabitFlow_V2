//
//  PageModel.swift
//  Habit_Flow_V2
//
//  Created by Marc Bachmann on 04.08.23.
//

import Foundation

struct Page: Identifiable, Equatable {
    let id = UUID()
    var name: String
    var description: String
    var imageUrl: String
    var tag: Int
    
    static var samplePage = Page(name: "Title Example", description: "Sample Description for Example", imageUrl: "Success", tag: 0)
    
    static var samplePages: [Page] = [
    Page(name: "Wilkommen bei Habit Flow", description: "Description Test", imageUrl: "Success", tag: 0),
    Page(name: "Alles unter einem Hut", description: "Habit Flow fasst einen Kalender, deine ToDo Liste sowie deine Habits in einer App zusammen.", imageUrl: "Success", tag: 1),
    Page(name: "Benachrichtigungen", description: "Lasse Benachrichtigungen zu, damit du keine Termine verpasst und deine ToDo's und Habits jeden Tag erledigst", imageUrl: "Notification", tag: 2),
    Page(name: "Los geht's!", description: "Du bist nun startklar.", imageUrl: "Done", tag: 3)]
}
