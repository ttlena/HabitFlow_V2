//
//  Habit+CoreDataProperties.swift
//  Habit_Flow_V2
//
//  Created by Lena Ngo on 19.06.23.
//
//

import Foundation
import CoreData


extension Habit {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Habit> {
        return NSFetchRequest<Habit>(entityName: "Habit")
    }

    @NSManaged public var current: Int16
    @NSManaged public var goal: Int16
    @NSManaged public var icon: String?
    @NSManaged public var id: UUID?
    @NSManaged public var title: String?
    @NSManaged public var progress: Double
    @NSManaged public var origin: User?
    @NSManaged public var previousCurrents: [Int: [Int16]]?
    @NSManaged public var previousGoals: [Int: [Int16]]?


}

extension Habit : Identifiable {

}
