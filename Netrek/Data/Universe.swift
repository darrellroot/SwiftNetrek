//
//  Universe.swift
//  Netrek
//
//  Created by Darrell Root on 3/2/19.
//  Copyright © 2019 Network Mom LLC. All rights reserved.
//

import Foundation

class Universe {
    var players: [Player] = []
    var planets: [Planet] = []
    var me: Player = Player(playerID: -1)
    
    init() {
        for i in 0..<MAXPLAYERS {
            let newPlayer = Player(playerID: i)
            players.append(newPlayer)
            me = players[0]
        }
        for i in 0..<MAXPLANETS {
            let newPlanet = Planet(planetID: i)
            planets.append(newPlanet)
        }
    }
    public func updatePlanet(planetID: Int, positionX: Int, positionY: Int, name: String) {
        guard planetID >= 0 else {
            debugPrint("ERROR: Universe.updatePlanet invalid planetID \(planetID)")
            return
        }
        guard planetID < MAXPLANETS else {
            debugPrint("ERROR: Universe.updatePlanet invalid planetID \(planetID)")
            return
        }
        if let planet = planets[safe: planetID] {
            if planet.planetID != planetID {
                debugPrint("ERROR: Universe.updatePlanet planetID corrupted \(planetID) \(planet.planetID)")
            }
            planet.update(name: name, positionX: positionX, positionY: positionY)
        }
    }

}
