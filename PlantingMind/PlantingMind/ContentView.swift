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
        .padding([.horizontal, .top])
        .onAppear {
            UNUserNotificationCenter.current().setBadgeCount(0, withCompletionHandler: nil)
        }
    }
}

#Preview {
    ContentView()
        .environment(\.managedObjectContext, CoreDataStack(.inMemory).persistentContainer.viewContext)
}
