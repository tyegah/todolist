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

protocol TodoItemRemover {
    func delete(_ item: LocalTodoItem) async throws
}

protocol TodoItemUpdater {
    func update(_ item: LocalTodoItem) async throws
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

extension LocalTodoListLoader: TodoItemRemover {
    func delete(_ item: LocalTodoItem) async throws {
        try await withCheckedThrowingContinuation({ continuation in
            store.delete(item) { result in
                continuation.resume(with: result)
            }
        })
    }
}

extension LocalTodoListLoader: TodoItemUpdater {
    func update(_ item: LocalTodoItem) async throws {
        try await withCheckedThrowingContinuation({ continuation in
            store.update(item) { result in
                continuation.resume(with: result)
            }
        })
    }
}
