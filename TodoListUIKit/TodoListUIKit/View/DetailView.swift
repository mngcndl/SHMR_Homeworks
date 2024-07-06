import SwiftUI

struct DetailView: View {
    @Binding var text: String
    @Binding var priority: TodoItem.Priority
    @Binding var deadlineEnabled: Bool
    @Binding var deadline: Date

    var body: some View {
        VStack {
            HStack {
                Button("Отменить") {
                }
                Spacer()
                Text("Дело")
                    .font(.headline)
                Spacer()
                Button(action: {
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

            if deadlineEnabled {
                            DatePicker("", selection: $deadline, displayedComponents: .date)
                                .datePickerStyle(GraphicalDatePickerStyle())
                                .environment(\.locale, Locale(identifier: "ru_RU"))
                                .environment(\.calendar, Calendar(identifier: .gregorian))
                                .padding()
                        }
                Spacer()
        }
        .background(Color(UIColor.systemGroupedBackground))
        .navigationBarHidden(true)
    }
}
