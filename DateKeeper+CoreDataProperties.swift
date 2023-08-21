//
//  DateKeeper+CoreDataProperties.swift
//  Habit_Flow_V2
//
//  Created by Lena Ngo on 04.08.23.
//
//

import Foundation
import CoreData


extension DateKeeper {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DateKeeper> {
        return NSFetchRequest<DateKeeper>(entityName: "DateKeeper")
    }

    @NSManaged public var lastWeek: Int64
    @NSManaged public var nextWeekStarted: Bool
    @NSManaged public var currentWeek: Int64
    @NSManaged public var id: UUID?
    @NSManaged public var origin: User?

}

extension DateKeeper : Identifiable {

}
