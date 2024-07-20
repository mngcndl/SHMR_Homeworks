//
//  TodoListQuery.swift
//  SHMRweek1
//
//  Created by Liubov Smirnova on 17.07.2024.
//

import Foundation

struct TodoItemListQuery: Codable {
    let status: String
    let list: [ExtendedTodoItem]

    init(
        status: String = Constants.statusDefaultValue,
        list: [ExtendedTodoItem]
    ) {
        self.status = status
        self.list = list
    }
}

extension TodoItemListQuery {
    enum Constants {
        static let statusDefaultValue = "ok"
    }
}
