//
//  ListView.swift
//  ToDoList
//
//  Created by Martina Maria Bruno on 07/11/25.
//

import SwiftUI

struct ListView: View {
    
    @EnvironmentObject var listViewModel: ListViewModel
    
    var body: some View {
        List {
            ForEach (listViewModel.items) { item in
               ListRowView(item: item)
                    .onTapGesture {
                        withAnimation(.linear) {
                            listViewModel.updateItem(item: item)
                        }
                    }
            }
            .onDelete(perform: listViewModel.deleteItem)
            .onMove(perform: listViewModel.moveItem)
        }
        .listStyle(PlainListStyle())
        .navigationTitle("ToDo List📝")
        .navigationBarItems(
            leading: EditButton(),
            trailing:
                NavigationLink("Add", destination: AddView())
        )
    }
    
}

#Preview {
    NavigationStack {
        ListView()
    }
    .environmentObject(ListViewModel())
}
