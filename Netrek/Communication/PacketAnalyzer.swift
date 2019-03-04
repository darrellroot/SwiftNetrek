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
    
    let appDelegate = NSApplication.shared.delegate as! AppDelegate
    let universe: Universe
    var leftOverData: Data?
    
    init() {
        universe = appDelegate.universe
    }
    /*func analyze(incomingData: Data) {
        var data: Data
        if let leftOverData = leftOverData {
            data = leftOverData + incomingData
            self.leftOverData = nil
        } else {
            data = incomingData
        }
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
                debugPrint("PacketAnalyzer.analyze: fractional packet at position \(position) expected length \(packetLength) total size \(data.count) saving for next round")
                self.leftOverData = data[(position..<data.count)]
                return
            }
            let range = (position..<position + packetLength)
            let thisPacket = data.subdata(in: range)
            //data.removeSubrange(range)
            //let thisPacket = data[position..<position+packetLength]
            self.analyzeOnePacket(data: thisPacket)
            position = position + packetLength
        } while position < data.count
    }*/
    
    func analyze(incomingData: Data) {
        var data: Data
        if let leftOverData = leftOverData {
            data = leftOverData + incomingData
            self.leftOverData = nil
        } else {
            data = incomingData
        }
        repeat {
            guard let packetType: UInt8 = data.first else {
                debugPrint("PacketAnalyzer.analyze is done")
                return
            }
            guard let packetLength = PACKET_SIZES[safe: Int(packetType)] else {
                debugPrint("Warning: PacketAnalyzer.analyze received invalid packet type \(packetType) dumping data")
                printData(data, success: false)
                return
            }
            guard packetLength > 0 else {
                debugPrint("PacketAnalyzer invalid packet length \(packetLength) type \(packetType)")
                printData(data, success: false)
                return
            }
            guard data.count >= packetLength else {
                debugPrint("PacketAnalyzer.analyze: fractional packet expected length \(packetLength) remaining size \(data.count) saving for next round")
                self.leftOverData = data
                return
            }
            let range = (data.startIndex..<data.startIndex + packetLength)
            let thisPacket = data.subdata(in: range)
            self.analyzeOnePacket(data: thisPacket)
            data.removeFirst(packetLength)
        } while data.count > 0
    }

    func printData(_ data: Data, success: Bool) {
        var dumpString = "\(success) "
        for byte in data {
            let addString = String(format:"%x ",byte)
            dumpString += addString
        }
        debugPrint(dumpString)
    }
    func analyzeOnePacket(data: Data) {
        guard data.count > 0 else {
            debugPrint("PacketAnalyer.analyzeOnePacket data length 0")
            return
        }
        let packetType: UInt8 = data[0]
        guard let packetLength = PACKET_SIZES[safe: Int(packetType)] else {
            debugPrint("Warning: PacketAnalyzer.analyzeOnePacket received invalid packet type \(packetType)")
            printData(data, success: false)
            return
        }
        guard packetLength > 0 else {
            debugPrint("PacketAnalyzer.analyzeOnePacket invalid packet length \(packetLength) type \(packetType)")
            printData(data, success: false)
            return
        }
        guard packetLength == data.count else {
            debugPrint("PacketAnalyzer.analyeOnePacket unexpected data length \(data.count) expected \(packetLength) type \(packetType)")
            printData(data, success: false)
            return
        }
        switch packetType {
            
        case 2:
            //SP_PLAYER_INFO
            let playerID = Int(data[1])
            let shipType = Int(data[2])
            let team = Int(data[3])
            guard let player = universe.players[safe: playerID] else {
                debugPrint("PacketAnalyzer type 2 invalid player id \(playerID)")
                printData(data, success: false)
                return
            }
            player.ship = shipType
            player.team = team
            printData(data, success: true)

            //debugPrint(player)
        
        case 3:
            // SP_KILLS
            let playerID = Int(data[1])
            let killsInt = data.subdata(in: (4..<8)).to(type: UInt32.self)
            let kills: Double = Double(killsInt) / 100.0
            guard let player = universe.players[safe: playerID] else {
                debugPrint("PacketAnalyzer type 2 invalid player id \(playerID)")
                printData(data, success: false)
                return
            }
            player.kills = kills
            printData(data, success: true)
            //debugPrint(player)

        case 4:
            // SP_PLAYER py-struct
            let playerID = Int(data[1])
            let direction = Int(data[2])
            let speed = Int(data[3])
            let locationX = data.subdata(in: (4..<8)).to(type: UInt32.self)
            let locationY = data.subdata(in: (4..<8)).to(type: UInt32.self)
            guard let player = universe.players[safe: playerID] else {
                debugPrint("PacketAnalyzer type 4 invalid player id \(playerID)")
                printData(data, success: false)

                return
            }
            player.direction = direction
            player.speed = speed
            player.locationX = Int(locationX)
            player.locationY = Int(locationY)
            //debugPrint(player)
            printData(data, success: true)


        case 11:
            // message
            let range = (4..<84)
            let messageData = data.subdata(in: range)
            if let messageStringWithNulls = String(data: messageData, encoding: .utf8) {
                var messageString = messageStringWithNulls.filter { $0 != "\0" }
                messageString.append("\n")
                appDelegate.messageViewController?.gotMessage(messageString)
                //debugPrint(messageString)
                printData(data, success: true)
            } else {
                debugPrint("PacketAnalyzer unable to decode message type 11")
                printData(data, success: false)

            }
        case 12:
            // My information
            // SP_YOU length 32
            let myPlayerID = Int(data[1])
            let hostile = Int(data[2])
            let war = Int(data[3])
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
            debugPrint("I am player \(myPlayerID) damage \(damage) fuel \(fuel) \(engineTemp)\n")
            guard let me = universe.players[safe: myPlayerID] else {
                debugPrint("PacketAnalyzer cannot find myPlayerID \(myPlayerID)")
                printData(data, success: false)
                return
            }
            universe.me = me
            me.playerID = myPlayerID
            me.hostile = hostile
            me.war = war
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
            appDelegate.newGameState(.serverSlotFound)
            //debugPrint(me.description)
            printData(data, success: true)

        case 13:
            // SP_QUEUE
            let queue = data.subdata(in: (2..<3)).to(type: UInt16.self)
            appDelegate.messageViewController?.gotMessage("Connected to server. Wait queue position \(queue)")
            printData(data, success: true)


        case 17:
            // SP_LOGIN
            let accept = Int(data[1])
            let paradise1 = Int(data[2])
            let paradise2 = Int(data[3])
            let flags = data.subdata(in: (4..<8)).to(type: UInt32.self)
            let keymap = data.subdata(in: (8..<96))
            
            if paradise1 == 69 && paradise2 == 42 {
                appDelegate.messageViewController?.gotMessage("paradise server not supported")
                appDelegate.newGameState(.noServerSelected)
            }
            if accept == 0 {   // login failed
                appDelegate.messageViewController?.gotMessage("login failed")
                appDelegate.newGameState(.noServerSelected)
            } else {
                appDelegate.newGameState(.loginAccepted)
            }
            printData(data, success: true)

        case 18:
            //SP_FLAGS
            let playerID = Int(data[1])
            let tractor = Int(data[2])
            let flags = data.subdata(in: (4..<8)).to(type: UInt32.self)

            guard let player = universe.players[safe: playerID] else {
                debugPrint("PacketAnalyzer type 18 invalid player id \(playerID)")
                printData(data, success: false)

                return
            }
            player.tractor = tractor
            player.flags = flags
            //debugPrint(player)
            printData(data, success: true)

        case 20:
            // SP_PSTATUS
            let playerID = Int(data[1])
            let status = Int(data[2])
            guard let player = universe.players[safe: playerID] else {
                debugPrint("PacketAnalyzer type 20 invalid player id \(playerID)")
                printData(data, success: false)

                return
            }
            player.status = Int(status)
            //debugPrint(player)
            printData(data, success: true)


        case 22:
            let playerID = Int(data[1])
            let war = Int(data[2])
            let hostile = Int(data[3])
            guard let player = universe.players[safe: playerID] else {
                debugPrint("PacketAnalyzer type 22 invalid player id \(playerID)")
                printData(data, success: false)

                return
            }
            player.war = war
            player.hostile = hostile
            //debugPrint(player)
            printData(data, success: true)

            
        case 24:
            //plyr_long_spacket SP_PL_LOGIN
            // new player logged in
            let playerID = Int(data[1])
            let rank = Int(data[2])
            let nameData = data.subdata(in: (4..<20))
            var name = "unknown"
            if let nameStringWithNulls = String(data: nameData, encoding: .utf8) {
                name = nameStringWithNulls.filter { $0 != "\0" }
            }
            let monitorData = data.subdata(in: (20..<36))
            var monitor = "unknown"
            if let monitorStringWithNulls = String(data: monitorData, encoding: .utf8) {
                monitor = monitorStringWithNulls.filter { $0 != "\0" }
            }
            let loginData = data.subdata(in: (36..<52))
            var login = "unknown"
            if let loginStringWithNulls = String(data: loginData, encoding: .utf8) {
                login = loginStringWithNulls.filter { $0 != "\0" }
            }
            guard let player = universe.players[safe: playerID] else {
                debugPrint("PacketAnalyzer type 24 invalid player id \(playerID)")
                printData(data, success: false)

                return
            }
            player.rank = rank
            player.name = name
            //monitor
            player.login = login
            printData(data, success: true)

            //debugPrint("PacketAnalyzer: received packet type 24: player login")
            //debugPrint(player)
        case 26:
            // SP_PLANET_LOC
            let planetID = Int(data[1])
            let positionX = Int(data.subdata(in: (4..<8)).to(type: UInt32.self).byteSwapped)
            let positionY = Int(data.subdata(in: (8..<12)).to(type: UInt32.self).byteSwapped)
            let nameData = data.subdata(in: (12..<28))
            var name = "unknown"
            if let nameStringWithNulls = String(data: nameData, encoding: .utf8) {
                name = nameStringWithNulls.filter { $0 != "\0" }
            }
            universe.updatePlanet(planetID: planetID, positionX: positionX, positionY: positionY, name: name)
            if let planet = universe.planets[safe: planetID] {
                //debugPrint(planet)
            }
            printData(data, success: true)


        default:
            debugPrint("Default case: Received packet type \(packetType) length \(packetLength)\n")
            printData(data, success: true)

        }
    }
}
