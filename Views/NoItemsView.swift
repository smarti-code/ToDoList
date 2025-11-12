//
//  NoItemsView.swift
//  ToDoList
//
//  Created by Martina Maria Bruno on 12/11/25.
//

import SwiftUI

struct NoItemsView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 10) {
                Text ("There are no items")
                    .font(.title)
                    .fontWeight(.semibold)
                Text("Click the Add button and add a bunch of items to your todo list!")
                NavigationLink(destination: AddView(), label: { Text("Add Something 😎")})
                    .foregroundColor(.white)
                    .font(.headline)
                    .frame(height: 55)
                    .frame(maxWidth: .infinity)
                    .background(Color.accentColor)
                    .cornerRadius(10)
            }
            .multilineTextAlignment(.center)
            .padding(40)
        }
        
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        
    }
}

#Preview {
    NavigationView {
        NoItemsView()
            .navigationTitle("Title")
    }
}
