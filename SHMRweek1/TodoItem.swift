//
//  TodoItem.swift
//  SHMRweek1
//
//  Created by Liubov Smirnova on 18.06.2024.
//

import Foundation

struct TodoItem {
    var id: String = UUID().uuidString
    var text: String
    var priority: Priority
    var deadline: Date?
    var done: Bool = false
    var creationDate: Date = .init()
    var editDate: Date?

    enum Priority: String, Codable {
        case low, usual, high
    }

    enum CodingKeys {
        static let idKey = "id"
        static let textKey = "text"
        static let priorityKey = "priority"
        static let deadlineKey = "deadline"
        static let doneKey = "done"
        static let creationDateKey = "creationDate"
        static let editDateKey = "editDate"
    }

    var json: Data? {
        var jsonToFormat: [String: Any] = [
            CodingKeys.idKey: id,
            CodingKeys.textKey: text,
            CodingKeys.doneKey: done,
            CodingKeys.creationDateKey: creationDate.timeIntervalSince1970
        ]

        if priority != .usual {
            jsonToFormat[CodingKeys.priorityKey] = priority.rawValue
        }

        if let deadline = deadline {
            jsonToFormat[CodingKeys.deadlineKey] = deadline.timeIntervalSince1970
        }

        if let editDate = editDate {
            jsonToFormat[CodingKeys.editDateKey] = editDate.timeIntervalSince1970
        }

        return try? JSONSerialization.data(withJSONObject: jsonToFormat, options: [])
    }

    static func parse(jsonData: Data) -> TodoItem? {
        guard let parsedJson = try? JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any] else {
            print("Error in JSON parsing")
            return nil
        }

        guard let parsedId = parsedJson[CodingKeys.idKey] as? String,
              let parsedText = parsedJson[CodingKeys.textKey] as? String,
              let parsedPriorityRaw = parsedJson[CodingKeys.priorityKey] as? String,
              let parsedPriority = Priority(rawValue: parsedPriorityRaw),
              let parsedDone = parsedJson[CodingKeys.doneKey] as? Bool,
              let parsedCreationDate = parsedJson[CodingKeys.creationDateKey] as? Double
        else {
            return nil
        }

        let parsedDeadline = (parsedJson[CodingKeys.deadlineKey] as? Double).flatMap { Date(timeIntervalSince1970: $0) }
        let parsedEditDate = (parsedJson[CodingKeys.editDateKey] as? Double).flatMap { Date(timeIntervalSince1970: $0) }

        return TodoItem(
            id: parsedId,
            text: parsedText,
            priority: parsedPriority,
            deadline: parsedDeadline,
            done: parsedDone,
            creationDate: Date(timeIntervalSince1970: parsedCreationDate),
            editDate: parsedEditDate
        )
    }

    func toCSV() -> String {
        var components: [String] = []

        components.append(escapeCSVField(id))
        components.append(escapeCSVField(text))
        components.append(priority.rawValue)
        components.append(deadline.map { "\($0.timeIntervalSince1970)" } ?? "")
        components.append("\(done)")
        components.append("\(creationDate.timeIntervalSince1970)")
        components.append(editDate.map { "\($0.timeIntervalSince1970)" } ?? "")

        return components.joined(separator: ",")
    }

    static func fromCSV(csvString: String) -> TodoItem? {
        let components = parseCSVLine(csvString)
        guard components.count >= 6 else { return nil }

        let id = components[0]
        let text = components[1]
        guard let priority = Priority(rawValue: components[2]) else { return nil }
        let deadline = components[3].isEmpty ? nil : Double(components[3]).flatMap { Date(timeIntervalSince1970: $0) }
        guard let done = Bool(components[4]) else { return nil }
        let creationDate = Date(timeIntervalSince1970: Double(components[5])!)
        let editDate = components.count > 6 ? Double(components[6]).flatMap { Date(timeIntervalSince1970: $0) } : nil

        return TodoItem(
            id: id,
            text: text,
            priority: priority,
            deadline: deadline,
            done: done,
            creationDate: creationDate,
            editDate: editDate
        )
    }

    private func escapeCSVField(_ field: String) -> String {
        if field.contains(",") || field.contains("\"") || field.contains("\n") {
            let escapedField = field.replacingOccurrences(of: "\"", with: "\"\"")
            return "\"\(escapedField)\""
        }
        return field
    }

    private static func parseCSVLine(_ line: String) -> [String] {
        var components: [String] = []
        var currentComponent = ""
        var insideQuotes = false

        for char in line {
            if char == "\"" {
                insideQuotes.toggle()
            } else if char == ",", !insideQuotes {
                components.append(currentComponent)
                currentComponent = ""
            } else {
                currentComponent.append(char)
            }
        }

        components.append(currentComponent)
        return components
    }
}
