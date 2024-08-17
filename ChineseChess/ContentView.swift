//
//  ContentView.swift
//  ChineseChess
//
//  Created by Trần Ân on 18/7/24.
//

import SwiftUI


struct ContentView: View {
    let defaultFen = "rnbakabnr/9/1c5c1/p1p1p1p1p/9/9/P1P1P1P1P/1C5C1/9/RNBAKABNR"
    @StateObject var chessBoard = ChessBoard(fen: "rnbakabnr/9/1c5c1/p1p1p1p1p/9/9/P1P1P1P1P/1C5C1/9/RNBAKABNR")
    var body: some View {
        ChessBoardView(chessBoard: chessBoard) { event in
            switch event {
            case let .move(from, to):
                print("move from \(from) to \(to)")
            case let .squareClicked(square):
                print("click on \(square)")
            case .squareUnclicked:
                print("nothing")
            }
        }
        Button(action: {
            chessBoard.move(fromIndex: 0, toIndex: 4)
        }, label: {
            Text("Button")
        })
    }
}

#Preview {
    ContentView()
}
