//
//  TodoListViewModel.swift
//  ToDoList
//
//  Created by Ty Septiani on 01/08/23.
//

import SwiftUI

class TodoListViewModel: ObservableObject {
    typealias Loader = TodoItemLoader & TodoItemSaver & TodoItemUpdater & TodoItemRemover
    private let loader: Loader
    init(loader: Loader) {
        self.loader = loader
    }
    
    @Published var todoList: [TodoItemModel] = []
    @Published var showToast = false
    var toastMessage: ImageToastData = .error(message: "", completion: {})
    private var localList: [LocalTodoItem] = []
    private var selectedModel: TodoItemModel?

    func loadList() {
        Task {
            do {
                let predicate = NSPredicate(format: "removed == NO")
                let result = try await loader.load(predicate: predicate)
                await MainActor.run {
                    self.localList = result
                    self.todoList = result.map { TodoItemModel.initFrom($0) }
                }
            }
            catch {
                await handleError("Failed to load items from database.")
            }
        }
    }
    
    func getItemModel() -> TodoItemModel {
        guard let model = selectedModel else {
            let newModel = TodoItemModel(id: UUID(), title: "", completed: false)
            selectedModel = newModel
            return newModel
        }
        return model
    }
    
    func createNewModel() {
        let newModel = TodoItemModel(id: UUID(), title: "", completed: false)
        selectedModel = newModel
    }
    
    func didSelectItem(_ item: TodoItemModel) {
        self.selectedModel = item
    }
    
    func save() {
        guard let model = selectedModel else { return }
        let localItem = LocalTodoItem(id: model.id,
                                      title: model.title,
                                      desc: model.desc,
                                      completed: model.completed,
                                      removed: model.removed,
                                      dueDate: model.dueDate)
        if todoList.contains(where: { item in
            item.id == model.id
        }) {
            update(localItem)
        }
        else {
            add(localItem)
        }
        
    }
    
    func delete(_ model: TodoItemModel) {
        Task {
            do {
                try await loader.delete(LocalTodoItem(id: model.id,
                                                      title: model.title,
                                                      desc: model.desc,
                                                      completed: model.completed,
                                                      removed: model.removed,
                                                      dueDate: model.dueDate))
                loadList()
            }
            catch {
                debugPrint("ERROR \(error)")
                await handleError("Failed to delete item.")
            }
        }
    }
    
    @MainActor
    private func handleError(_ message: String) {
        toastMessage = .error(message: message, completion: { [weak self] in
            self?.showToast = false
        })
        showToast = true
        loadList()
    }
    
    func search(_ keyword: String) {
        if keyword.isEmpty {
            todoList = localList.map { TodoItemModel.initFrom($0) }
            return
        }
        
        let searchResult = localList.filter { item in
            item.title.lowercased().contains(keyword.lowercased()) || item.desc?.lowercased().contains(keyword.lowercased()) == true
        }
        todoList = searchResult.map { TodoItemModel.initFrom($0) }
    }
    
    private func add(_ item: LocalTodoItem) {
        Task {
            do {
                try await loader.save(item)
                loadList()
            }
            catch {
                debugPrint("ERROR \(error)")
                await handleError("Failed to add new item.")
            }
        }
    }
    
    private func update(_ item: LocalTodoItem) {
        Task {
            do {
                try await loader.update(item)
                loadList()
            }
            catch {
                await handleError("Failed to update item.")
            }
        }
    }
}
