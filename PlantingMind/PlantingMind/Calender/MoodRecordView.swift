//
//  MoodRecordView.swift
//  PlantingMind
//
//  Created by 최은주 on 1/26/24.
//

import SwiftUI

struct MoodRecordView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack() {
            HStack {
                VStack {
                    //                Button(action: {
                    //                    dismiss()
                    //                }, label: {
                    //                    Image(systemName: "xmark")
                    //                })
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: {
                        dismiss()
                    }, label: {
                        Image(systemName: "xmark")
                    })
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        dismiss()
                    }, label: {
                        Image(systemName: "checkmark")
                    })
                }
            }
            .foregroundStyle(.black)
            .fontWeight(.bold)
        }
        
        
    }
}

#Preview {
      MoodRecordView()
}
