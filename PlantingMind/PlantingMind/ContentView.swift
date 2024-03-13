//
//  ContentView.swift
//  PlantingMind
//
//  Created by 최은주 on 1/3/24.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.managedObjectContext) var context
    
    var body: some View {
        VStack {
            CalendarView(calendarViewModel: CalendarViewModel(today: Date(), context: context))
        }
        .padding()
    }
}

#Preview {
    ContentView()
        .environment(\.managedObjectContext, CoreDataStack(.inMemory).persistentContainer.viewContext)
}
