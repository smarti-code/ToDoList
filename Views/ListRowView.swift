//
//  ListRowView.swift
//  ToDoList
//
//  Created by Martina Maria Bruno on 07/11/25.
//

import SwiftUI

struct ListRowView: View {
    
    let item: ItemModel
    
    var body: some View {
            HStack {
                Image(systemName: item.isCompleted ? "checkmark.circle" : "circle")
                    .foregroundColor(item.isCompleted ? .green : .red)
                Text(item.title)
                Spacer ()
            }
            .font(.title2)
            .padding(.vertical, 8)
    }
}
#Preview(traits: .sizeThatFitsLayout) {
    var item1 = ItemModel(title: "First item", isCompleted: false)
    var item2 = ItemModel(title: "Second item", isCompleted: true)
    
    Group {
        ListRowView(item: item1)
        ListRowView(item: item2)
    }
}

