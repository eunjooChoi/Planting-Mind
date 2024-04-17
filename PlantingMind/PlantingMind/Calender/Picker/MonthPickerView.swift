//
//  MonthPickerView.swift
//  PlantingMind
//
//  Created by 최은주 on 3/12/24.
//

import SwiftUI

struct MonthPickerView: View {
    @Environment(\.dismiss) var dismiss
    
    @Binding var selectedDate: Date
    @StateObject var viewModel: MonthPickerViewModel
    
    init(selectedDate: Binding<Date>, dateRange: DateRange) {
        self._selectedDate = selectedDate
        self._viewModel = StateObject(wrappedValue: MonthPickerViewModel(dateRange: dateRange, selectedDate: selectedDate.wrappedValue))
    }
    
    var body: some View {
        ZStack {
            Color.gray.opacity(0.4)
                .ignoresSafeArea()
            
            VStack {
                RoundedRectangle(cornerRadius: 10.0)
                    .foregroundStyle(Color.Custom.point)
                    .overlay {
                        VStack {
                            toolbar
                            monthPickerView
                        }
                    }
                    .frame(height: 250)
                    .padding()
            }
        }
        .background(ClearBackground())
        .onDisappear(perform: {
            UIView.setAnimationsEnabled(true)
        })
    }
    
    var toolbar: some View {
        HStack {
            Button {
                dismiss()
            } label: {
                Text("cancel")
            }
            
            Spacer()
            
            Text("change_month")
                .font(.title3)
                .bold()
            
            Spacer()
            
            Button {
                selectedDate = viewModel.pickedMonth()
                dismiss()
            } label: {
                Text("done")
            }
            .accessibilityIdentifier(AccessibilityIdentifiers.doneButton.rawValue)
        }
        .padding([.top, .trailing, .leading])
    }
    
    var monthPickerView: some View {
        HStack(spacing: -5) {
            Picker("", selection: $viewModel.selectedYear) {
                ForEach(viewModel.years, id: \.self) { year in
                    Text(verbatim: "\(year)")
                        .bold()
                }
            }
            .labelsHidden()
            .frame(width: 100, height: 200)
            .accessibilityIdentifier(AccessibilityIdentifiers.yearPicker.rawValue)
            
            Text(". ")
                .font(.title)
                .bold()
            
            Picker("", selection: $viewModel.selectedMonth) {
                ForEach(viewModel.months, id: \.self) { month in
                    Text(String(format: "%02d", month))
                        .bold()
                }
            }
            .labelsHidden()
            .frame(width: 70, height: 200)
            .accessibilityIdentifier(AccessibilityIdentifiers.monthPicker.rawValue)
        }
        .pickerStyle(.wheel)
        .compositingGroup()
        .clipped()
    }
}

fileprivate struct ClearBackground: UIViewRepresentable {
    public func makeUIView(context: Context) -> UIView {
        let view = ClearBackgroundView()
        DispatchQueue.main.async {
            view.superview?.superview?.backgroundColor = .clear
        }
        return view
    }
    
    public func updateUIView(_ uiView: UIView, context: Context) {}
}

fileprivate class ClearBackgroundView: UIView {
    open override func layoutSubviews() {
        guard let parentView = superview?.superview else {
            return
        }
        parentView.backgroundColor = .clear
    }
}

#Preview {
    MonthPickerView(selectedDate: .constant(Date()), 
                    dateRange: DateRange(startDate: Date(), endDate: Date()))
}
