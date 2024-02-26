//
//  MoodRecordView.swift
//  PlantingMind
//
//  Created by 최은주 on 1/26/24.
//

import SwiftUI

struct MoodRecordView: View {
    @Environment(\.dismiss) var dismiss
    @State var text = ""
    
    
    var body: some View {
        NavigationStack() {
            HStack {
                VStack(spacing: 20) {
                    Text("오늘의 기분은요?")
                        .font(.title2)
                        .bold()
                        .padding()
                    
                    HStack(spacing: 20) {
                        Button(action: {}, label: {
                            Image("nice", label: Text("nice"))
                        })
                        Button(action: {}, label: {
                            Image("good", label: Text("good"))
                        })
                        Button(action: {}, label: {
                            Image("normal", label: Text("normal"))
                        })
                        Button(action: {}, label: {
                            Image("notBad", label: Text("not bad"))
                        })
                        Button(action: {}, label: {
                            Image("bad", label: Text("bad"))
                        })
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
