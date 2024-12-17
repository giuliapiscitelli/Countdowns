//
//  ContentView.swift
//  Countdowns
//
//  Created by Giulia Piscitelli on 17/12/24.
//

import SwiftUI

 struct ContentView: View {
    @State private var events: [Event] = []  // Lista degli eventi
    @State private var showAddEventView = false  // Per mostrare la vista di aggiunta o modifica
    @State private var selectedEvent: Event? = nil  // Evento selezionato per la modifica
    @State private var selectedCategoryFilter: String = "All"  // Categoria per il filtro
    @State private var isSortedByDate: Bool = false  // Variabile di stato per l'ordinamento degli eventi

    var body: some View {
        NavigationView {
            VStack {
              
                // Filtro per categoria
                Picker("Filter by category", selection: $selectedCategoryFilter) {
                    Text("All").tag("All")
                    Text("Personal").tag("Personal")
                    Text("Work").tag("Work")
                    Text("Important").tag("Important")
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()

                // Se la lista degli eventi è vuota, mostra il messaggio "Start a new countdown"
                if events.isEmpty {
                    Spacer()
                    Text("Start a new countdown!")
                        .font(.title)
                        .foregroundColor(.gray)
                        .padding()
                    Spacer()
                } else {
                    // Altrimenti, mostra la lista degli eventi filtrati
                    List {
                        ForEach(filteredEvents()) { event in
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(event.title)
                                        .font(.headline)
                                        .foregroundColor(.white)  // Testo bianco per contrasto con il colore di sfondo
                                }
                                .padding(.leading)

                                Spacer()

                                VStack(alignment: .trailing) {
                                    Text(timeRemaining(for: event))
                                        .font(.subheadline)
                                        .foregroundColor(.white)  // Testo bianco per contrasto con il colore di sfondo
                                }
                                .padding(.trailing)
                            }
                            .padding()
                            .background(eventColor(for: event))  // Applica il colore in base alla categoria
                            .cornerRadius(10)
                            .contentShape(Rectangle())
                            .onTapGesture {
                                selectedEvent = event
                                showAddEventView.toggle()
                            }
                        }
                        .onDelete(perform: deleteEvent)
                    }
                }
            }
            .navigationTitle("Countdowns")
            .navigationBarItems(
                leading: Button(action: {
                    // Alterna tra ordinamento cronologico e ordine originale
                    isSortedByDate.toggle()
                }) {
                    Image(systemName: "arrow.up.arrow.down")
                        .font(.system(size: 20))
                },
                trailing: Button(action: {
                    selectedEvent = nil
                    showAddEventView.toggle()
                }) {
                    Image(systemName: "plus")
                }
            )
            .sheet(isPresented: $showAddEventView) {
                AddEventView(events: $events, selectedEvent: $selectedEvent)
            }
        }
    }
    
    // Funzione per calcolare i giorni rimanenti
    func timeRemaining(for event: Event) -> String {
        let interval = event.date.timeIntervalSinceNow
        if interval <= 0 {
            return "Event Started!"
        }
        let days = Int(interval) / 86400  // Calcola i giorni (1 giorno = 86400 secondi)
        return "\(days) days left"
    }
    
    // Funzione per ottenere il colore in base alla categoria dell'evento
    func eventColor(for event: Event) -> Color {
        switch event.category {
        case "Work":
            return .blue
        case "Important":
            return .green
        case "Personal":
            return .orange
        default:
            return .gray
        }
    }
    
    // Funzione per filtrare gli eventi in base alla categoria selezionata
    func filteredEvents() -> [Event] {
        let filtered = events.filter { event in
            selectedCategoryFilter == "All" || event.category == selectedCategoryFilter
        }
        
        // Ordina gli eventi in base a isSortedByDate
        if isSortedByDate {
            return filtered.sorted { $0.date < $1.date }  // Ordinamento per data (cronologico)
        } else {
            return filtered  // Mantieni l'ordine originale
        }
    }
    
    // Funzione per eliminare un evento dalla lista
    func deleteEvent(at offsets: IndexSet) {
        events.remove(atOffsets: offsets)
    }
}




#Preview {
    ContentView()
}
