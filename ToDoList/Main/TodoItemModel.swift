//
//  TodoItemModel.swift
//  ToDoList
//
//  Created by Ty Septiani on 01/08/23.
//

import Foundation

class TodoItemModel {
    var id: UUID
    var title: String
    var desc: String?
    var completed: Bool
    var removed: Bool
    var dueDate: Date?
    
    init(id: UUID,
         title: String,
         desc: String? = nil,
         completed: Bool,
         removed: Bool = false,
         dueDate: Date? = nil) {
        self.id = id
        self.title = title
        self.desc = desc
        self.completed = completed
        self.removed = removed
        self.dueDate = dueDate
    }
    
    static func initFrom(_ local: LocalTodoItem) -> TodoItemModel {
        return TodoItemModel(id: local.id,
                             title: local.title,
                             desc: local.desc,
                             completed: local.completed,
                             removed: local.removed,
                             dueDate: local.dueDate)
    }
}
