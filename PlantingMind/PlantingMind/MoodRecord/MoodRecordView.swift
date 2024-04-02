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
    
    @ObservedObject var viewModel: MoodRecordViewModel
    
    var body: some View {
        NavigationStack() {
            HStack {
                VStack(spacing: 20) {
                    Text("\(viewModel.dateFormatter.string(from: viewModel.date))")
                        .italic()
                    
                    Text("mood_title")
                        .font(.title2)
                        .bold()
                        .padding(.horizontal)
                    
                    moodSelectView
                    
                    Spacer()
                    
                    Text("mood_reason")
                        .font(.title2)
                        .bold()
                    
                    ZStack {
                        textEditorView
                        
                        if viewModel.reason.isEmpty {
                            emptyStringView
                        }
                        
                        limitStringView
                    }
                    
                    Spacer()
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: {
                        dismiss()
                    }, label: {
                        Text("cancel")
                    })
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        viewModel.save()
                        dismiss()
                    }, label: {
                        Text("save")
                    })
                }
            }
            .foregroundStyle(Color.Custom.general)
        }
    }
    
    var moodSelectView: some View {
        HStack(spacing: 20) {
            ForEach(Mood.allCases, id: \.self) {mood in
                Button(action: {
                    viewModel.mood = mood
                }, label: {
                    Image("\(mood.rawValue)", label: Text("\(mood.rawValue)"))
                })
                .buttonStyle(PlainButtonStyle())
                .overlay {
                    if viewModel.mood == mood {
                        Circle()
                            .stroke(Color.Custom.select, lineWidth: 2)
                            .foregroundStyle(.clear)
                            .frame(width: 60, height: 60)
                    }
                }
            }
        }
    }
    
    var textEditorView: some View {
        TextEditor(text: $viewModel.reason)
            .autocorrectionDisabled(true)
            .background(Color.Custom.line)
            .opacity(0.8)
            .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
            .padding(.horizontal)
            .onChange(of: viewModel.reason) { _ in
                if viewModel.reason.count > 100 {
                    viewModel.reason.removeLast()
                }
            }
    }
    
    var emptyStringView: some View {
        VStack {
            HStack {
                Text("fill_in_the_blank")
                    .foregroundStyle(Color.Custom.line)
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
                Text("text_limit".localized(with: [viewModel.reason.count]))
                    .foregroundStyle(Color.Custom.line)
                    .padding(.bottom, 10)
                    .padding(.trailing, 28)
                
            }
        }
    }
}

#Preview {
    MoodRecordView(viewModel: MoodRecordViewModel(context: CoreDataStack(.inMemory).persistentContainer.viewContext, calendarModel: CalendarModel(year: 2024, month: 2, day: 24, isToday: false), moodRecord: nil))
}
