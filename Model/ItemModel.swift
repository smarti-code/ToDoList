//
//  ItemModel.swift
//  ToDoList
//
//  Created by Martina Maria Bruno on 11/11/25.
//

import Foundation

//Immutable Struct
struct ItemModel: Identifiable, Codable {
    let id: String
    let title: String
    let isCompleted: Bool
    
    init(id: String = UUID().uuidString, title: String, isCompleted: Bool) {
        self.id = id
        self.title = title
        self.isCompleted = isCompleted
    }

    func updateCompletion() -> ItemModel{
        return ItemModel(id: id, title: title, isCompleted: !isCompleted)
    }
    
}


//ItemModel(id: <#T##String#>, title: <#T##String#>, isCompleted: <#T##Bool#>)
//ItemModel(title: <#T##String#>, isCompleted: <#T##Bool#>)
