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
    static func cpOutfit(team: Team, ship: ShipType) -> Data {
        debugPrint("Sending CP_OUTFIT")
        // packet type 8
        var packet = CP_OUTFIT(team: team, ship: ship)
        let data = Data(bytes: &packet, count: packet.size)
        for char in data {
            debugPrint(char)
        }
        return data
    }
    static func cpPacket() -> Data {
        debugPrint("Sending CP_PACKET")

        // packet type 27
        var packet = CP_PACKET()
        let data = Data(bytes: &packet, count: packet.size)
        return data
    }
    static func cpLogin(name: String, password: String, login: String) -> Data {
        debugPrint("Sending CP_LOGIN")
        // ugly hack with 16-element tuple and
        // C structure header to get bit boundaries to align
    
        var packet = login_cpacket()
        packet.type = 8
        packet.query = 1
        packet.name = make16Tuple(string: name)
        packet.login = make16Tuple(string: login)
        packet.password = make16Tuple(string: password)
        let data = Data(bytes: &packet, count: packet.size)
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
