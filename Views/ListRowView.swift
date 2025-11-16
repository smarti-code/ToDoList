//
//  ListRowView.swift
//  ToDoList
//
//  Created by Martina Maria Bruno on 07/11/25.
//

import SwiftUI

// View che rappresenta una singola riga nella lista dei task
// Mostra: icona di completamento + testo del task
// Questa è una view riutilizzabile e semplice, usata da ListView

struct ListRowView: View {
    
    // Item da visualizzare
    let item: ItemModel
    
    var body: some View {
            HStack {
                // Mostra un'icona diversa in base allo stato di completamento:
                // - checkmark.circle (✓) verde se completato
                // - circle (○) rosso se non completato
                Image(systemName: item.isCompleted ? "checkmark.circle" : "circle")
                    .foregroundColor(item.isCompleted ? .green : .red)
                
                // Visualizza il titolo dell'item
                Text(item.title)
                
                // Spinge tutto il contenuto verso sinistra
                Spacer ()
            }
            .font(.title3) // Dimensioni font
            .padding(.vertical, 8) // Padding verticale per spaziatura tra le righe
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    var item1 = ItemModel(title: "First item", isCompleted: false, categoryId: "today")
    var item2 = ItemModel(title: "Second item", isCompleted: true, categoryId: "tomorrow")
    
    Group {
        ListRowView(item: item1)
        ListRowView(item: item2)
    }
}
