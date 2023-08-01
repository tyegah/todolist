//
//  MainContentView.swift
//  ToDoList
//
//  Created by Ty Septiani on 01/08/23.
//

import SwiftUI

struct MainContentView: View {
    @ObservedObject var viewModel: TodoListViewModel
    
    @State private var searchText = ""
    @State private var presentNewItemSheet: Bool = false
    
    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(viewModel.todoList, id:\.id){ item in
                        TodoItemCell(model: item) { model in
                            viewModel.didSelectItem(model)
                            viewModel.save()
                        }
                        .onTapGesture {
                            viewModel.didSelectItem(item)
                            presentNewItemSheet = true
                        }
                    }
                    .onDelete { item in
                        viewModel.delete(viewModel.todoList[item.first ?? 0])
                    }
                }
            }
            .navigationTitle("ToDo List")
            .toolbar {
                Button {
                    viewModel.createNewModel()
                    presentNewItemSheet = true
                } label: {
                    Image(systemName: "plus")
                        .font(.title3)
                }
            }
            .sheet(isPresented: $presentNewItemSheet) {
                AddNewItemView(model: viewModel.getItemModel(), onSave: { _ in
                    viewModel.save()
                    presentNewItemSheet = false
                }, onDismiss: {
                    presentNewItemSheet = false
                })
            }
            .onAppear {
                viewModel.loadList()
            }
            .onChange(of: searchText) { newValue in
                viewModel.search(searchText)
            }
        }
        .searchable(text: self.$searchText)
    }
}
//
//struct MainContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        MainContentView(viewModel: TodoListViewModel(loader: LocalTodoListLoader(store: <#TodoListStore#>)))
//    }
//}
