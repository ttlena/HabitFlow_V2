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
    Page(name: "Wilkommen bei Habit Flow 1", description: "Description Test", imageUrl: "Success", tag: 0),
    Page(name: "Wilkommen bei Habit Flow 2", description: "Description Test", imageUrl: "Success", tag: 1),
    Page(name: "Wilkommen bei Habit Flow 3", description: "Description Test", imageUrl: "Success", tag: 2)]
}
