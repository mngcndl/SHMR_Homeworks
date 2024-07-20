//
//  ListViewModel.swift
//  SHMRweek1
//
//  Created by Liubov Smirnova on 29.06.2024.
//

import Foundation

class ListViewModel: ObservableObject {
    @Published var items: [TodoItem] = []
    
    init() {
        getItems()
    }
    
    var completedItemsCount: Int {
        items.filter { $0.done }.count
    }
    
    func getItems() {
        let newItems = [TodoItem(text: "Эх купить бы сырочек", priority: .high, deadline: nil, done: true, editDate: Date()),
            TodoItem(text: "Да наварить макарошек", priority: .high, deadline: nil, done: false, editDate: Date())]
        items.append(contentsOf: newItems)
    }
    
    func deleteItem(indexSet: IndexSet) {
        items.remove(atOffsets: indexSet )
    }
    
    func deleteItem(_ item: TodoItem) {
            items.removeAll { $0.id == item.id }
    }
    
    func addItem(text: String, priority: TodoItem.Priority, deadline: Date?) {
            let newItem = TodoItem(text: text, priority: priority, deadline: deadline, done: false, editDate: Date())
            items.append(newItem)
    }
    
    func markItemAsDone(_ item: TodoItem) {
        if let index = items.firstIndex(where: { $0.id == item.id }) {
            items[index].done = true
        }
    }
}
