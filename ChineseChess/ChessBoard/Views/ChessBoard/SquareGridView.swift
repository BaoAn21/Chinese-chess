//
//  SquareGridView.swift
//  ChineseChess
//
//  Created by Trần Ân on 19/7/24.
//

import SwiftUI

struct SquareGridView: View {
    @ObservedObject var chessBoard: ChessBoard
    
    var squares: [Square] = []
    var squareW: Double
    var squareH: Double
    
    var squareEvent: (BoardEvents) -> Void
    
    
    @State var isShowCoudMove = false
    
    private let gridColumns = Array(repeating: GridItem(.flexible(minimum: 10), spacing: 0), count: 9)
    
    var body: some View {
        LazyVGrid(columns: gridColumns, spacing: 0) {
            ForEach(squares) { square in
                ZStack {
                    SquareView(square: square, width: squareW, height: squareH)
                    .onTapGesture {
                        if let event = chessBoard.choose(square.id) {
                            squareEvent(event)
                        }
                    }
                    if let id = chessBoard.isSquareSelected() {
                        if let legitMove = chessBoard.moves[id] {
                            if legitMove.contains(square.id) {
                                Rectangle().stroke()
                                    .foregroundStyle(.blue)
                            }
                        }
                    }
                }
            }
        }
    }
    
}

#Preview {
    SquareGridView(chessBoard: ChessBoard(), squareW: 45, squareH: 45) { event in
        print("event in squareGridView \(event)")
        
    }
}
