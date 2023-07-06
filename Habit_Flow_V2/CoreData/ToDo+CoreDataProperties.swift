//
//  ToDo+CoreDataProperties.swift
//  Habit_Flow_V2
//
//  Created by Lena Ngo on 19.06.23.
//
//

import Foundation
import CoreData


extension ToDo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ToDo> {
        return NSFetchRequest<ToDo>(entityName: "ToDo")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var date: Date?
    @NSManaged public var title: String?
    @NSManaged public var isCompleted: Bool
    @NSManaged public var origin: User?

}

extension ToDo : Identifiable {

}
