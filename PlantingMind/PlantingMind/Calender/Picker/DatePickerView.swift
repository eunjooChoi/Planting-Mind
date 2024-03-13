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
    
    init(selectedDate: Binding<Date>) {
        self._selectedDate = selectedDate
        self._pickedDate = State(initialValue: selectedDate.wrappedValue)
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
                            MonthPickerView(pickedDate: $pickedDate)
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
                selectedDate = pickedDate
                dismiss()
            } label: {
                Text("done")
            }
        }
        .padding([.top, .trailing, .leading])
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
    DatePickerView(selectedDate: .constant(Date()))
}
