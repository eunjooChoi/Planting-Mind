//
//  ContentView.swift
//  PlantingMind
//
//  Created by 최은주 on 1/3/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            CalendarView(calendarViewModel: CalendarViewModel(today: Date()))
        }
        .padding()
    }
}


struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
      ContentView()
  }
}
