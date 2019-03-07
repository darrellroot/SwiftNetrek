//
//  GameState.swift
//  Netrek
//
//  Created by Darrell Root on 3/2/19.
//  Copyright © 2019 Network Mom LLC. All rights reserved.
//

import Foundation

enum GameState: String, CaseIterable {
    case noServerSelected
    case serverSelected
    case serverConnected
    case serverSlotFound
    case loginAccepted
    case outfitAccepted
    case gameActive
}

enum ShipType: Int, CaseIterable {
    case scout = 0
    case destroyer = 1
    case cruiser = 2
    case battleship = 3
    case assault = 4
    case starbase = 5
    case sgalaxy = 6
    case att = 7
}
// teams_numeric = {IND: -1, FED: 0, ROM: 1, KLI: 2, ORI: 3}

enum Team: Int, CaseIterable {
    case independent = 0
    case federation = 1
    case roman = 2
    case kleptocrat = 4
    case orion = 8
    case ogg = 15
}

enum PlayerStatus: UInt32 {
    case shield = 0x0001
    case repair = 0x0002
    case bomb = 0x0004
    case orbit = 0x0008
    case cloak = 0x0010
    case weaponTemp = 0x0020
    case engineTemp = 0x0040
    case robot = 0x0080
    case beamup = 0x0100
    case beamdown = 0x0200
    case selfDestruct = 0x0400
    case greenAlert = 0x0800
    case yellowAlert = 0x1000
    case redAlert = 0x2000
    case playerLock = 0x4000
    case planetLock = 0x8000
    case coPilot = 0x10000 // not displayed
    case war = 0x20000
    case practiceRobot = 0x40000
    case dock = 0x80000
    case refit = 0x100000 // not displayed
    case refitting = 0x200000
    case tractor = 0x400000
    case pressor = 0x800000
    case dockOk = 0x1000000
    case seen = 0x2000000
    case observe = 0x8000000
    case transWarp = 0x40000000 // paradise mode
    case bpRobot = 0x80000000
}
enum ZPosition: CGFloat {
    case planet = 1.0
    case planetLabel = 2.0
    case ship = 3.0
    case torpedo = 4.0
    case explosion = 5.0
}
enum SlotStatus: Int {
    case free = 0
    case outfit = 1
    case alive = 2
    case explode = 3
    case dead = 4
    case observe = 5
}

enum TorpedoStatus: UInt32 {
    case free = 0
    case move = 1
    case explode = 2
    case detonate = 3
    case off = 4
    case straight = 5
}
