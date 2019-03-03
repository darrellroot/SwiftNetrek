//
//  PacketAnalyzer.swift
//  Netrek
//
//  Created by Darrell Root on 3/2/19.
//  Copyright © 2019 Network Mom LLC. All rights reserved.
//

import Foundation
import AppKit
class PacketAnalyzer {
    
    static let appDelegate = NSApplication.shared.delegate as! AppDelegate
    static let universe = appDelegate.universe
    
    static func analyze(data: Data) {
        var position = 0
        guard position < data.count else {
            debugPrint("Warning: PacketAnalyzer.analyze received zero length data.")
            return
        }
        repeat {
            let packetType: UInt8 = data[position]
            guard let packetLength = PACKET_SIZES[safe: Int(packetType)] else {
                debugPrint("Warning: PacketAnalyzer.analyze received invalid packet type \(packetType) at position \(position)")
                return
            }
            guard packetLength > 0 else {
                debugPrint("PacketAnalyzer invalid packet length \(packetLength) type \(packetType) position \(position)")
                return
            }
            guard position + packetLength <= data.count else {
                debugPrint("Error: fractional packet at position \(position) expected length \(packetLength) total size \(data.count)")
                return
            }
            let range = (position..<position + packetLength)
            let thisPacket = data.subdata(in: range)
            //let thisPacket = data[position..<position+packetLength]
            self.analyzeOnePacket(data: thisPacket)
            position = position + packetLength
        } while position < data.count
    }
    static func analyzeOnePacket(data: Data) {
        guard data.count > 0 else {
            debugPrint("PacketAnalyer.analyzeOnePacket data length 0")
            return
        }
        let packetType: UInt8 = data[0]
        guard let packetLength = PACKET_SIZES[safe: Int(packetType)] else {
            debugPrint("Warning: PacketAnalyzer.analyzeOnePacket received invalid packet type \(packetType)")
            return
        }
        guard packetLength > 0 else {
            debugPrint("PacketAnalyzer.analyzeOnePacket invalid packet length \(packetLength) type \(packetType)")
            return
        }
        guard packetLength == data.count else {
            debugPrint("PacketAnalyzer.analyeOnePacket unexpected data length \(data.count) expected \(packetLength) type \(packetType)")
            return
        }
        debugPrint("Received packet type \(packetType) length \(packetLength)\n")
        switch packetType {
        case 11:
            // message
            let range = (4..<84)
            let messageData = data.subdata(in: range)
            if let messageStringWithNulls = String(data: messageData, encoding: .utf8) {
                var messageString = messageStringWithNulls.filter { $0 != "\0" }
                messageString.append("\n")
            appDelegate.messageViewController?.gotMessage(message: messageString)
                debugPrint(messageString)
            } else {
                debugPrint("PacketAnalyzer unable to decode message type 11")
            }
        case 12:
            // My information
            // SP_YOU length 32
            let myId = Int(data[1])
            let hostile = Int(data[2])
            let stickyWar = Int(data[3])
            let armies = Int(data[4])
            let tractor = Int(data[5])
            let flags = data.subdata(in: (8..<12)).to(type: UInt32.self)
            let damage = data.subdata(in: (12..<16)).to(type: UInt32.self)
            let shieldStrength = data.subdata(in: (16..<20)).to(type: UInt32.self)
            let fuel = data.subdata(in: (20..<24)).to(type: UInt32.self)
            let engineTemp = data.subdata(in: (24..<25)).to(type: UInt16.self)
            let weaponsTemp = data.subdata(in: (26..<27)).to(type: UInt16.self)
            let whyDead = data.subdata(in: (28..<29)).to(type: UInt16.self)
            let whoDead = data.subdata(in: (30..<31)).to(type: UInt16.self)
            debugPrint("I am player \(myId) damage \(damage) fuel \(fuel) \(engineTemp)\n")
            guard let me = universe.players[safe: myId] else {
                debugPrint("PacketAnalyzer cannot find myId \(myId)")
                return
            }
            universe.me = me
            me.idNumber = myId
            // hostile
            // stickyWar
            me.armies = armies
            // tractor
            // flags
            me.damage = Int(damage)
            me.shieldStrength = Int(shieldStrength)
            me.fuel = Int(fuel)
            me.engineTemp = Int(engineTemp)
            me.weaponsTemp = Int(weaponsTemp)
            // whydead
            // whodead
            debugPrint(me.description)
            
        default:
            break
        }
    }
}
