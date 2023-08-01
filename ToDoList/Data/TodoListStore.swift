//
//  TodoListStore.swift
//  ToDoList
//
//  Created by Ty Septiani on 01/08/23.
//

import Foundation

protocol TodoListStore {
    typealias DeletionResult = Swift.Result<Void, Error>
    typealias DeletionCompletion = (DeletionResult) -> Void
    
    typealias UpdateResult = Swift.Result<Void, Error>
    typealias UpdateCompletion = (UpdateResult) -> Void
    
    typealias InsertionResult = Swift.Result<Void, Error>
    typealias InsertionCompletion = (InsertionResult) -> Void
    
    typealias RetrievalResult = Swift.Result<[LocalTodoItem], Error>
    typealias RetrievalCompletion = (RetrievalResult) -> Void
    
    func update(_ item: LocalTodoItem, completion: @escaping UpdateCompletion)
    func delete(_ item: LocalTodoItem, completion: @escaping DeletionCompletion)
    func insert(_ item:LocalTodoItem, completion: @escaping InsertionCompletion)
    func retrieve(_ predicate: NSPredicate?, completion: @escaping RetrievalCompletion)
}
