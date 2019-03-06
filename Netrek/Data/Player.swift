//
//  Player.swift
//  Netrek
//
//  Created by Darrell Root on 3/2/19.
//  Copyright © 2019 Network Mom LLC. All rights reserved.
//

import Foundation

class Player: CustomStringConvertible {
    var playerID: Int?
    private(set) var hostile = 0
    private(set) var war = 0
    private(set) var armies = 0
    private(set) var tractor = 0
    private(set) var flags: UInt32 = 0
    private(set) var damage = 0
    private(set) var shieldStrength = 100
    private(set) var fuel = 10000
    private(set) var engineTemp = 0
    private(set) var weaponsTemp = 0
    private(set) var whyDead: Int?
    private(set) var whoDead: Int?
    
    var playing = false
    var team: Team = .nobody
    private(set) var ship: ShipType?
    private(set) var positionX: Int = 0
    private(set) var positionY: Int = 0
    var me: Bool = false
    private(set) var name: String = "nobody"
    //
    // from packet type 24
    private(set) var rank = 0
    private(set) var login = "unknown"
    // from packet type 3
    private(set) var kills = 0.0
    var status = 0
    // from packet type 4
    private(set) var direction = 0
    private(set) var speed = 0
    
    init(playerID: Int) {
        self.playerID = playerID
    }
    public var description: String {
        get {
            return "Player \(String(describing: playerID)) name \(name) armies \(armies) damage \(damage) shield \(shieldStrength) fuel \(fuel) eTmp \(engineTemp) ship \(String(describing: ship)) team \(String(describing: team)) wTmp \(weaponsTemp) playing \(playing) positionX \(positionX) positionY \(positionY) login \(login) rank \(rank)"
        }
    }
    public func updateMe(myPlayerID: Int, hostile: Int, war: Int, armies: Int, tractor: Int, flags: UInt32, damage: Int, shieldStrength: Int, fuel: Int, engineTemp: Int, weaponsTemp: Int, whyDead: Int, whoDead: Int) {
        if self.playerID != myPlayerID && self.playerID != nil  {
            debugPrint("Player.updateMe: ERROR: inconsistent player ID \(myPlayerID) versus \(String(describing: self.playerID))")
        }
        self.hostile = hostile //TODO break this up
        self.war = war // TODO break this up
        self.armies = armies
        self.tractor = tractor
        self.flags = flags
        self.damage = damage
        self.shieldStrength = shieldStrength
        self.fuel = fuel
        self.engineTemp = engineTemp
        self.weaponsTemp = weaponsTemp
        self.whyDead = whyDead
        self.whoDead = whoDead
    }
    public func update(shipType: Int) {
        for shipCase in ShipType.allCases {
            if shipCase.rawValue == shipType {
                self.ship = shipCase
                return
            }
        }
        debugPrint("Player.update invalid shipType \(shipType)")
    }
    public func update(team: Int) {
        for teamCase in Team.allCases {
            if teamCase.rawValue == team {
                self.team = teamCase
                return
            }
        }
        debugPrint("Player.update invalid team \(team)")
    }
    public func update(kills: Double) {
        self.kills = kills
    }
    public func update(direction: Int, speed: Int, positionX: Int, positionY: Int) {
        self.direction = direction
        self.speed = speed
        self.positionX = positionX
        self.positionY = positionY
    }
    // from SP_FLAGS_18
    public func update(tractor: Int, flags: UInt32) {
        self.tractor = tractor
        self.flags = flags
    }
    // from SP_HOSTILE_22
    public func update(war: Int, hostile: Int) {
        self.war = war
        self.hostile = hostile
    }
    public func update(rank: Int, name: String, login: String) {
        self.rank = rank
        self.name = name
        self.login = login
    }
}

