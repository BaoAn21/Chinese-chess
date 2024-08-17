//
//  ChessBoardImageView.swift
//  ChineseChess
//
//  Created by Trần Ân on 19/7/24.
//

import SwiftUI

struct ChessBoardView: View {
    @State var chessImageSize: CGSize = .zero
    @State var testPos: CGPoint = .zero
    @ObservedObject var chessBoard = ChessBoard()
    
    var boardEvent: (BoardEvents) -> Void
    
    var body: some View {
        let startW = 0 + (chessImageSize.width / 17)
        let endW = chessImageSize.width - (chessImageSize.width / 17)
        let startH = chessImageSize.height / 19.58
        let endH = chessImageSize.height - (chessImageSize.height / 19.58)
        let w = (endW - startW) / 8
        let h = (endH - startH) / 9
        
        Image("chessboard")
            .resizable()
            .scaledToFit()
            .border(Color.black)
            .overlay(content: {
                SquareGridView(chessBoard: chessBoard, squares: chessBoard.squares, squareW: w, squareH: h) { event in
                    boardEvent(event)
                }
                ForEach(chessBoard.pieces) {piece in
                    if piece.positionIndex >= 0 {
                        PiecesView(piece: piece, size: (w,h), w: w, h: h, rotation: chessBoard.orientation)
                    }
                }
                .allowsHitTesting(false)
                
            })
            .rotationEffect(chessBoard.orientation ? .init(degrees: 180) : .zero)
            .saveSize(in: $chessImageSize)
        
    }
}

#Preview {
    ChessBoardView() { event in
        print("event in chessView \(event)")
    }
}
