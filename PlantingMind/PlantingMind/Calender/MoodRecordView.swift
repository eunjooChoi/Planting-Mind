//
//  MoodRecordView.swift
//  PlantingMind
//
//  Created by 최은주 on 1/26/24.
//

import SwiftUI

enum Mood: String, CaseIterable {
    case nice
    case good
    case normal
    case notBad
    case bad
}

struct MoodRecordView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.colorScheme) var colorScheme
    @State var text = ""
    @State var selectedMood: Mood = .normal
    
    var body: some View {
        NavigationStack() {
            HStack {
                VStack(spacing: 20) {
                    Text("오늘의 기분은요?")
                        .font(.title2)
                        .bold()
                        .padding()
                    
                    HStack(spacing: 20) {
                        ForEach(Mood.allCases, id: \.self) {mood in
                            Button(action: {
                                selectedMood = mood
                            }, label: {
                                Image("\(mood.rawValue)", label: Text("\(mood.rawValue)"))
                            })
                            .buttonStyle(PlainButtonStyle())
                            .overlay {
                                if selectedMood == mood {
                                    let color: Color = colorScheme == .dark ? .yellow : .orange
                                    Circle()
                                        .stroke(color, lineWidth: 4)
                                        .foregroundStyle(.clear)
                                        .frame(width: 60, height: 60)
                                }
                            }
                        }
                    }
                    
                    Spacer()
                    
                    Text("왜 그렇게 느꼈나요?")
                        .font(.title2)
                        .bold()
                    
                    ZStack {
                        TextEditor(text: $text)
                            .autocorrectionDisabled(true)
                            .background(Color.Custom.line)
                            .opacity(0.8)
                            .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                            .padding(.horizontal)
                            .onChange(of: text) { _ in
                                if text.count > 100 {
                                    text.removeLast()
                                }
                            }
                        
                        if text.isEmpty {
                            VStack {
                                HStack {
                                    Text("내용을 입력하세요.")
                                        .foregroundStyle(Color.Custom.line)
                                        .padding(.top, 9)
                                        .padding(.leading, 22)
                                    
                                    Spacer()
                                }
                                Spacer()
                            }
                        }
                        
                        VStack {
                            Spacer()
                            HStack {
                                Spacer()
                                Text("\(text.count) / 100")
                                    .foregroundStyle(Color.Custom.line)
                                    .padding(.bottom, 10)
                                    .padding(.trailing, 28)
                                
                            }
                        }
                    }
                    
                    Spacer()
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: {
                        dismiss()
                    }, label: {
                        Text("취소")
                    })
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        dismiss()
                    }, label: {
                        Text("저장")
                    })
                }
            }
            .foregroundStyle(Color.Custom.general)
        }
        
        
    }
}

#Preview {
    MoodRecordView()
}
