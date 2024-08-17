//
//  PlayView.swift
//  ChineseChess
//
//  Created by Trần Ân on 25/7/24.
//

import SwiftUI
import Firebase

struct PlayView: View {
    @StateObject var chessBoard: ChessBoard
    @State var realTimeMove: ListenerRegistration?
    
    let db = Firestore.firestore()
    var game: Game
    var hostPlayer: String?
    var orientation = false
    init(game: Game) {
        self.game = game
        self.hostPlayer = Auth.auth().currentUser?.uid
        if let whiteP = game.player.white {
            if hostPlayer != whiteP.uid {
                orientation = true
            }
        }
        
        _chessBoard = StateObject(wrappedValue: ChessBoard(fen: "rnbakabnr/9/1c5c1/p1p1p1p1p/9/9/P1P1P1P1P/1C5C1/9/RNBAKABNR", rule: true))
    }
    
    var body: some View {
        ChessBoardView(chessBoard: chessBoard) { event in
            switch event {
            case let .move(from, to):
                print("di tu \(from) den \(to)")
                addMoveToFirestore(from: from, to: to)
            case let .squareClicked(id):
                print(id)
            case .squareUnclicked:
                print("nothing")
            }
        }.onAppear {
            getAllLegitMoves()
            chessBoard.setOrientation(orientation)
            setupListener()
        }
        .onDisappear {
            realTimeMove?.remove()
            realTimeMove = nil
        }
    }
    
    private func makeMoves(from: Int, to: Int) {
        let moveFrom = Utils.convertFromIndexToString(from)
        let moveTo = Utils.convertFromIndexToString(to)
        CloudFunctionAPI.makeMove(gameId: game.id, move: "\(moveFrom)\(moveTo)") { result in
            switch result {
            case let .success(moves):
//                print("move moi: \(moves)")
                DispatchQueue.main.async {
                    chessBoard.setMoves(moves: Utils.getLegitMoves(moves: moves))
                }
//                print(chessBoard.moves)
            case .failure(_):
                print("error play view")
            }
        }
    }
    
    private func getAllLegitMoves() {
        CloudFunctionAPI.getValidMoves(gameId: game.id) { result in
            switch result {
            case let .success(moves):
                DispatchQueue.main.async {
                    chessBoard.setMoves(moves: Utils.getLegitMoves(moves: moves))
                }
            case .failure(_):
                print("error play view")
            }
        }
    }
    
    private func setupListener() {
        realTimeMove = db.collection("games").document(game.id).collection("moves").addSnapshotListener { snapshot, error in
            print("real time move is called")
            guard let snapshot = snapshot else {
                print("Error fetching moves: \(String(describing: error))")
                return
            }
            for diff in snapshot.documentChanges {
                if diff.type == .added {
                    let moveData = diff.document.data()
                    if let from = moveData["moveFrom"] as? Int,
                       let to = moveData["moveTo"] as? Int {
                        print("\(diff.document.data())")
                        chessBoard.move(fromIndex: from, toIndex: to)
                        makeMoves(from: from, to: to)
                    }
                }
            }
        }
    }
    
    private func addMoveToFirestore(from: Int, to: Int) {
        let move = [
            "moveFrom": from,
            "moveTo": to,
            "player": hostPlayer ?? "",
            "timestamp": Int(Date().timeIntervalSince1970)
        ] as [String : Any]
        
        db.collection("games").document(game.id).collection("moves").addDocument(data: move) { error in
            if let error = error {
                print("Error adding move: \(error)")
            } else {
                print("Move successfully added!")
            }
        }
    }
}

#Preview {
    PlayView(game: Game.sampleData[0])
}
