//
//  ChessBoard.swift
//  ChineseChess
//
//  Created by Trần Ân on 22/7/24.
//

import Foundation
import SwiftUI

class ChessBoard: ObservableObject {
    var fen: String
    @Published private(set) var pieces = [Piece]()
    @Published private(set) var squares = [Square]()
    @Published private(set) var orientation = false
    @Published private(set) var moves: [Int: [Int]] = [1:[2,3,9]]
    var rule = false
    
    init(fen: String = "r1bakab1r/9/1cn2cn2/p1p1p1p1p/9/9/P1P1P1P1P/1C2C1N2/9/RNBAKABR1", rule: Bool = false) {
        self.fen = fen
        self.rule = rule
        initBoard()
        placePieceByFen(fen: fen)
    }
    
    
    // ------ INITIALIZE BOARD ------------
    // -------*************** -------------
    func initBoard() {
        for i in 0..<90 {
            squares.append(Square(id: i))
        }
    }
    
    func placePieceByFen(fen: String) {
        var id: Int = 0
        for char in fen {
            if char.isNumber {
                let emptySlot = Int(String(char))!
                for _ in 1...emptySlot {
                    //                    pieces.append(nil)
                    id += 1
                }
            }
            if char.isLetter {
                let piece: Piece
                switch String(char) {
                case "p":
                    piece = Piece(color: .black, type: .pawn, at: id)
                case "P":
                    piece = Piece(color: .white, type: .pawn, at: id)
                case "R":
                    piece = Piece(color: .white, type: .rook, at: id)
                case "r":
                    piece = Piece(color: .black, type: .rook, at: id)
                case "B":
                    piece = Piece(color: .white, type: .bishop, at: id)
                case "b":
                    piece = Piece(color: .black, type: .bishop, at: id)
                case "K":
                    piece = Piece(color: .white, type: .king, at: id)
                case "k":
                    piece = Piece(color: .black, type: .king, at: id)
                case "A":
                    piece = Piece(color: .white, type: .advisor, at: id)
                case "a":
                    piece = Piece(color: .black, type: .advisor, at: id)
                case "n":
                    piece = Piece(color: .black, type: .knight, at: id)
                case "N":
                    piece = Piece(color: .white, type: .knight, at: id)
                case "c":
                    piece = Piece(color: .black, type: .cannon, at: id)
                case "C":
                    piece = Piece(color: .white, type: .cannon, at: id)
                default:
                    return
                }
                pieces.append(piece)
                id += 1
            }
            
            if char == " " {
                break
            }
        }
    }
    // ------ *************** ------------
    // -------*************** -------------
    
    // ------------- UTILITIES -----------
    // ------------***********------------
    func isSquareSelected() -> Int? {
        for s in squares {
            if s.isChosen {
                return s.id
            }
        }
        return nil
    }
    func setMoves(moves: [Int: [Int]]) {
        self.moves = moves
    }
    
    func setOrientation(_ isSet: Bool) {
        orientation = isSet
    }
    
    func searchPieceByIndex(at index: Int) -> Int? {
        return pieces.firstIndex { piece in
            piece.positionIndex == index
        }
    }
    
    func currentSelection() -> Int? {
        squares.firstIndex { square in
            square.isChosen
        }
    }
    
    func alreadySelectedIndex() -> Bool {
        return squares.filter { square in
            square.isChosen
        }.count == 1
    }
    
    func resetIsChosen() {
        for i in squares.indices {
            squares[i].isChosen = false
        }
    }
    
    func resetRecentMove() {
        for i in squares.indices {
            squares[i].recentMoveTo = false
            squares[i].recentMoveFrom = false
        }
    }
    
    func setRecentMove(from: Int, to: Int) {
        squares[from].recentMoveFrom = true
        squares[to].recentMoveTo = true
    }
    
    // ------ *************** ------------
    // -------*************** -------------
    
    // ------ Playing ------------
    // -------*************** -------------
    
    
    
    
    func choose(_ index: Int) -> BoardEvents? {
        if searchPieceByIndex(at: index) != nil { // click on a piece
            if let alreadyChosenIndex = currentSelection() { // Moving here
                if index == alreadyChosenIndex {
                    squares[index].isChosen = false
                    return .squareUnclicked
                } else {
                    // Move
                    if rule {
                        if let moves = moves[alreadyChosenIndex] {
                            if moves.contains(index) {
//                                move(fromIndex: alreadyChosenIndex, toIndex: index)
                                resetIsChosen()
                                return .move(from: alreadyChosenIndex, to: index)
                            }
                            
                        }
                        //
                        resetIsChosen()
                        return .squareUnclicked
                    }
                }
            } else { // Chosing here
                squares[index].isChosen = true
                return .squareClicked(index)
            }
            return nil
        } else { // click on empty square
            if let alreadyChosenIndex = currentSelection() { // Moving here
                //
                if rule {
                    if let moves = moves[alreadyChosenIndex] {
                        if moves.contains(index) {
//                            move(fromIndex: alreadyChosenIndex, toIndex: index)
                            resetIsChosen()
                            return .move(from: alreadyChosenIndex, to: index)
                        }
                        
                    }
                    //
                    resetIsChosen()
                    return .squareUnclicked
                }
            }
            return nil
        }
    }
    
    func move(fromIndex: Int, toIndex: Int) {
        if let pieceIndex = searchPieceByIndex(at: fromIndex) {
            resetRecentMove()
            withAnimation(.easeInOut(duration: 2)) {
                if let toPieceIndex = searchPieceByIndex(at: toIndex) {
                    pieces[toPieceIndex].positionIndex = -1
                }
            }
            withAnimation(.easeInOut(duration: 0.3)) {
                pieces[pieceIndex].positionIndex = toIndex
            }
        }
        setRecentMove(from: fromIndex, to: toIndex)
    }
    
    
}
