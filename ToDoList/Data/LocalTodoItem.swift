//
//  LocalTodoItem.swift
//  ToDoList
//
//  Created by Ty Septiani on 01/08/23.
//

import Foundation

struct LocalTodoItem {
    var id: UUID
    var title: String
    var desc: String?
    var completed: Bool
    var removed: Bool
    var dueDate: Date?
}
