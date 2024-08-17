//
//  Utils.swift
//  ChineseChess
//
//  Created by Trần Ân on 22/7/24.
//

import Foundation

struct Utils {
    static func convertFromIndexToPos(index: Int, w: Double, h: Double) -> (Double, Double) {
        let xIndex = index % 9
        let yIndex = index / 9
        
        let pos = (Double(xIndex * 2 + 1) * (w / 2) + 1, Double((yIndex * 2 + 1)) * (h / 2))
        return pos
    }
    
    static func convertStringToIndex(_ square: String) -> Int {
        let files = ["a":0,"b":1,"c":2,"d":3,"e":4,"f":5,"g":6,"h":7,"i":8]
        let ranks = ["0":9,"1":8,"2":7,"3":6,"4":5,"5":4,"6":3,"7":2,"8":1,"9":0]
        let letter = String(square.prefix(1))  // Extracts the first character
        let number = String(square.suffix(from: square.index(after: square.startIndex)))  // Extracts the substring starting from the second character
        guard let rank = ranks[number] else { return -1}
        guard let file = files[letter] else { return -1}
        
        let rankIndex = rank * 9
        
        return rankIndex + file
    }
    
    static func splitMoves(_ moves: String) -> (String, String) {
        let firstMove = String(moves.prefix(2))  // Extracts the first two characters
        let secondMove = String(moves.suffix(2))  // Extracts the last two characters
        
        return (firstMove, secondMove)
    }
    
    static func getLegitMoves(moves: [String]) -> [Int: [Int]] {
        var legitMoves:[Int: [Int]] = [:]
        for move in moves {
            let square = splitMoves(move).0
            let destination = splitMoves(move).1
            let squareIndex = convertStringToIndex(square)
            let desIndex = convertStringToIndex(destination)
            if var squareMoves = legitMoves[squareIndex] {
                squareMoves.append(desIndex)
            } else {
                legitMoves[squareIndex] = []
            }
            legitMoves[squareIndex]?.append(desIndex)
        }
        return legitMoves
    }
    
    
    static func convertFromIndexToString(_ index: Int) -> String {
        let files = [0:"a",1:"b",2:"c",3:"d",4:"e",5:"f",6:"g",7:"h",8:"i"]
        let ranks = [9:"0",8:"1",7:"2",6:"3",5:"4",4:"5",3:"6",2:"7",1:"8",0:"9"]
        
        let rank = index / 9
        let file = index % 9
        
        if let rankS = ranks[rank] {
            if let fileS = files[file] {
                return "\(fileS)\(rankS)"
            }
        }
        return "nothign"
    }
}
