//
//  DatePickerView.swift
//  PlantingMind
//
//  Created by 최은주 on 3/12/24.
//

import SwiftUI

struct DatePickerView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var selectedDate: Date
    @State var pickedDate: Date
    
    init(selectedDate: Binding<Date>, pickedDate: Date) {
        self._selectedDate = selectedDate
        self._pickedDate = State(initialValue: selectedDate.wrappedValue)
    }
    
    var dateRange: ClosedRange<Date> {
        let min = Calendar.current.date(from: DateComponents(year: 2024, month: 1, day: 1))!
        let max = Date()
        return min...max
    }
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.4)
                .ignoresSafeArea()
            
            VStack {
                Spacer()
                VStack {
                    HStack {
                        Button {
                            dismiss()
                        } label: {
                            Text("cancel")
                        }
                        
                        Spacer()
                        
                        Button {
                            selectedDate = pickedDate
                            dismiss()
                        } label: {
                            Text("done")
                        }
                    }
                    .padding([.top, .trailing, .leading])
                    
                    DatePicker("select date", selection: $pickedDate,
                               in: dateRange,
                               displayedComponents: .date)
                        .datePickerStyle(.wheel)
                        .labelsHidden()
                }
                .background(Color.Custom.point)
            }
        }
        .background(ClearBackground())
        .onDisappear(perform: {
            UIView.setAnimationsEnabled(true)
        })
    }
}

struct ClearBackground: UIViewRepresentable {
    public func makeUIView(context: Context) -> UIView {
        let view = ClearBackgroundView()
        DispatchQueue.main.async {
            view.superview?.superview?.backgroundColor = .clear
        }
        return view
    }
    
    public func updateUIView(_ uiView: UIView, context: Context) {}
}

class ClearBackgroundView: UIView {
    open override func layoutSubviews() {
        guard let parentView = superview?.superview else {
            return
        }
        parentView.backgroundColor = .clear
    }
}

#Preview {
    DatePickerView(selectedDate: .constant(Date()), pickedDate: Date())
}
