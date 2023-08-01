//
//  LocalTodoItem.swift
//  ToDoList
//
//  Created by Ty Septiani on 01/08/23.
//

import Foundation

struct LocalTodoItem {
    let id: UUID
    let title: String
    let desc: String?
    let completed: Bool
    let removed: Bool
    let dueDate: Date?
}
