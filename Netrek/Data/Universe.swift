//
//  Universe.swift
//  Netrek
//
//  Created by Darrell Root on 3/2/19.
//  Copyright © 2019 Network Mom LLC. All rights reserved.
//

import Foundation

class Universe {
    var players: [Int:Player] = [:]
    var planets: [Int:Planet] = [:]
    var torpedoes: [Int: Torpedo] = [:]
    var lasers: [Int: Laser] = [:]
    var plasmas: [Int: Plasma] = [:]
    var me: Player?
    let maxPlanets = 200
    let maxPlayers = 100
    let maxTorpedoes = 1000
    let maxLasers = 100
    let maxPlasma = 100
    
    init() {
    }
    public func createPlanet(planetID: Int, positionX: Int, positionY: Int, name: String) {
        guard planetID >= 0 else {
            debugPrint("ERROR: Universe.updatePlanet invalid planetID \(planetID)")
            return
        }
        guard planetID < maxPlanets else {   // sanity check for crazy planet numbers
            debugPrint("ERROR: Universe.updatePlanet invalid planetID \(planetID)")
            return
        }
        if let planet = planets[planetID] {
            planet.update(name: name, positionX: positionX, positionY: positionY)
        } else {
            let newPlanet = Planet(planetID: planetID)
            newPlanet.update(name: name, positionX: positionX, positionY: positionY)
            planets[planetID] = newPlanet
        }
    }
    public func updatePlayer(playerID: Int, shipType: Int, team: Int) {
        guard playerID >= 0 && playerID < maxPlayers else {
            debugPrint("Universe.updatePlayer invalid playerID \(playerID)")
            return
        }
        if self.players[playerID] == nil {
            let newPlayer = Player(playerID: playerID)
            self.players[playerID] = newPlayer
        }
        self.players[playerID]?.update(shipType: shipType)
        self.players[playerID]?.update(team: team)
    }
    public func updatePlayer(playerID: Int, war: UInt32, hostile: UInt32) {
        guard playerID >= 0 && playerID < maxPlayers else {
            debugPrint("Universe.updatePlayer invalid playerID \(playerID)")
            return
        }
        if self.players[playerID] == nil {
            let newPlayer = Player(playerID: playerID)
            self.players[playerID] = newPlayer
        }
        self.players[playerID]?.update(war: war, hostile: hostile)
    }
    public func updatePlayer(playerID: Int, rank: Int, name: String, login: String) {
        guard playerID >= 0 && playerID < maxPlayers else {
            debugPrint("Universe.updatePlayer invalid playerID \(playerID)")
            return
        }
        if self.players[playerID] == nil {
            let newPlayer = Player(playerID: playerID)
            self.players[playerID] = newPlayer
        }
        self.players[playerID]?.update(rank: rank, name: name, login: login)

    }

    public func updatePlayer(playerID: Int, kills: Double) {
        guard playerID >= 0 && playerID < maxPlayers else {
            debugPrint("Universe.updatePlayer invalid playerID \(playerID)")
            return
        }
        if self.players[playerID] == nil {
            let newPlayer = Player(playerID: playerID)
            self.players[playerID] = newPlayer
        }
        self.players[playerID]?.update(kills: kills)
    }
    public func updatePlayer(playerID: Int, directionNetrek: Int, speed: Int, positionX: Int, positionY: Int) {
        guard playerID >= 0 && playerID < maxPlayers else {
            debugPrint("Universe.updatePlayer invalid playerID \(playerID)")
            return
        }
        if self.players[playerID] == nil {
            let newPlayer = Player(playerID: playerID)
            self.players[playerID] = newPlayer
        }
        self.players[playerID]?.update(directionNetrek: directionNetrek, speed: speed, positionX: positionX, positionY: positionY)
    }
    
    public func updateMe(myPlayerID: Int, hostile: UInt32, war: UInt32, armies: Int, tractor: Int, flags: UInt32, damage: Int, shieldStrength: Int, fuel: Int, engineTemp: Int, weaponsTemp: Int, whyDead: Int, whoDead: Int) {
        guard myPlayerID >= 0 && myPlayerID < maxPlayers else {
            debugPrint("Universe.updateMe invalid playerID \(myPlayerID)")
            return
        }
        if self.players[myPlayerID] == nil {
            let newPlayer = Player(playerID: myPlayerID)
            self.players[myPlayerID] = newPlayer
        }
        if self.me == nil {
            self.me = self.players[myPlayerID]
        }
        self.me?.updateMe(myPlayerID: myPlayerID, hostile: hostile, war: war, armies: armies, tractor: tractor, flags: flags, damage: damage, shieldStrength: shieldStrength, fuel: fuel, engineTemp: engineTemp, weaponsTemp: weaponsTemp, whyDead: whyDead, whoDead: whoDead)
    }
    public func updateTorpedo(torpedoNumber: Int, war: UInt8, status: UInt8) {
        guard torpedoNumber >= 0 && torpedoNumber < maxTorpedoes else {
            debugPrint("Universe.updatePlayer invalid torpedoNumber \(torpedoNumber)")
            return
        }
        if self.torpedoes[torpedoNumber] == nil {
            let newTorpedo = Torpedo()
            self.torpedoes[torpedoNumber] = newTorpedo
        }
        self.torpedoes[torpedoNumber]?.update(war: war, status: status)
    }
    public func updateTorpedo(torpedoNumber: Int, directionNetrek: Int, positionX: Int, positionY: Int) {
        guard torpedoNumber >= 0 && torpedoNumber < maxTorpedoes else {
            debugPrint("Universe.updatePlayer invalid torpedoNumber \(torpedoNumber)")
            return
        }
        if self.torpedoes[torpedoNumber] == nil {
            let newTorpedo = Torpedo()
            self.torpedoes[torpedoNumber] = newTorpedo
        }
        self.torpedoes[torpedoNumber]?.update(directionNetrek: directionNetrek, positionX: positionX, positionY: positionY)
    }
    public func updateLaser(laserNumber: Int, status: Int, directionNetrek: Int, positionX: Int, positionY: Int, target: Int) {
        guard laserNumber >= 0 && laserNumber < maxLasers else {
            debugPrint("Universe.updatePlayer invalid laserNumber \(laserNumber)")
            return
        }
        if self.lasers[laserNumber] == nil {
            let newLaser = Laser()
            self.lasers[laserNumber] = newLaser
        }
        self.lasers[laserNumber]?.update(status: status, directionNetrek: directionNetrek, positionX: positionX, positionY: positionY, target: target)
    }

    public func updatePlasma(plasmaNumber: Int, war: Int, status: Int) {
        guard plasmaNumber >= 0 && plasmaNumber < maxPlasma else {
            debugPrint("Universe.updatePlayer invalid plasmaNumber \(plasmaNumber)")
            return
        }
        if self.plasmas[plasmaNumber] == nil {
            let newPlasma = Plasma()
            self.plasmas[plasmaNumber] = newPlasma
        }
        self.plasmas[plasmaNumber]?.update(war: war, status: status)
    }
    public func updatePlasma(plasmaNumber: Int, positionX: Int, positionY: Int) {
        guard plasmaNumber >= 0 && plasmaNumber < maxPlasma else {
            debugPrint("Universe.updatePlayer invalid plasmaNumber \(plasmaNumber)")
            return
        }
        if self.plasmas[plasmaNumber] == nil {
            let newPlasma = Plasma()
            self.plasmas[plasmaNumber] = newPlasma
        }
        self.plasmas[plasmaNumber]?.update(positionX: positionX, positionY: positionY)
    }

}
