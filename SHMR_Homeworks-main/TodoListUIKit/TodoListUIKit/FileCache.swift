//
//  FileCache.swift
//  SHMRweek1
//
//  Created by Liubov Smirnova on 19.06.2024.
//

import Foundation

struct FileCache {
    private var items: [TodoItem] = []
    var itemList: [TodoItem] {
        return items
    }
    mutating func addItem(item: TodoItem) {
        if !items.contains(where: { $0.id == item.id }) {
            items.append(item)
        }
    }
    mutating func removeItem(id: String) {
        items.removeAll { $0.id == id }
    }
    private func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    func saveItemsToFile(filename: String) {
        let url = getDocumentsDirectory().appendingPathComponent(filename)
        let jsonArray = items.compactMap { $0.json }
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: jsonArray, options: .prettyPrinted)
            try jsonData.write(to: url)
        } catch {
            print("Failed to save: \(error)")
        }
    }
    mutating func loadFromFile(filename: String) {
        let url = getDocumentsDirectory().appendingPathComponent(filename)
        do {
            let data = try Data(contentsOf: url)
            if let jsonArray = try JSONSerialization.jsonObject(with: data, options: []) as? [Data] {
                for jsonData in jsonArray {
                    if let itemToAdd = TodoItem.parse(jsonData: jsonData) {
                        addItem(item: itemToAdd)
                    }
                }
            }
        } catch {
            print("Failed to load: \(error)")
        }
    }
}
