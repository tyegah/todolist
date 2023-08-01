//
//  AddNewItemView.swift
//  ToDoList
//
//  Created by Ty Septiani on 01/08/23.
//

import SwiftUI

struct AddNewItemView: View {
    @State var title: String = ""
    @State var description: String = ""
    @State var dueDate: Date = .now
    var model: TodoItemModel
    var onSave: (TodoItemModel) -> Void
    var onDismiss: () -> Void
    
    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    onDismiss()
                }) {
                    Text("Cancel")
                        .fontWeight(.bold)
                }
                Spacer()
                Text("New Item")
                    .font(.title)
                    .bold()
                Spacer()
                Button(action: {
                    // Code to create the post here
                    model.title = title
                    model.desc = description
                    model.dueDate = dueDate
                    
                    onSave(model)
                }) {
                    Text("Save")
                        .fontWeight(.bold)
                }
            }
            .padding()
            Form {
                Section(header: Text("")) {
                    TextField("Title", text: $title)
                    PlaceholderTextEditor("Notes", text: $description)
                    DatePicker("Due date", selection: $dueDate, displayedComponents: .date)
                }
            }
        }
    }
}

struct AddNewItemView_Previews: PreviewProvider {
    static var previews: some View {
        AddNewItemView(model: TodoItemModel(id: UUID(), title: "", completed: false, removed: false), onSave: {_ in }, onDismiss: {})
    }
}
