//
//  ItemModel.swift
//  ToDoList
//
//  Created by Martina Maria Bruno on 11/11/25.
//

import Foundation

// Modello che rappresenta una categoria per organizzare gli item della todo list
// Conforme a Codable per salvare/caricare da UserDefaults
// Conforme a Identifiable per usarlo in SwiftUI List/ForEach
// Conforme a Equatable per confrontare le categorie
struct CategoryModel: Codable, Identifiable, Equatable {
    let id: String
    var title: String
    
// Inizializzatore che crea una nuova categoria
    init(id: String = UUID().uuidString, title: String) {
        self.id = id
        self.title = title
    }
    
// Categoria per task da fare oggi, domani, spesa, in futuro
    static let today = CategoryModel(id: "today", title: "Today")
    static let tomorrow = CategoryModel(id: "tomorrow", title: "Tomorrow")
    static let groceries = CategoryModel(id: "groceries", title: "Groceries")
    static let someday = CategoryModel(id: "someday", title: "Some day")
    
    static let allCategories = [today, tomorrow, groceries, someday]
}

// Modello immutabile che rappresenta un singolo task nella todo list
struct ItemModel: Identifiable, Codable {
    let id: String
    let title: String
    let isCompleted: Bool
    let categoryId: String
    
// Inizializzatore che crea un nuovo item
    init(id: String = UUID().uuidString, title: String, isCompleted: Bool, categoryId: String) {
        self.id = id
        self.title = title
        self.isCompleted = isCompleted
        self.categoryId = categoryId
    }

    func updateCompletion() -> ItemModel {
        return ItemModel(id: id, title: title, isCompleted: !isCompleted, categoryId: categoryId)
    }
}
