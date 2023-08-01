//
//  LocalTodoListLoader.swift
//  ToDoList
//
//  Created by Ty Septiani on 01/08/23.
//

import Foundation

protocol TodoItemSaver {
    func save(_ item: LocalTodoItem) async throws
}

protocol TodoItemLoader {
    func load(predicate: NSPredicate?) async throws -> [LocalTodoItem]
}

final class LocalTodoListLoader {
    private let store: TodoListStore
    
    init(store: TodoListStore) {
        self.store = store
    }
}

extension LocalTodoListLoader: TodoItemSaver {
    func save(_ item: LocalTodoItem) async throws {
        try await withCheckedThrowingContinuation({ continuation in
            store.insert(item) { result in
                continuation.resume(with: result)
            }
        })
    }
}

extension LocalTodoListLoader: TodoItemLoader {
    func load(predicate: NSPredicate?) async throws -> [LocalTodoItem] {
        try await withCheckedThrowingContinuation({ continuation in
            store.retrieve(predicate) { result in
                continuation.resume(with: result)
            }
        })
    }
}
