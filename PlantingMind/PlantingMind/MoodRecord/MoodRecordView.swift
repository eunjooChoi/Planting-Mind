//
//  MoodRecordView.swift
//  PlantingMind
//
//  Created by 최은주 on 1/26/24.
//

import SwiftUI

struct MoodRecordView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.colorScheme) var colorScheme
    @FocusState var isFocused: Bool
    
    @ObservedObject var viewModel: MoodRecordViewModel
    @State var isDialogPresent: Bool = false
    @State var isDeleteAlertPresent: Bool = false
    
    var body: some View {
        NavigationStack() {
            HStack {
                VStack(spacing: 20) {
                    Text("\(viewModel.dateFormatter.string(from: viewModel.date))")
                        .italic()
                        .padding([.bottom], -5)
                    
                    Text("mood_title")
                        .font(.title2)
                        .bold()
                        .padding(.horizontal)
                        .accessibilityIdentifier(AccessibilityIdentifiers.moodTitleText.rawValue)
                    
                    moodSelectView
                    
                    Spacer()
                    
                    Text("mood_reason")
                        .font(.title2)
                        .bold()
                    
                    ZStack {
                        textEditorView
                        
                        if viewModel.reason.isEmpty {
                            emptyStringView
                                .onTapGesture(perform: {
                                    isFocused = true
                                })
                        }
                        
                        limitStringView
                    }
                    
                    if isFocused == false, viewModel.isFirstRecord == false {
                        Button {
                            isDeleteAlertPresent.toggle()
                        } label: {
                            Image(systemName: "trash.fill")
                                .foregroundStyle(.white)
                                .padding()
                                .padding(.horizontal, 10)
                                .background(.red)
                                .clipShape(Capsule(style: .continuous))
                        }
                        .accessibilityIdentifier(AccessibilityIdentifiers.removeButton.rawValue)
                    }
                    
                    Spacer()
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: {
                        if viewModel.needCancelAlert() {
                            isDialogPresent = true
                        } else {
                            dismiss()
                        }
                    }, label: {
                        Text("cancel")
                    })
                    .confirmationDialog("record_cancel_alert", isPresented: $isDialogPresent, titleVisibility: .visible) {
                        Button("confirm", role: .destructive) {
                            dismiss()
                        }
                        .accessibilityIdentifier(AccessibilityIdentifiers.confirmButton.rawValue)
                    }
                    .accessibilityIdentifier(AccessibilityIdentifiers.cancelButton.rawValue)
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        viewModel.save()
                        dismiss()
                    }, label: {
                        Text("save")
                    })
                    .accessibilityIdentifier(AccessibilityIdentifiers.saveButton.rawValue)
                }
            }
            .foregroundStyle(Color.Custom.general)
        }
        .alert("delete_alert", isPresented: $isDeleteAlertPresent, actions: {
            Button("cancel", role: .cancel) { }
            Button("ok", role: .destructive) {
                viewModel.deleteRecord(completionHandler: {result in
                    guard result else { return }
                    dismiss()
                })
            }
            .accessibilityIdentifier(AccessibilityIdentifiers.confirmButton.rawValue)
        })
        .alert("error_description", isPresented: $viewModel.showErrorAlert) {
            Button("ok", role: .cancel) { }
        }
    }
    
    var moodSelectView: some View {
        HStack(spacing: 20) {
            ForEach(Mood.allCases, id: \.self) { mood in
                Button(action: {
                    viewModel.mood = mood
                }, label: {
                    Image("\(mood.rawValue)", label: Text("\(mood.rawValue)"))
                })
                .buttonStyle(PlainButtonStyle())
                .overlay {
                    if viewModel.mood == mood {
                        Circle()
                            .stroke(viewModel.mood.color.opacity(0.8), lineWidth: 3)
                            .foregroundStyle(.clear)
                            .frame(width: 60, height: 60)
                    }
                }
                .accessibilityIdentifier(mood.rawValue)
            }
        }
    }
    
    var textEditorView: some View {
        TextEditor(text: $viewModel.reason)
            .autocorrectionDisabled(true)
            .opacity(0.8)
            .background(Color.Custom.line)
            .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
            .padding(.horizontal)
            .focused($isFocused)
            .onChange(of: viewModel.reason) { _ in
                if viewModel.reason.count > 100 {
                    viewModel.reason.removeLast()
                }
            }
            .accessibilityIdentifier(AccessibilityIdentifiers.moodReasonTextEditor.rawValue)
    }
    
    var emptyStringView: some View {
        VStack {
            HStack {
                Text("fill_in_the_blank")
                    .foregroundStyle(Color.Custom.general.opacity(0.6))
                    .padding(.top, 9)
                    .padding(.leading, 22)
                
                Spacer()
            }
            Spacer()
        }
    }
    
    var limitStringView: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                Text("\(viewModel.reason.count) / 100")
                    .foregroundStyle(Color.Custom.line.opacity(0.6))
                    .padding(.bottom, 10)
                    .padding(.trailing, 28)
                
            }
        }
    }
}

#Preview {
    MoodRecordView(viewModel: MoodRecordViewModel(context: CoreDataStack(.inMemory).persistentContainer.viewContext, calendarModel: CalendarModel(year: 2024, month: 2, day: 24, isToday: false), moodRecord: nil))
}
