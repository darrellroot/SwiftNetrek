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
    var me: Player = Player()
    
    init() {
        for _ in 0..<MAXPLAYERS {
            let newPlayer = Player()
            players.append(newPlayer)
            me = players[0]
        }
    }
}
