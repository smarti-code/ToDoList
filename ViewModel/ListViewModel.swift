//
//  ListViewModel.swift
//  ToDoList
//
//  Created by Martina Maria Bruno on 11/11/25.
//

// ViewModel principale dell'app che gestisce la logica

import Foundation
internal import Combine
import SwiftUI

// Responsabile di: gestire items, categorie, persistenza dati
class ListViewModel: ObservableObject {

// Array di tutti gli item della todo list
    @Published var items: [ItemModel] = [] {
        didSet {
            saveItems()
        }
    }

// Array di tutte le categorie disponibili
    @Published var categories: [CategoryModel] = CategoryModel.allCategories {
        didSet {
            saveCategories()
        }
    }
    
// Chiave per salvare/caricare gli items
    let itemsKey: String = "items_list"
// Chiave per salvare/caricare le categorie
    let categoriesKey: String = "categories_list"
    
// Inizializzatore: carica categorie e items salvati quando il ViewModel viene creato
    init() {
        getCategories() // Carica prima le categorie
        getItems() // Poi carica gli items
    }
    
// Carica gli items salvati
// Se non ci sono dati salvati o la decodifica fallisce, items rimane array vuoto
    func getItems() {
        guard let data = UserDefaults.standard.data(forKey: itemsKey) else { return }
        guard let savedItems = try? JSONDecoder().decode([ItemModel].self, from: data) else { return }
        
        self.items = savedItems
    }
    
// Carica le categorie salvate
// Se non ci sono categorie salvate, usa le categorie di default
    func getCategories() {
        guard let data = UserDefaults.standard.data(forKey: categoriesKey) else {
            // Se non ci sono categorie salvate, usa quelle di default
            categories = CategoryModel.allCategories
            return
        }
        guard let savedCategories = try? JSONDecoder().decode([CategoryModel].self, from: data) else { return }
        
        self.categories = savedCategories
    }
    
// Elimina gli item agli indici specificati
    func deleteItem(indexSet: IndexSet) {
        items.remove(atOffsets: indexSet)
    }

// Sposta gli item da una posizione a un'altra (per riordinamento drag & drop)
    func moveItem(from: IndexSet, to: Int, in categoryId: String) {
        var itemsInCategory = items(for: categoryId)
        itemsInCategory.move(fromOffsets: from, toOffset: to)
        items.removeAll { $0.categoryId == categoryId }
        items.append(contentsOf: itemsInCategory)
    }
    
// Aggiunge un nuovo item alla lista
    func addItem(title: String, categoryId: String) {
        let newItem = ItemModel(title: title, isCompleted: false, categoryId: categoryId)
        items.append(newItem)
    }
    
// Aggiorna lo stato di completamento di un item (toggle completed/uncompleted)
    func updateItem(item: ItemModel) {
        if let index = items.firstIndex(where: { $0.id == item.id }) {
            items[index] = item.updateCompletion()
        }
    }
    
// Modifica il titolo di un item esistente
    func editItem(item: ItemModel, newTitle: String) {
        if let index = items.firstIndex(where: { $0.id == item.id }) {
            let updatedItem = ItemModel(id: item.id, title: newTitle, isCompleted: item.isCompleted, categoryId: item.categoryId)
            items[index] = updatedItem
        }
    }
    
// Restituisce solo gli items che appartengono a una specifica categoria
    func items(for categoryId: String) -> [ItemModel] {
        return items.filter { $0.categoryId == categoryId }
    }
    
// Aggiorna il titolo di una categoria
    func updateCategory(category: CategoryModel, newTitle: String) {
        if let index = categories.firstIndex(where: { $0.id == category.id }) {
            categories[index] = CategoryModel(id: category.id, title: newTitle)
        }
    }
    
// Salva l'array di items
    func saveItems() {
        if let encodedData = try? JSONEncoder().encode(items) {
            UserDefaults.standard.set(encodedData, forKey: itemsKey)
        }
    }
    
// Salva l'array di categorie 
    func saveCategories() {
        if let encodedData = try? JSONEncoder().encode(categories) {
            UserDefaults.standard.set(encodedData, forKey: categoriesKey)
        }
    }
}
