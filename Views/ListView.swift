//
//  ListView.swift
//  ToDoList
//
//  Created by Martina Maria Bruno on 07/11/25.
//

import SwiftUI

// View principale che mostra la lista di tutti i task organizzati per categorie
// Permette di: aggiungere, modificare, eliminare items e categorie
// Permette di modificare il titolo principale dell'app

struct ListView: View {
    
    // ViewModel condiviso che contiene tutti i dati dell'app
    @EnvironmentObject var listViewModel: ListViewModel
    
    // Stati per aggiungere nuovo item
    @State private var addingToCategoryId: String? = nil
    @State private var newItemText: String = ""
    @FocusState private var isTextFieldFocused: Bool
    
    // Stati per la modifica item
    @State private var editingItemId: String? = nil
    @State private var editingText: String = ""
    @FocusState private var isEditFieldFocused: Bool
    
    // Stati per modificare il titolo principale
    @State private var isEditingTitle: Bool = false
    @State private var listTitle: String = "ToDo List📝"
    @FocusState private var isTitleFieldFocused: Bool
    
    // Stati per modificare il titolo della categoria
    @State private var editingCategoryId: String? = nil
    @State private var editingCategoryText: String = ""
    @FocusState private var isCategoryFieldFocused: Bool
    
    var body: some View {
        // Lista principale con stile InsetGrouped (stile iOS standard con sezioni)
        List {
            ForEach(listViewModel.categories) { category in
                // Ogni categoria è una Section con header personalizzato
                Section(header: sectionHeader(for: category)) {
                    // Campo di testo per aggiungere nuovo item
                    if addingToCategoryId == category.id {
                        TextField("Type something here...", text: $newItemText)
                            .focused($isTextFieldFocused)
                            .padding(.vertical, 8)
                            .font(.title2)
                            .onSubmit {
                                // Quando l'utente preme invio, salva il nuovo item
                                saveNewItem(to: category.id)
                            }
                    }
                    
                    // Mostra tutti gli items che appartengono a questa categoria
                    ForEach(listViewModel.items(for: category.id)) { item in
                        if editingItemId == item.id {
                            // Modalità editing item
                            HStack {
                                // Icona di completamento, checkmark (non modificabile durante editing)
                                Image(systemName: item.isCompleted ? "checkmark.circle" : "circle")
                                    .foregroundColor(item.isCompleted ? .green : .red)
                                // TextField per modificare il testo dell'item
                                TextField("Edit item", text: $editingText)
                                    .focused($isEditFieldFocused)
                                    .font(.title2)
                                    .onSubmit {
                                        // Quando l'utente preme invio, salva le modifiche
                                        saveEditedItem(item: item)
                                    }
                            }
                            .padding(.vertical, 8)
                        } else {
                            // Modalità normale
                            ListRowView(item: item)
                            // Tap singolo: toggle completamento
                                .onTapGesture {
                                    withAnimation(.linear) {
                                        listViewModel.updateItem(item: item)
                                    }
                                }
                            // Doppio tap: entra in modalità editing
                                .onTapGesture(count: 2) {
                                    startEditingItem(item: item)
                                }
                        }
                    }
                    // Swipe per eliminare items
                    .onDelete { indexSet in
                        deleteItems(at: indexSet, in: category.id)
                    }
                    .onMove { from, to in
                        moveItems(from: from, to: to, in: category.id)
                    }
                }
            }
        }
        .listStyle(InsetGroupedListStyle())
        .navigationTitle(isEditingTitle ? "" : listTitle)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            //Titolo centrale modificabile
            ToolbarItem(placement: .principal) {
                if isEditingTitle {
                    // Modalità editing: mostra TextField
                    TextField("Title", text: $listTitle)
                        .focused($isTitleFieldFocused)
                        .font(.title2)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                        .onSubmit {
                            saveTitle()
                        }
                } else {
                    // Modalità normale: mostra testo cliccabile
                    Text(listTitle)
                        .font(.title2)
                        .fontWeight(.bold)
                        .onTapGesture {
                            // Tap per iniziare a modificare il titolo
                            startEditingTitle()
                        }
                }
            }
            // Mostra il bottone "Done" quando si sta modificando qualcosa
            if addingToCategoryId != nil || editingItemId != nil || isEditingTitle || editingCategoryId != nil {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        // Salva in base a cosa si sta modificando
                        if isEditingTitle {
                            saveTitle()
                        } else if let categoryId = editingCategoryId,
                                  let category = listViewModel.categories.first(where: { $0.id == categoryId }) {
                            saveEditedCategory(category: category)
                        } else if let categoryId = addingToCategoryId {
                            saveNewItem(to: categoryId)
                        } else if let editingId = editingItemId,
                                  let item = listViewModel.items.first(where: { $0.id == editingId }) {
                            saveEditedItem(item: item)
                        }
                    }
                }
            }
        }
    }
    
    // Crea l'header personalizzato per ogni sezione (categoria)
    // Contiene il titolo della categoria (modificabile) e il bottone + per aggiungere items
    func sectionHeader(for category: CategoryModel) -> some View {
        HStack {
            //Titolo categoria (modificabile con tap)
            if editingCategoryId == category.id {
                // Modalità editing categoria
                TextField("Category name", text: $editingCategoryText)
                    .focused($isCategoryFieldFocused)
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                    .onSubmit {
                        saveEditedCategory(category: category)
                    }
            } else {
                // Modalità normale: testo cliccabile
                Text(category.title)
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                    .onTapGesture {
                        // Tap per iniziare a modificare il titolo della categoria
                        startEditingCategory(category: category)
                    }
            }
            
            Spacer()
            
            // Bottone + per aggiungere item
            // Mostra il bottone solo se non si sta già modificando qualcos'altro
            if addingToCategoryId == nil && editingItemId == nil && !isEditingTitle && editingCategoryId == nil {
                Button(action: {
                    withAnimation {
                        // Attiva la modalità "aggiungi item" per questa categoria
                        addingToCategoryId = category.id
                        newItemText = ""
                        isTextFieldFocused = true
                    }
                }) {
                    Image(systemName: "plus.circle.fill")
                        .foregroundColor(.accentColor)
                        .font(.title3)
                }
                .buttonStyle(BorderlessButtonStyle()) // Evita che cliccare il bottone selezioni la row
            }
        }
    }
    
    // Add New Item Functions
    // Salva il nuovo item nella categoria specificata
    func saveNewItem(to categoryId: String) {
        // Validazione: il testo deve essere non vuoto e almeno 2 caratteri
        guard !newItemText.isEmpty && newItemText.count >= 2 else {
            // Se non valido, chiudi semplicemente il TextField
            withAnimation {
                addingToCategoryId = nil
                isTextFieldFocused = false
                newItemText = ""
            }
            return
        }
        
        // Aggiungi l'item al ViewModel
        listViewModel.addItem(title: newItemText, categoryId: categoryId)
        
        // Reset dello stato
        withAnimation {
            addingToCategoryId = nil
            isTextFieldFocused = false
            newItemText = ""
        }
    }
    
    // Edit Item Functions
    // Inizia la modalità editing per un item specifico
    func startEditingItem(item: ItemModel) {
        withAnimation {
            editingItemId = item.id
            editingText = item.title
            isEditFieldFocused = true
        }
    }
    
    // Salva le modifiche a un item
    func saveEditedItem(item: ItemModel) {
        // Validazione: il testo deve essere non vuoto e almeno 2 caratteri
        guard !editingText.isEmpty && editingText.count >= 2 else {
            // Se non valido, annulla semplicemente le modifiche
            withAnimation {
                editingItemId = nil
                editingText = ""
                isEditFieldFocused = false
            }
            return
        }
        
        // Salva le modifiche nel ViewModel
        listViewModel.editItem(item: item, newTitle: editingText)
        
        // Reset dello stato
        withAnimation {
            editingItemId = nil
            editingText = ""
            isEditFieldFocused = false
        }
    }
    
    // Delete Items Function
    // Elimina gli items selezionati da una categoria
    func deleteItems(at offsets: IndexSet, in categoryId: String) {
        let itemsInCategory = listViewModel.items(for: categoryId)
        let itemsToDelete = offsets.map { itemsInCategory[$0] }
        
        // Elimina ogni item dall'array principale
        for item in itemsToDelete {
            if let index = listViewModel.items.firstIndex(where: { $0.id == item.id }) {
                listViewModel.items.remove(at: index)
            }
        }
    }
    //Spostare gli item
    func moveItems(from source: IndexSet, to destination: Int, in categoryId: String) {
        listViewModel.moveItem(from: source, to: destination, in: categoryId)
    }
    
    // Edit Title Functions
    // Inizia la modalità editing per il titolo principale
    func startEditingTitle() {
        withAnimation {
            isEditingTitle = true
            isTitleFieldFocused = true
        }
    }
    
    // Salva il nuovo titolo principale
    func saveTitle() {
        // Se il titolo è vuoto, ripristina quello di default
        guard !listTitle.isEmpty else {
            listTitle = "ToDo List📝"
            withAnimation {
                isEditingTitle = false
                isTitleFieldFocused = false
            }
            return
        }
        
        // Salva il nuovo titolo
        withAnimation {
            isEditingTitle = false
            isTitleFieldFocused = false
        }
    }
    
    // Edit Category Functions
    // Inizia la modalità editing per il titolo di una categoria
    func startEditingCategory(category: CategoryModel) {
        withAnimation {
            editingCategoryId = category.id
            editingCategoryText = category.title
            isCategoryFieldFocused = true
        }
    }
    
    // Salva le modifiche al titolo della categoria
    func saveEditedCategory(category: CategoryModel) {
        // Validazione: il testo non può essere vuoto
        guard !editingCategoryText.isEmpty else {
            // Se vuoto, annulla le modifiche
            withAnimation {
                editingCategoryId = nil
                editingCategoryText = ""
                isCategoryFieldFocused = false
            }
            return
        }
        
        // Salva il nuovo titolo nel ViewModel
        listViewModel.updateCategory(category: category, newTitle: editingCategoryText)
        
        // Reset dello stato
        withAnimation {
            editingCategoryId = nil
            editingCategoryText = ""
            isCategoryFieldFocused = false
        }
    }
}

#Preview {
    NavigationStack {
        ListView()
    }
    .environmentObject(ListViewModel())
}
