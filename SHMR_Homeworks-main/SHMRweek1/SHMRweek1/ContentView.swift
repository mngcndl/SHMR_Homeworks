import SwiftUI

struct ContentView: View {
//    @Environment(\.managedObjectContext) private var viewContext

    // Assuming TodoItem has a static property `myItems` which returns an array of TodoItem
    @State
    private var items = TodoItem.myItems
    
    var body: some View {
//        NavigationView {
            VStack {
                Text("Мои дела")
                HStack {
                    Text("Выполнено - ")
                    Button(action: {
                        // Action for the button
                    }) {
                        Text("Показать")
                    }
                }
                List(items, id: \.self) { item in
//                    ForEach(items) { item in
                    HStack {
                        Image(systemName: item.done ? "done" : "emptyItem")
                            .imageScale(.large)
                        VStack(alignment: .leading) {
                            Text(item.text)
                            if let deadline = item.deadline {
                                Text(deadline, formatter: itemFormatter)
                            }
                        }
                    }
//                }
//                    .onDelete(perform: deleteItems)
                }
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        EditButton()
                    }
                    ToolbarItem {
                        Button(action: addItem) {
                            Label("Add Item", systemImage: "plus")
                        }
                    }
                }
                Text("Select an item")
            }
        }
    }

    private func addItem() {
        withAnimation {
            let newItem = Item(context: viewContext)
            newItem.timestamp = Date()

            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }

//    private func deleteItems(offsets: IndexSet) {
//        withAnimation {
//            offsets.map { items[$0] }.forEach(viewContext.delete)
//
//            do {
//                try viewContext.save()
//            } catch {
//                let nsError = error as NSError
//                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
//            }
//        }
//    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()



struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
