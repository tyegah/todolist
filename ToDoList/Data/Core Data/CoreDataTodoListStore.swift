//
//  CoreDataTodoListStore.swift
//  ToDoList
//
//  Created by Ty Septiani on 01/08/23.
//

import CoreData

final class CoreDataTodoListStore: TodoListStore {
    private let container: NSPersistentContainer
    private let context: NSManagedObjectContext
    
    var viewContext: NSManagedObjectContext {
        return container.viewContext
    }
    
    init(storeURL: URL, bundle: Bundle = Bundle.main) throws {
        container = try NSPersistentContainer.load(modelName: "ToDoList",
                                                   url: storeURL,
                                                   in: bundle)
        let description = NSPersistentStoreDescription(url: storeURL)
        description.shouldMigrateStoreAutomatically = true
        description.shouldInferMappingModelAutomatically = false
        container.persistentStoreDescriptions = [description]
        context = container.newBackgroundContext()
    }
    
    
    func update(_ item: LocalTodoItem, completion: @escaping UpdateCompletion) {
        
    }
    
    func delete(_ predicate: NSPredicate?, completion: @escaping DeletionCompletion) {
        
    }
    
    func insert(_ item: LocalTodoItem, completion: @escaping InsertionCompletion) {
        let context = self.context

        context.perform {
            completion( Result {
                let todoItem = TodoItem(context: context)
                
                todoItem.id = UUID()
                todoItem.title = item.title
                todoItem.desc = item.desc
                todoItem.dueDate = item.dueDate
                todoItem.completed = item.completed
                todoItem.removed = item.removed
                
                try context.save()
            })
        }
    }
    
    func retrieve(_ predicate: NSPredicate?, completion: @escaping RetrievalCompletion) {
        let context = self.context
        
        context.perform {
            completion( Result {
                let todoItems = try TodoItem.find(in: context, where: predicate)
                if todoItems.count > 0 {
                    return todoItems.compactMap { $0.local }
                }
                else {
                    return []
                }
            })
        }
    }
}