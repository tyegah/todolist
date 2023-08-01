//
//  TodoItemCell.swift
//  ToDoList
//
//  Created by Ty Septiani on 01/08/23.
//

import SwiftUI

private extension TodoItemModel {
    func getDateFormatted() -> String {
        guard let date = dueDate else { return "" }
        return date.formatDate()
    }
    
    func getDateColor() -> Color {
        guard let date = dueDate else { return .gray }
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        if date < today {
            return .red
        }
        else {
            return .gray
        }
    }
}

struct TodoItemCell: View {
    var model: TodoItemModel
    var update: (TodoItemModel) -> Void
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
                .onTapGesture {
                    model.toggleCompleted()
                    update(model)
                }
            
            VStack(alignment: .leading, spacing: 8.0) {
                Text(model.title)
                    .font(.headline)
                    .foregroundColor(model.completed ? .secondary : .primary)
                Text(model.desc ?? "")
                    .font(.footnote)
                    .foregroundColor(.gray)
                if model.dueDate != nil {
                    Text(model.getDateFormatted())
                        .font(.subheadline)
                        .foregroundColor(model.getDateColor())
                }
            }
            Spacer()
        }
        .background(.white)
    }
}

struct TodoItemCell_Previews: PreviewProvider {
    static var previews: some View {
        TodoItemCell(model: TodoItemModel(id: UUID(), title: "title", desc: "Description here", completed: false), update: {_ in })
    }
}
