//
//  ContentView.swift
//  PlantingMind
//
//  Created by 최은주 on 1/3/24.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.managedObjectContext) var context
    @Environment(\.scenePhase) var scenePhase
    
    var body: some View {
        VStack {
            CalendarView(calendarViewModel: CalendarViewModel(today: Date(), context: context))
        }
        .padding([.horizontal, .top])
        .onChange(of: scenePhase, perform: { newValue in
            if newValue == .active {
                UNUserNotificationCenter.current().setBadgeCount(0, withCompletionHandler: nil)
                NotificationCenter.default.post(name: .activeNotification,object: nil)
            }
        })
    }
}

#Preview {
    ContentView()
        .environment(\.managedObjectContext, CoreDataStack(.inMemory).persistentContainer.viewContext)
}
