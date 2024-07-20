//
//  SingleTodoItemQuery.swift
//  SHMRweek1
//
//  Created by Liubov Smirnova on 17.07.2024.
//

import Foundation

struct SingleTodoItemQuery: Codable {
    let status: String
    let item: ExtendedTodoItem

    init(
        status: String = Constants.statusDefaultValue,
        item: ExtendedTodoItem
    ) {
        self.status = status
        self.item = item
    }

    enum CodingKeys: String, CodingKey {
        case status
        case item
    }
}

extension SingleTodoItemQuery {
    enum Constants {
        static let statusDefaultValue = "ok"
    }
}
