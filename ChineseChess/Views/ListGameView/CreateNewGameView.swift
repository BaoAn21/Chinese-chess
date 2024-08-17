//
//  CreateNewGameView.swift
//  ChineseChess
//
//  Created by Trần Ân on 23/7/24.
//

import SwiftUI
import Firebase
import Foundation

struct CreateNewGameView: View {
    @State private var clockInitial: String = ""
    @State private var clockIncrement: String = ""
    @State private var hostPlayer: Game.Player? = nil
    @State private var createdGame: Game? = nil // Track the newly created game
    @State private var navigateToPlayView = false
    
    init() {
        // Set the hostPlayer to the current user's UID from Firebase Auth
        if let currentUser = Auth.auth().currentUser {
            let hostP = Game.Player(uid: currentUser.uid, name: currentUser.email!)
            _hostPlayer = State(initialValue: hostP)
        }
    }
    
    private var db = Firestore.firestore()
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Game Details")) {
                    TextField("Clock Initial Time (ms)", text: $clockInitial)
                    TextField("Clock Increment (s)", text: $clockIncrement)
                }
                
                Button(action: createGame) {
                    Text("Create Game")
                }
            }
            .navigationTitle("Create New Game")
            .navigationDestination(isPresented: $navigateToPlayView) {
                PlayView(game: createdGame ?? Game.sampleData[0])
            }
        }
        
    }
    
    private func createGame() {
        // Validate inputs
        guard let bTimeInt = Int(clockInitial),
              let wTimeInt = Int(clockInitial),
              let clockInitialInt = Int(clockInitial),
              let clockIncrementInt = Int(clockIncrement) else {
            print("Invalid input")
            return
        }
        // Randomly assign the hostPlayer ID to black or white
        let isBlackPlayer = Bool.random() // Randomly choose true or false
        
        let newBlackPlayer = isBlackPlayer ? hostPlayer : nil
        let newWhitePlayer = isBlackPlayer ? nil : hostPlayer
        
        // Create a new Game instance
        let newGame = Game(
            id: UUID().uuidString, // Generate a new UUID for the game ID
            bTime: bTimeInt,
            wTime: wTimeInt,
            clock: Game.Clock(initial: clockInitialInt, increment: clockIncrementInt),
            hostPlayer: hostPlayer ?? Game.Player(uid: "loi", name: "game"),
            result: "",
            player: Game.PlayerInfo(black: newBlackPlayer, white: newWhitePlayer),
            createTime: Int(Date().timeIntervalSince1970), // Use current timestamp
            lastestActionTime: Int(Date().timeIntervalSince1970),
            currentFen: "rnbakabnr/9/1c5c1/p1p1p1p1p/9/9/P1P1P1P1P/1C5C1/9/RNBAKABNR r - - 0 1"
        )
        
        
        // Save the game to Firestore
        db.collection("games").document(newGame.id).setData([
            "id": newGame.id,
            "bTime": newGame.bTime,
            "wTime": newGame.wTime,
            "clock": [
                "initial": newGame.clock.initial,
                "increment": newGame.clock.increment
            ],
            "hostPlayer": [
                "name": newGame.hostPlayer.name,
                "uid": newGame.hostPlayer.uid
            ],
            "result": "new",
            "player": [
                "black": [
                    "name": newGame.player.black?.name ?? "",
                    "uid": newGame.player.black?.uid ?? ""
                ],
                "white": [
                    "name": newGame.player.white?.name ?? "",
                    "uid": newGame.player.white?.uid ?? ""
                ],
            ],
            "createTime": newGame.createTime,
            "lastestActionTime": newGame.lastestActionTime,
            "currentFen": newGame.currentFen
        ]) { error in
            if let error = error {
                print("Error adding document: \(error)")
            } else {
                print("Document successfully written!")
                self.createdGame = newGame
                self.navigateToPlayView = true
            }
        }
        
    }
}


#Preview {
    CreateNewGameView()
}
