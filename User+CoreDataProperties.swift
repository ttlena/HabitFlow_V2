//
//  User+CoreDataProperties.swift
//  Habit_Flow_V2
//
//  Created by Marc Bachmann on 04.08.23.
//
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var birthday: Date?
    @NSManaged public var firstStart: Bool
    @NSManaged public var id: UUID?
    @NSManaged public var name: UUID?
    @NSManaged public var profilePicture: Data?
    @NSManaged public var userName: String?
    @NSManaged public var appointments: NSSet?
    @NSManaged public var datekeeper: DateKeeper?
    @NSManaged public var habits: NSSet?
    @NSManaged public var todos: NSSet?

}

// MARK: Generated accessors for appointments
extension User {

    @objc(addAppointmentsObject:)
    @NSManaged public func addToAppointments(_ value: Appointment)

    @objc(removeAppointmentsObject:)
    @NSManaged public func removeFromAppointments(_ value: Appointment)

    @objc(addAppointments:)
    @NSManaged public func addToAppointments(_ values: NSSet)

    @objc(removeAppointments:)
    @NSManaged public func removeFromAppointments(_ values: NSSet)

}

// MARK: Generated accessors for habits
extension User {

    @objc(addHabitsObject:)
    @NSManaged public func addToHabits(_ value: Habit)

    @objc(removeHabitsObject:)
    @NSManaged public func removeFromHabits(_ value: Habit)

    @objc(addHabits:)
    @NSManaged public func addToHabits(_ values: NSSet)

    @objc(removeHabits:)
    @NSManaged public func removeFromHabits(_ values: NSSet)

}

// MARK: Generated accessors for todos
extension User {

    @objc(addTodosObject:)
    @NSManaged public func addToTodos(_ value: ToDo)

    @objc(removeTodosObject:)
    @NSManaged public func removeFromTodos(_ value: ToDo)

    @objc(addTodos:)
    @NSManaged public func addToTodos(_ values: NSSet)

    @objc(removeTodos:)
    @NSManaged public func removeFromTodos(_ values: NSSet)

}

extension User : Identifiable {

}
