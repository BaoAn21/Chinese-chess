//
//  Game.swift
//  ChineseChess
//
//  Created by Trần Ân on 23/7/24.
//

import Foundation

struct Game: Identifiable, Codable {
    var id: String
    var bTime: Int
    var wTime: Int
    var clock: Clock
    var hostPlayer: Player
    var result: String
    var player: PlayerInfo
    var createTime: Int
    var lastestActionTime: Int
    var currentFen: String
    
    struct Clock: Codable {
        var initial: Int
        var increment: Int
    }
    struct PlayerInfo: Codable {
        var black: Player?
        var white: Player?
    }
    
    struct Player: Codable {
        var uid: String
        var name: String
    }
    struct Move: Codable {
        var moveFrom: Int
        var moveTo: Int
        var player: String
        var timestamp: Int
    }
    
}




extension Game {
    static var sampleData = [
        Game(id: "1", bTime: 4000, wTime: 4000, clock: Clock(initial: 10000, increment: 3), hostPlayer: Player(uid: "111", name: "aaa"), result: "new", player: PlayerInfo(black: Player(uid: "111", name: "aaa"), white: Player(uid: "222", name: "afddf")), createTime: 111111, lastestActionTime:11234,currentFen: "daf"),
        Game(id: "2", bTime: 3000, wTime: 3000, clock: Clock(initial: 10000, increment: 0), hostPlayer: Player(uid: "444", name: "bbb"), result: "playing", player: PlayerInfo(black: Player(uid: "444", name: "bbb"), white: Player(uid: "432", name: "lmk")), createTime: 1111,lastestActionTime:11234,currentFen: "daf")
    ]
}
