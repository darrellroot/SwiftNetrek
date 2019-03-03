//
//  Player.swift
//  Netrek
//
//  Created by Darrell Root on 3/2/19.
//  Copyright © 2019 Network Mom LLC. All rights reserved.
//

import Foundation

class Player: CustomStringConvertible {
    var playerID = 0
    var hostile = 0
    var war = 0
    var armies = 0
    var tractor = 0
    var flags: UInt32 = 0
    var damage = 0
    var shieldStrength = 100
    var fuel = 10000
    var engineTemp = 0
    var weaponsTemp = 0
    // whydead
    // whodead
    
    var playing = false
    var playerId: Int = -1
    var team: Int = 0
    var ship: Int = 0
    var locationX: Int = 0
    var locationY: Int = 0
    var me: Bool = false
    var name: String = "nobody"
    //
    // from packet type 24
    var rank = 0
    var login = "unknown"
    // from packet type 3
    var kills = 0.0
    var status = 0
    // from packet type 4
    var direction = 0
    var speed = 0
    
    init(playerID: Int) {
        self.playerID = playerID
    }
    var description: String {
        get {
            return "Player \(playerID) name \(name) armies \(armies) damage \(damage) shield \(shieldStrength) fuel \(fuel) eTmp \(engineTemp) ship \(ship) team \(team) wTmp \(weaponsTemp) playing \(playing) locationX \(locationX) locationY \(locationY) login \(login) rank \(rank)"
        }
    }
}

