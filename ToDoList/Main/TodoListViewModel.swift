//
//  TodoListViewModel.swift
//  ToDoList
//
//  Created by Ty Septiani on 01/08/23.
//

import SwiftUI

class TodoListViewModel: ObservableObject {
    typealias Loader = TodoItemLoader & TodoItemSaver
    private let loader: Loader
    init(loader: Loader) {
        self.loader = loader
    }
    
    @Published var todoList: [TodoItemModel] = []
    private var selectedModel: TodoItemModel?

    func loadList() {
        Task {
            do {
                let result = try await loader.load(predicate: nil)
                debugPrint("RESULT \(result)")
                await MainActor.run {
                    self.todoList = result.map { TodoItemModel.initFrom($0) }
                }
            }
            catch {
                
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
    
    func save() {
        guard let model = selectedModel else { return }
        Task {
            do {
                try await loader.save(LocalTodoItem(id: model.id,
                                                    title: model.title,
                                                    desc: model.desc,
                                                    completed: model.completed,
                                                    removed: model.removed,
                                                    dueDate: model.dueDate))
                loadList()
            }
            catch {
                debugPrint("NO ERROR \(error)")
            }
        }
    }
}
