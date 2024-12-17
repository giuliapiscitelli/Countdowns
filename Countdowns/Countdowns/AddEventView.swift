//
//  AddEventView.swift
//  Countdowns
//
//  Created by Giulia Piscitelli on 17/12/24.
//

import SwiftUI
struct AddEventView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var events: [Event]  // Lista degli eventi
    @Binding var selectedEvent: Event?  // Evento selezionato per la modifica
    @State private var title = ""
    @State private var selectedDate = Date()
    @State private var selectedCategory: String = "Personal"  // Categoria predefinita
    @State private var showDeleteConfirmation = false  // Stato per mostrare la conferma di eliminazione
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Event Information")) {
                    TextField("Event Title", text: $title)
                }
                
                Section(header: Text("Event Date")) {
                    DatePicker("Select Date", selection: $selectedDate, displayedComponents: .date)
                }
                
                Section(header: Text("Select Category")) {
                    Picker("Category", selection: $selectedCategory) {
                        Text("Personal").tag("Personal")
                        Text("Work").tag("Work")
                        Text("Important").tag("Important")
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                
                // Bottone per salvare l'evento
                Button("Save Event") {
                    if let selectedEvent = selectedEvent {
                        // Modifica evento esistente
                        updateEvent(event: selectedEvent)
                    } else {
                        // Aggiungi nuovo evento
                        addEvent()
                    }
                    dismiss()  // Chiudi la vista
                }
                
                // Bottone per eliminare l'evento (visibile solo in modalità modifica)
                if selectedEvent != nil {
                    Button("Delete Event") {
                        showDeleteConfirmation.toggle()  // Mostra il dialogo di conferma
                    }
                    .foregroundColor(.red)
                }
            }
            .navigationTitle(selectedEvent == nil ? "Add Event" : "Edit Event")
            .onAppear {
                if let selectedEvent = selectedEvent {
                    // Pre-compila con i dati dell'evento selezionato
                    title = selectedEvent.title
                    selectedDate = selectedEvent.date
                    selectedCategory = selectedEvent.category  // Pre-compila anche la categoria
                }
            }
            .alert(isPresented: $showDeleteConfirmation) {
                // Finestra di conferma per l'eliminazione
                Alert(
                    title: Text("Do you want to delete this event?"),
                    primaryButton: .destructive(Text("Delete")) {
                        deleteEvent()  // Elimina l'evento
                        dismiss()  // Chiudi la vista dopo l'eliminazione
                    },
                    secondaryButton: .cancel()
                )
            }
        }
    }
    
    // Funzione per aggiungere un nuovo evento
    func addEvent() {
        let newEvent = Event(title: title, date: selectedDate, category: selectedCategory)
        events.append(newEvent)  // Aggiungi l'evento alla lista
    }
    
    // Funzione per aggiornare un evento esistente
    func updateEvent(event: Event) {
        if let index = events.firstIndex(where: { $0.id == event.id }) {
            events[index].title = title
            events[index].date = selectedDate
            events[index].category = selectedCategory  // Aggiorna la categoria
        }
    }
    
    // Funzione per eliminare l'evento
    func deleteEvent() {
        if let selectedEvent = selectedEvent,
           let index = events.firstIndex(where: { $0.id == selectedEvent.id }) {
            events.remove(at: index)  // Rimuove l'evento dalla lista
        }
    }
}
