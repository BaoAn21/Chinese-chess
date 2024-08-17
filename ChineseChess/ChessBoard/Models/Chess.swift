//
//  ChessBoardModel.swift
//  ChessV2
//
//  Created by Trần Ân on 3/7/24.
//

import Foundation
import SwiftUI

struct Piece: Identifiable {
    let id: UUID
    let color: PieceColor
    let type: PieceType
    var positionIndex: Int
    
    var image: String {
        switch color {
        case .white:
            switch type {
            case .pawn:
                return "whitePawn"
            case .rook:
                return "whiteRook"
            case .knight:
                return "whiteKnight"
            case .king:
                return "whiteKing"
            case .cannon:
                return "whiteCannon"
            case .bishop:
               return "whiteBishop"
            case .advisor:
                return "whiteAdvisor"
            }
        case .black:
            switch type {
            case .pawn:
                return "blackPawn"
            case .rook:
                return "blackRook"
            case .knight:
                return "blackKnight"
            case .king:
                return "blackKing"
            case .cannon:
                return "blackCannon"
            case .bishop:
               return "blackBishop"
            case .advisor:
                return "blackAdvisor"
            }
        }
    }
    
    init(id: UUID = UUID(), color: PieceColor, type: PieceType, at index: Int) {
        self.id = id
        self.color = color
        self.type = type
        self.positionIndex = index
    }
    
    var fenChar: String {
        switch color {
        case .white:
            switch type {
            case .pawn:
                return "P"
            case .rook:
                return "R"
            case .knight:
                return "N"
            case .king:
                return "K"
            case .cannon:
                return "C"
            case .advisor:
                return "A"
            case .bishop:
               return "B"
            }
        case .black:
            switch type {
            case .pawn:
                return "p"
            case .rook:
                return "r"
            case .knight:
                return "n"
            case .king:
                return "k"
            case .cannon:
                return "c"
            case .bishop:
               return "b"
            case .advisor:
                return "a"
            }
        }
    }
}

enum PieceColor {
    case white
    case black
}

enum PieceType {
    case pawn
    case rook
    case knight
    case king
    case cannon
    case bishop
    case advisor
}


struct Square: Identifiable {
    var id: Int
    var isChosen = false
    var recentMoveFrom = false
    var recentMoveTo = false
    var couldGoTo = false
    var piece: Piece?
}

enum BoardEvents {
    case squareClicked(Int)
    case move(from: Int, to: Int)
    case squareUnclicked
}

