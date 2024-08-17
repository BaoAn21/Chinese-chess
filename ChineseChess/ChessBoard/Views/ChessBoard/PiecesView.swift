//
//  PiecesView.swift
//  ChineseChess
//
//  Created by Trần Ân on 22/7/24.
//

import SwiftUI

struct PiecesView: View {
    var piece: Piece
    var size: (Double,Double)
    var w: Double
    var h: Double
    let piecePos: (Double,Double)
    var rotation = false
    
    init(piece: Piece, size: (Double, Double), w: Double, h: Double, rotation: Bool) {
        self.rotation = rotation
        self.piece = piece
        self.size = size
        self.w = w
        self.h = h
        piecePos = Utils.convertFromIndexToPos(index: piece.positionIndex, w: w, h: h)
    }
    
    var body: some View {
        Image(piece.image)
            .resizable()
            .rotationEffect(rotation ? .degrees(180) : .zero)
            .frame(width: size.0, height: size.1)
            .position(x: piecePos.0, y: piecePos.1)
    }
}

#Preview {
    PiecesView(piece: Piece(color: .black, type: .advisor, at: 10), size: (100,100), w: 50, h: 50, rotation: true)
}
