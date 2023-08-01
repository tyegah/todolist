//
//  TodoItemCell.swift
//  ToDoList
//
//  Created by Ty Septiani on 01/08/23.
//

import SwiftUI

struct TodoItemCell: View {
    var model: TodoItemModel
    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            Circle()
                .stroke(Color.secondary, lineWidth: 1.0)
                .overlay(
                                        Circle()
                                            .fill(model.completed ? Color.blue : .clear)
                                            .frame(width: 16, height: 16)
                                    )
                .frame(width: 20.0, height: 20.0)
            
            VStack(alignment: .leading, spacing: 8.0) {
                Text(model.title)
                    .font(.headline)
                Text(model.desc ?? "")
                    .font(.footnote)
                    .foregroundColor(.gray)
            }
        }
    }
}

struct TodoItemCell_Previews: PreviewProvider {
    static var previews: some View {
        TodoItemCell(model: TodoItemModel(id: UUID(), title: "title", desc: "Description here", completed: true))
    }
}
