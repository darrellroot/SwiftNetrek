//
//  Player.swift
//  Netrek
//
//  Created by Darrell Root on 3/2/19.
//  Copyright © 2019 Network Mom LLC. All rights reserved.
//

import Foundation

class Player: CustomStringConvertible {
    var idNumber = 0
    // hostile
    // stickyWar
    var armies = 0
    // tractor
    // flags
    var damage = 0
    var shieldStrength = 100
    var fuel = 10000
    var engineTemp = 0
    var weaponsTemp = 0
    // whydead
    // whodead
    
    var playing = false
    var playerId: Int = -1
    //var team: Team?
    //var ship: Ship?
    var positionX: Int = -1
    var positionY: Int = -1
    var me: Bool = false
    var name: String = "nobody"

    var description: String {
        get {
            return "Player \(idNumber) name \(name) armies \(armies) damage \(damage) shield \(shieldStrength) fuel \(fuel) eTmp \(engineTemp) wTmp \(weaponsTemp) playing \(playing) positionX \(positionX) positionY \(positionY)"
        }
    }
}

