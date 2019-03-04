//
//  packets.swift
//  Netrek
//
//  Created by Darrell Root on 3/3/19.
//  Copyright © 2019 Network Mom LLC. All rights reserved.
//

import Foundation

// could not get to align on byte boundaries ok
// had to import from C packets.h
/*struct CP_LOGIN {
 let type: UInt8 = 8
 let query: UInt8 = 1 // 0 means something
 let pad: UInt8 = 0
 let pad2: UInt8 = 0
 var name: [UInt8] = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]  // 16 UInt8 = NAME_LEN
 var password: [UInt8] = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]  // 16 UInt8
 var login: [UInt8] = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]  // 16 UInt8
 
 //var name = Data(count: NAME_LEN)
 //var password = Data(count: NAME_LEN)
 //var login = Data(count: NAME_LEN)
 var size: Int {
 return 52
 }
 }*/


struct CP_OUTFIT {
    let type: UInt8 = 9
    var team: UInt8 = 0
    var ship: UInt8 = 0
    let pad1: UInt8 = 0
    init(team: Team, ship: ShipType) {
        //self.team = UInt8(team.rawValue)
        self.ship = UInt8(ship.rawValue)
    }
    var size: Int {
        get {
            return 4
        }
    }
}

struct CP_PACKET {
    let type: UInt8 = 27
    let version: UInt8 = SOCKVERSION
    let udp_version: UInt8 = UDPVERSION
    let pad: UInt8 = 0
    //TODO: presumably we have to do something with this port
    let port: UInt32 = UInt32(32800).bigEndian
    
    var size: Int {
        return 8
    }
}
