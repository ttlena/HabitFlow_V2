//
//  Appointment+CoreDataProperties.swift
//  Habit_Flow_V2
//
//  Created by Lena Ngo on 19.06.23.
//
//

import Foundation
import CoreData


extension Appointment {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Appointment> {
        return NSFetchRequest<Appointment>(entityName: "Appointment")
    }

    @NSManaged public var date: Date?
    @NSManaged public var id: UUID?
    @NSManaged public var title: String?
    @NSManaged public var origin: User?
    @NSManaged public var endDate: Date?


}

extension Appointment : Identifiable {

}
