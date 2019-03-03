//
//  MakePacket.swift
//  Netrek
//
//  Created by Darrell Root on 3/2/19.
//  Copyright © 2019 Network Mom LLC. All rights reserved.
//

import Foundation

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
class MakePacket {
    static func cpPacket() -> Data {
        // packet type 27
        var packet = CP_PACKET()
        let data = Data(bytes: &packet, count: packet.size)
        return data
    }
}
