//
//  Event.swift
//  Countdowns
//
//  Created by Giulia Piscitelli on 17/12/24.
//

import SwiftUI

struct Event: Identifiable {
    let id = UUID()  // Identificatore unico per ogni evento
    var title: String  // Titolo dell'evento
    var date: Date  // Data e ora dell'evento
    var category: String  // Categoria dell'evento
}
