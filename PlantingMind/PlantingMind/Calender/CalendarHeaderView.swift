//
//  CalendarHeaderView.swift
//  PlantingMind
//
//  Created by 최은주 on 1/18/24.
//

import SwiftUI

struct CalendarHeaderView: View {
    @EnvironmentObject var calendarViewModel: CalendarViewModel
    @State var showPicker: Bool = false
    @State var showSettings: Bool = false
    
    var body: some View {
        VStack {
            header
            weekday
        }
    }
    
    var header: some View {
        HStack(spacing: 15, content: {
            Button(action: {
                calendarViewModel.addingMonth(value: -1)
            }, label: {
                Image(systemName: "chevron.left")
                    .font(.title)
            })
            .accessibilityIdentifier(AccessibilityIdentifiers.previousMonthButton.rawValue)
            
            Button {
                UIView.setAnimationsEnabled(false)
                showPicker.toggle()
            } label: {
                Text(calendarViewModel.selectedDate, formatter: calendarViewModel.dateFormatter)
                    .font(.title)
                    .fontWeight(.bold)
            }
            .buttonStyle(.plain)
            .fullScreenCover(isPresented: $showPicker, content: {
                MonthPickerView(selectedDate: $calendarViewModel.selectedDate,
                                dateRange: DateRange(startDate: calendarViewModel.startMonth!, endDate: calendarViewModel.today))
            })
            .accessibilityIdentifier(AccessibilityIdentifiers.monthPickerButton.rawValue)
            
            Button(action: {
                calendarViewModel.addingMonth(value: 1)
            }, label: {
                Image(systemName: "chevron.right")
                    .font(.title)
            })
            .accessibilityIdentifier(AccessibilityIdentifiers.nextMonthButton.rawValue)
            
            Spacer()
            
            Button {
                showSettings.toggle()
            } label: {
                Image(systemName: "gearshape")
                    .font(.title)
            }
            .fullScreenCover(isPresented: $showSettings, content: {
                SettingsView(viewModel: SettingsViewModel(context: calendarViewModel.context, languageCode: Locale.current.language.languageCode?.identifier))
            })
            .accessibilityIdentifier(AccessibilityIdentifiers.settingsButton.rawValue)
        })
        .foregroundStyle(Color.Custom.general)
        .padding(.bottom, 25)
    }
    
    var weekday: some View {
        VStack {
            HStack {
                ForEach(calendarViewModel.weekdaySymbols, id: \.self) { symbol in
                    Text(symbol)
                        .frame(maxWidth: .infinity)
                        .fontWeight(.black)
                        .foregroundStyle(Color.Custom.general)
                }
                .padding(.bottom, 6)
            }
            
            Divider()
                .overlay(Color.Custom.line)
        }
    }
}

#Preview {
    CalendarHeaderView()
        .environmentObject(CalendarViewModel(today: Date(), context: CoreDataStack(.inMemory).persistentContainer.viewContext))
}

