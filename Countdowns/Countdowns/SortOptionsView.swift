//
//  SortOptionsView.swift
//  Countdowns
//
//  Created by Giulia Piscitelli on 17/12/24.
//

import SwiftUI
struct SortOptionsView: View {
    @Binding var sortBy: String
    var onSortChanged: () -> Void

    var body: some View {
        NavigationView {
            VStack {
                Button("Sort by Name") {
                    sortBy = "Name"
                    onSortChanged()  // Applica l'ordinamento
                }
                .padding()
                .foregroundColor(.blue)

                Button("Sort by Date") {
                    sortBy = "Date"
                    onSortChanged()  // Applica l'ordinamento
                }
                .padding()
                .foregroundColor(.blue)

                Spacer()
            }
            .navigationTitle("Sort Options")
            .navigationBarItems(trailing: Button("Done") {
                // Chiude la finestra quando si è fatto
                onSortChanged()  // Applica l'ordinamento prima di chiudere
            })
        }
    }
}
