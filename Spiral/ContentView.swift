//
//  ContentView.swift
//  Spiral
//
//  Created by Robert Wiscount on 11/4/25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    var body: some View {
        HomeView()
    }
}

#Preview {
    ContentView()
        .modelContainer(for: [AppSettings.self, ScrollSession.self, UserStats.self], inMemory: true)
}
