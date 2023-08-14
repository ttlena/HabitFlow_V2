//
//  Helper+CoreDataProperties.swift
//  Habit_Flow_V2
//
//  Created by Lena Ngo on 03.08.23.
//
//

import Foundation
import CoreData


extension Helper {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Helper> {
        return NSFetchRequest<Helper>(entityName: "Helper")
    }

    @NSManaged public var lastWeek: Date?
    @NSManaged public var nextWeekStarted: Bool
    @NSManaged public var origin: User?

}

extension Helper : Identifiable {

}
