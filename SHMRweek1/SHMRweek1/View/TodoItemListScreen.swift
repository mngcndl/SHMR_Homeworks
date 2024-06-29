//
//  SHMRweek1
//
//  Created by Liubov Smirnova on 26.06.2024.
//

import SwiftUI

struct TodoItemListScreen: View {
    let todoItem: TodoItem
    var body: some View {
        Text(
            "Мои дела"
        ).foregroundColor(.red)
        HStack {
          Text(todoItem.text)
          .font(.headline)
          .lineLimit(1)
        Spacer()
      }
      .padding(.vertical, 8)
  }
}

struct TodoItemListScreen_Previews: PreviewProvider {
    static var previews: some View {
        TodoItemListScreen(todoItem: TodoItem(id: UUID().uuidString, text: "i have to do this thing", priority: TodoItem.Priority.high, done: false, creationDate: Date.now))
    }
}
