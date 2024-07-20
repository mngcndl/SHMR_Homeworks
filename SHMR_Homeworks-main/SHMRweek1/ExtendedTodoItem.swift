//
//  ExtendedTodoItem.swift
//  SHMRweek1
//
//  Created by Liubov Smirnova on 19.07.2024.
//

import Foundation
import SwiftUI

extension Date {
    var noon: Date {
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(secondsFromGMT: 0)!
        return calendar.date(bySettingHour: 12, minute: 0, second: 0, of: self)!
    }
}

enum Priority: String, Codable {
    case low = "low"
    case usual = "usual"
    case high = "high"
}

struct ExtendedTodoItem {
    let id: String
    let text: String
    let priority: Priority
    let deadline: Date?
    let done: Bool?
    let color: String?
    let creationDate: Date
    let editDate: Date?
    let lastUpdateBy: String
    
//    enum CodingKeys: String, CodingKey {
//        case id, text, priority, deadline, isDone, color, createdAt, editedAt, lastUpdateBy
//    }
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case text = "text"
        case priority = "importance"
        case deadline = "deadline"
        case isDone = "done"
        case color = "color"
        case createdAt = "created_at"
        case editedAt = "changed_at"
        case lastUpdateBy = "last_update_by"
    }
    
    init(
        id: String,
        text: String,
        priority: Priority,
        deadline: Date?,
        done: Bool?,
        color: String?,
        creationDate: Date,
        editDate: Date?,
        lastUpdateBy: String
    ) {
        self.id = id
        self.text = text
        self.priority = priority
        self.deadline = deadline
        self.done = done
        self.color = color
        self.creationDate = creationDate
        self.editDate = editDate
        self.lastUpdateBy = lastUpdateBy
    }

//    enum CodingKeys: String, CodingKey {
//        case id
//        case text
//        case priority
//        case deadline
//        case done
//        case color
//        case creationDate
//        case editDate
//        case lastUpdateBy
//    }
    
//    func encode(to encoder: Encoder) throws {
//        var container = encoder.container(keyedBy: CodingKeys.self)
//        try container.encode(id, forKey: .id)
//        try container.encode(text, forKey: .text)
//        try container.encode(priority, forKey: .priority)
//        try container.encode(deadline?.noon, forKey: .deadline)
//        try container.encode(done, forKey: .done)
//        try container.encode(color, forKey: .color)
//        try container.encode(creationDate.noon, forKey: .creationDate)
//        try container.encode(editDate?.noon, forKey: .editDate)
//        try container.encode(lastUpdateBy, forKey: .lastUpdateBy)
//    }

//    init(from decoder: Decoder) throws {
//        let values = try decoder.container(keyedBy: CodingKeys.self)
//        id = try values.decode(String.self, forKey: .id)
//        text = try values.decode(String.self, forKey: .text)
//        priority = try values.decode(Priority.self, forKey: .priority)
//        deadline = try? values.decode(Date.self, forKey: .deadline)
//        done = try values.decode(Bool.self, forKey: .done)
//        color = try? values.decode(String.self, forKey: .color)
//        creationDate = try values.decode(Date.self, forKey: .creationDate)
//        editDate = try? values.decode(Date.self, forKey: .editDate)
//        lastUpdateBy = try values.decode(String.self, forKey: .lastUpdateBy)
//    }
}

extension ExtendedTodoItem {
    enum Priority: String, Codable {
        case low = "low"
        case usual = "basic"
        case high = "important"

        init(from priority: TodoItem.Priority) {
            switch priority {
            case .low:
                self = .low
            case .usual:
                self = .usual
            case .high:
                self = .high
            }
        }
    }

    enum Constants {
        static let color: String = ""
        static let defaultDeviceId: String = ""
    }
}

extension ExtendedTodoItem {
    init(from todoItem: TodoItem) {
        self.init(
            id: todoItem.id,
            text: todoItem.text,
            priority: Priority(from: todoItem.priority),
            deadline: todoItem.deadline,
            done: todoItem.done,
            color: Constants.color,
            creationDate: todoItem.creationDate,
            editDate: todoItem.editDate ?? Date(),
            lastUpdateBy: UIDevice.current.identifierForVendor?.uuidString ?? Constants.defaultDeviceId
        )
    }
}

extension ExtendedTodoItem: Codable {
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(text, forKey: .text)
        try container.encode(priority, forKey: .priority)
        try container.encode(deadline?.noon, forKey: .deadline)
        try container.encode(done, forKey: .isDone)
        try container.encode(color, forKey: .color)
        try container.encode(creationDate.noon, forKey: .createdAt)
        try container.encode(editDate?.noon, forKey: .editedAt)
        try container.encode(lastUpdateBy, forKey: .lastUpdateBy)
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decode(String.self, forKey: .id)
        text = try values.decode(String.self, forKey: .text)
        priority = try values.decode(Priority.self, forKey: .priority)
        deadline = try? values.decode(Date.self, forKey: .deadline)
        done = try values.decode(Bool.self, forKey: .isDone)
        color = try? values.decode(String.self, forKey: .color)
        creationDate = try values.decode(Date.self, forKey: .createdAt)
        editDate = try? values.decode(Date.self, forKey: .editedAt)
        lastUpdateBy = try values.decode(String.self, forKey: .lastUpdateBy)
    }
}
