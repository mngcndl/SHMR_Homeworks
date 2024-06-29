import SwiftUI

struct ListView: View {
    @EnvironmentObject var listViewModel: ListViewModel
    @State private var showDoneItems: Bool = false
    
    var body: some View {
        NavigationView {
            VStack {
                VStack(alignment: .leading) {
                    HStack {
                        Text("Мои дела")
                            .font(.largeTitle)
                            .bold()
                            .padding(.bottom)
                            .foregroundColor(.primary) // Use dynamic color for text
                    }
                    HStack {
                        Text("Выполнено - \(listViewModel.completedItemsCount)")
                            .foregroundColor(.secondary) // Use dynamic color for text
                        Spacer()
                        Button(action: {
                            showDoneItems.toggle()
                        }) {
                            Text(showDoneItems ? "Скрыть" : "Показать")
                        }
                        .foregroundColor(.blue) // Use dynamic color for button
                    }
                    .padding(.trailing)
                }
                .padding(.leading)
                
                List {
                    ForEach(listViewModel.items.filter { !($0.done && !showDoneItems) }, id: \.id) { currentItem in
                        NavigationLink(destination: DetailView(item: currentItem)) {
                            ListRowView(item: currentItem)
                        }
                        .swipeActions(edge: .trailing) {
                            Button(role: .destructive) {
                                listViewModel.deleteItem(currentItem)
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                            .tint(.red)
                            
                            NavigationLink(destination: DetailView(item: currentItem)) {
                                Label("Info", systemImage: "info.circle")
                            }
                            .tint(.gray)
                        }
                        .swipeActions(edge: .leading) {
                            Button {
                                listViewModel.markItemAsDone(currentItem)
                            } label: {
                                Label("Done", systemImage: "checkmark.circle.fill")
                            }
                            .tint(.green)
                        }
                    }
                    
                    NavigationLink(destination: DetailView()) {
                        Text("Новое")
                            .foregroundColor(.gray) // Use dynamic color for text
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color(UIColor.systemGray6))
                            .cornerRadius(10)
                    }
                }
                .listStyle(InsetGroupedListStyle())
                
                NavigationLink(destination: DetailView()) {
                    Image(systemName: "plus")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .font(.largeTitle)
                        .cornerRadius(.infinity)
                }
            }
            .background(Color(UIColor.systemBackground))
            .navigationBarHidden(true)
        }
    }
}

struct ListView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            NavigationView {
                ListView()
            }
            .environmentObject(ListViewModel())
            .preferredColorScheme(.light)
            
            NavigationView {
                ListView()
            }
            .environmentObject(ListViewModel())
            .preferredColorScheme(.dark)
        }
    }
}
