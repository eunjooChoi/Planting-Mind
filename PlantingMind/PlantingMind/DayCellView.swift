//
//  DayCellView.swift
//  PlantingMind
//
//  Created by 최은주 on 1/19/24.
//

import SwiftUI

struct DayCellView: View {
    var day: String
    
    var body: some View {
        RoundedRectangle(cornerRadius: 10)
            .fill(.yellow)
            .overlay {
                Text(day)
                    .fontWeight(.semibold)
            }
            .frame(height: 50)
    }
}

struct DayCellView_Previews: PreviewProvider {
  static var previews: some View {
      DayCellView(day: "1")
  }
}
