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

struct CP_SPEED {
    let type: UInt8 = 2
    var speed: UInt8 = 0
    var pad1: UInt8 = 0
    var pad2: UInt8 = 0
    
    var size: Int {
        return 4
    }
}

struct CP_DIRECTION {
    let type: UInt8 = 3
    var direction: UInt8 = 0
    var pad1: UInt8 = 0
    var pad2: UInt8 = 0
    
    var size: Int {
        return 4
    }
}
struct CP_OUTFIT {
    let type: UInt8 = 9
    var team: UInt8 = 1
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

struct CP_SOCKET {
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

struct CP_UPDATES {
    let type: UInt8 = 31
    let pad1: UInt8 = 0
    let pad2: UInt8 = 0
    let pad3: UInt8 = 0
    let usecs: UInt32 = UInt32(100000).bigEndian
    
    var size: Int {
        return 8
    }
}

/* does not work but valiant attempt
struct CP_FEATURE {
    let type: UInt8 = 60
    let featureType: UInt8 = UInt8(ascii: "C")
    let arg1: UInt8 = 0
    let arg2: UInt8 = 0
    let value: UInt32
    var data = Data(count: 80)
    var size: Int {
        return 88
    }
    init(features: [String]) {
        debugPrint("data size \(MemoryLayout.size(ofValue:data))")
        debugPrint("data stride \(MemoryLayout.stride(ofValue:data))")
        debugPrint("data alignment \(MemoryLayout.alignment(ofValue:data))")

        value = UInt32(features.count).bigEndian
        var count = 0
        for feature in features {
            //do we have enough space remaining
            //for next feature
            if count + feature.count + 1 >= 80 {
                debugPrint("CP_FEATURE.init: Warning: Feature packet size exceeded")
                for _ in count..<80 {
                    data[count] = 0
                    count = count + 1
                }
                return
            }
            let feature = feature.utf8
            for char in feature {
                data[count] = char
                count = count + 1
            }
            data[count] = 0
            count = count + 1
        }
        // all features successfully added and null terminated.  now pad to 80
        for _ in count..<80 {
            data[count] = 0
            count = count + 1
        }
        return
    }
 }
 */
