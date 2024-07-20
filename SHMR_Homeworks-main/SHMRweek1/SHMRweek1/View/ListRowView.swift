//
//  ListRowView.swift
//  SHMRweek1
//
//  Created by Liubov Smirnova on 28.06.2024.
//

import SwiftUI

struct ListRowView: View {
    let item: TodoItem
    var body: some View {
        HStack {
            if item.done {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(.green)
            } else {
                Image(systemName: "circle")
                    .foregroundColor(.gray)
            }
            VStack(alignment: .leading){
                Text(item.text)
                    .strikethrough(item.done)
                    .lineLimit(3)
                    .truncationMode(.tail)
                    .foregroundColor(item.done ? .gray : .primary)
                    .padding(4)
                
            if let item = item, let deadline = item.deadline {
                Text(deadline, style: .date)
                    .foregroundColor(.blue)
            }
                
            }
            Spacer()
            
        }
        .font(.title2)
        .padding(.vertical, 8)
    }
}

struct ListRowView_Previews: PreviewProvider {
    
    static var previewItem1 = TodoItem(text: "сделать зарядку", priority: .high, deadline: Date(), done: true, editDate: Date())
    static var previewItem2 = TodoItem(text: "Купить что-то, где-то, зачем-то, но зачем не очень понятно, но точно чтобы пок пок", priority: .high, deadline: nil, done: false, editDate: Date())
    
    static var previews: some View {
        Group {
            ListRowView(item: previewItem1)
            ListRowView(item: previewItem2)
        }
        .previewLayout(.sizeThatFits)
    }
}
