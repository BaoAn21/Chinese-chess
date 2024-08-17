//
//  ListGameView.swift
//  ChineseChess
//
//  Created by Trần Ân on 23/7/24.
//

import SwiftUI

struct GameInfoView: View {
    var game: Game
    var whitePid: String = ""
    var blackPid: String = ""
    var whiteName: String = ""
    var blackName: String = ""
    init(game: Game) {
        self.game = game
        if let whiteP = game.player.white {
            whitePid = whiteP.uid
            whiteName = whiteP.name
        }
        if let blackP = game.player.black {
            blackPid = blackP.uid
            blackName = blackP.name
        }
    }
    var body: some View {
        HStack(alignment: .top, content: {
            VStack {
                HStack {
                    Text("White: \(whiteName)")
                    Spacer()
                    Text("Black: \(blackName)")
                }
                Text("Created by: \(game.hostPlayer.name)")
                Text("Time \(Int(game.clock.initial)) + \(game.clock.increment)")
            }
        })
        
    }
    
}

#Preview {
    GameInfoView(game: Game.sampleData[0])
}
