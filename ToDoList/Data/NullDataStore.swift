//
//  NullDataStore.swift
//  ToDoList
//
//  Created by Ty Septiani on 01/08/23.
//

import Foundation

class NullDataStore {}

extension NullDataStore: TodoListStore {
    func update(_ item: LocalTodoItem, completion: @escaping UpdateCompletion) {
        completion(.success(()))
    }
    
    func delete(_ predicate: NSPredicate?, completion: @escaping DeletionCompletion) {
        completion(.success(()))
    }
    
    func insert(_ item: LocalTodoItem, completion: @escaping InsertionCompletion) {
        completion(.success(()))
    }
    
    func retrieve(_ predicate: NSPredicate?, completion: @escaping RetrievalCompletion) {
        completion(.success([]))
    }
}
