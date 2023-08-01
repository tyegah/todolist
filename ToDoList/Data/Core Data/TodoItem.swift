//
//  TodoItem.swift
//  ToDoList
//
//  Created by Ty Septiani on 01/08/23.
//

import CoreData

@objc(TodoItem)
class TodoItem: NSManagedObject {
    @NSManaged var id: UUID
    @NSManaged var title: String
    @NSManaged var desc: String?
    @NSManaged var completed: Bool
    @NSManaged var removed: Bool
    @NSManaged var dueDate: Date?
}

