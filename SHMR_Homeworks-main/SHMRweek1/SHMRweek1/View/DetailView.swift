//
//  DetailView.swift
//  SHMRweek1
//
//  Created by Liubov Smirnova on 29.06.2024.
//

import SwiftUI
import CocoaLumberjack
import CocoaLumberjackSwift

struct DetailView: View {
    @EnvironmentObject var listViewModel: ListViewModel
    @Environment(\.presentationMode) var presentationMode
    @State private var text: String
    @State private var priority: TodoItem.Priority
    @State private var deadlineEnabled: Bool = false
    @State private var deadline: Date
    @State private var showCalendar: Bool = false
    let item: TodoItem?

    init(item: TodoItem? = nil) {
        self.item = item
        _text = State(initialValue: item?.text ?? "")
        _priority = State(initialValue: item?.priority ?? .usual)
        _deadlineEnabled = State(initialValue: item?.deadline != nil)
        _deadline = State(initialValue: item?.deadline ?? Date())
    }

    var body: some View {
        VStack {
            HStack {
                Button("Отменить") {
                    presentationMode.wrappedValue.dismiss()
                }
                Spacer()
                Text("Дело")
                    .font(.headline)
                Spacer()
                Button(action: {
                    saveItem()
                }) {
                    Text("**Сохранить**")
                }
                .padding()
            }
            .padding()
            
            TextEditor(text: $text)
                    .cornerRadius(15)
                    .padding(.horizontal)
                    .overlay(
                        Text("Что надо сделать?")
                            .foregroundColor(Color.gray)
                            .padding(.leading, 8)
                            .padding(.vertical, 12)
                            .opacity(text.isEmpty ? 1 : 0),
                        alignment: .topLeading
                    )
                    .onTapGesture {
                        showCalendar = false
                    }

                HStack {
                Text("Важность")
                Spacer()
                Picker("Priority", selection: $priority) {
                    Image(systemName: "arrow.down").tag(TodoItem.Priority.low)
                    Text("нет").tag(TodoItem.Priority.usual)
                    Text("!!").foregroundColor(.red).tag(TodoItem.Priority.high)
                }
                .pickerStyle(SegmentedPickerStyle())
                .frame(maxWidth: UIScreen.main.bounds.width * 0.3)
            }
            .padding()
            
            Toggle(isOn: $deadlineEnabled) {
                   VStack(alignment: .leading) {
                       Text("Сделать до")
                       if deadlineEnabled {
                           Text(deadline, style: .date)
                               .foregroundColor(.blue)
                       }
                   }
               }
               .padding()
               .onTapGesture {
                   showCalendar = false
               }

            if deadlineEnabled {
                            DatePicker("", selection: $deadline, displayedComponents: .date)
                                .datePickerStyle(GraphicalDatePickerStyle())
                                .environment(\.locale, Locale(identifier: "ru_RU"))
                                .environment(\.calendar, Calendar(identifier: .gregorian))
                                .padding()
                        }
                Spacer()

            if item != nil {
                Button(action: {
                    if let item = item {
                        listViewModel.deleteItem(item)
                    }
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Удалить")
                        .foregroundColor(.red)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.white)
                        .cornerRadius(8)
                }
                .padding()
            }
        }
        .background(Color(UIColor.systemGroupedBackground))
        .navigationBarHidden(true)
        .onTapGesture {
            showCalendar = false
        }
    }

    private func saveItem() {
        listViewModel.addItem(text: text, priority: priority, deadline: deadlineEnabled ? deadline : nil)
        presentationMode.wrappedValue.dismiss()
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            DetailView(item: TodoItem(text: "Что надо сделать?", priority: .usual, deadline: Date(), done: false, editDate: Date()))
                .environmentObject(ListViewModel())
                .preferredColorScheme(.light)
            DetailView(item: TodoItem(text: "Что надо сделать?", priority: .usual, deadline: Date(), done: false, editDate: Date()))
                .environmentObject(ListViewModel())
                .preferredColorScheme(.dark)
        }
    }
}
