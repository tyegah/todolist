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

extension TodoItem {
    static func find(in context: NSManagedObjectContext, where predicate: NSPredicate? = nil) throws -> [TodoItem] {
        let request = NSFetchRequest<TodoItem>(entityName: "TodoItem")
        request.predicate = predicate
        request.returnsObjectsAsFaults = false
        return try context.fetch(request)
    }
    
    var local: LocalTodoItem {
        LocalTodoItem(id: id,
                      title: title,
                      desc: desc,
                      completed: completed,
                      removed: removed,
                      dueDate: dueDate)
    }
}
