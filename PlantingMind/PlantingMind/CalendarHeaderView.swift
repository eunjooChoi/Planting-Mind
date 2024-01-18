//
//  CalendarHeaderView.swift
//  PlantingMind
//
//  Created by 최은주 on 1/18/24.
//

import SwiftUI

struct CalendarHeaderView: View {
    var body: some View {
        HStack(spacing: 15, content: {
            Button(action: {
                //TODO: 이전달로 이동
            }, label: {
                Image(systemName: "chevron.left")
                    .font(.title)
                    .foregroundStyle(.black)
            })
            
            //TODO: 날짜 설정 로직 추가
            Text("2024. 01")
                .font(.title)
                .fontWeight(.bold)
            
            Button(action: {
                //TODO: 다음달로 이동
            }, label: {
                Image(systemName: "chevron.right")
                    .font(.title)
                    .foregroundStyle(.black)
            })
        })
        .padding(.bottom, 25)
    }
}

struct CalendarHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarHeaderView()
    }
}

