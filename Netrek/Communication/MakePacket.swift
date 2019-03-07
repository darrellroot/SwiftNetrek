//
//  MakePacket.swift
//  Netrek
//
//  Created by Darrell Root on 3/2/19.
//  Copyright © 2019 Network Mom LLC. All rights reserved.
//

import Foundation
import AppKit

class MakePacket {
    static let appDelegate = NSApplication.shared.delegate as! AppDelegate

    static func make16Tuple(string: String) -> (UInt8,UInt8,UInt8,UInt8,UInt8,UInt8,UInt8,UInt8,UInt8,UInt8,UInt8,UInt8,UInt8,UInt8,UInt8,UInt8) {
        var temp: [UInt8] = []
        for _ in 0..<16 {
            temp.append(0)
        }
        for (index,char) in string.utf8.enumerated() {
            if index < 15 {
                // leaving last position with null
                temp[index] = char
            }
        }
        let information = (temp[0],temp[1],temp[2],temp[3],temp[4],temp[5],temp[6],temp[7],temp[8],temp[9],temp[10],temp[11],temp[12],temp[13],temp[14],temp[15])
        return information
    }
    
    // CP_SPEED 2
    static func cpSpeed(speed: Int) -> Data? {
        var packet = CP_SPEED()
        guard speed >= 0 else {
            return nil
        }
        guard speed < 13 else {
            return nil
        }
        packet.speed = UInt8(speed)
        let data = Data(bytes: &packet, count: packet.size)
        debugPrint("Sending CP_SPEED 2 speed \(speed)")
        return data
    }

    // CP_DIRECTION 3
    static func cpDirection(netrekDirection: Int) -> Data? {
        guard netrekDirection >= 0 else {
            return nil
        }
        guard netrekDirection < 256 else {
            return nil
        }
        var packet = CP_DIRECTION()
        packet.direction = UInt8(netrekDirection)
        let data = Data(bytes: &packet, count: packet.size)
        debugPrint("Sending CP_DIRECTION 3 direction \(netrekDirection)")
        return data
    }
    static func cpLogin(name: String, password: String, login: String) -> Data {
        // ugly hack with 16-element tuple and
        // C structure header to get bit boundaries to align
        
        var packet = login_cpacket()
        packet.type = 8
        packet.query = 0
        packet.name = make16Tuple(string: name)
        packet.login = make16Tuple(string: login)
        packet.password = make16Tuple(string: password)
        debugPrint("Sending CP_LOGIN 8 query \(packet.query) name \(name)")
        let data = Data(bytes: &packet, count: packet.size)
        return data
    }
    static func cpOutfit(team: Team, ship: ShipType) -> Data {
        debugPrint("Sending CP_OUTFIT 9")
        // packet type 9
        var packet = CP_OUTFIT(team: team, ship: ship)
        let data = Data(bytes: &packet, count: packet.size)
        return data
    }
    static func cpSocket() -> Data {
        debugPrint("Sending CP_SOCKET 27")

        // packet type 27
        var packet = CP_SOCKET()
        let data = Data(bytes: &packet, count: packet.size)
        return data
    }
    static func cpUpdates() -> Data {
        var packet = CP_UPDATES()
        debugPrint("Sending CP_UPDATE 31 \(packet.usecs.byteSwapped)")
        let data = Data(bytes: &packet, count: packet.size)
        return data
    }
    static func cpFeatures(feature: String, arg1: Int8 = 0) -> Data {
        let value = 1
        debugPrint("Sending CP_FEATURE 60 arg1 \(arg1) value \(value) feature \(feature)")
        var packet = feature_cpacket()
        packet.type = 60
        packet.feature_type = 83 // S in ascii
        packet.arg1 = Int8(arg1)
        packet.arg2 = 0
        packet.value = Int32(value).bigEndian
        var name = withUnsafeMutableBytes(of: &packet.name) {bytes in
            var count = 0
            let feature = feature.utf8
            for char in feature {
                bytes[count] = char
                count = count + 1
            }
            // now null pad to 80
            for _ in count..<80 {
                bytes[count] = 0
                count = count + 1
            }
        }
        //var packet = CP_FEATURE(feature: feature)
        let data = Data(bytes: &packet, count: MemoryLayout.size(ofValue: packet))
        return data
    }

    /*static func cpLogin(name: String, password: String, login: String) -> Data {
        var packet = CP_LOGIN()
        for (index,char) in name.utf8.enumerated() {
            if index < NAME_LEN - 1 {
                debugPrint("index \(index) char \(UInt8(char))")
                packet.name[index] = UInt8(char)
            }
        }
        for (index,char) in password.utf8.enumerated() {
            if index < NAME_LEN - 1 {
                packet.password[index] = UInt8(char)
            }
        }
        for (index,char) in login.utf8.enumerated() {
            if index < NAME_LEN - 1 {
                packet.login[index] = UInt8(char)
            }
        }
        let data = Data(bytes: &packet, count: packet.size)
        for byte in data {
            debugPrint(byte)
        }
        return data
    }*/
}
