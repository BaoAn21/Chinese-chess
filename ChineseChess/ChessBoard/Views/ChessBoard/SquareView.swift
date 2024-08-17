//
//  SquareView.swift
//  ChineseChess
//
//  Created by Trần Ân on 19/7/24.
//

import SwiftUI



struct SquareView: View {
    var square: Square
    var width: Double = 0
    var height: Double = 0
    var color: Color {
        if square.isChosen {
            return .gray
        } else if square.recentMoveFrom {
            return .orange
        } else if square.recentMoveTo {
            return .yellow
        } else {
            return .clear
        }
    }
    
    var body: some View {
        Rectangle()
            .frame(width: width,height: height)
            .contentShape(Rectangle())
            .foregroundStyle(color)
            .opacity(0.5)
    }
}

#Preview {
    SquareView(square: Square(id: 0, isChosen: true), width: 10, height: 10)
}
