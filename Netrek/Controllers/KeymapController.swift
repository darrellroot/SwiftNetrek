//
//  KeymapController.swift
//  Netrek
//
//  Created by Darrell Root on 3/8/19.
//  Copyright © 2019 Network Mom LLC. All rights reserved.
//

import Foundation
import AppKit

enum Control: String, CaseIterable {
    case zeroKey = "0 key"
    case oneKey = "1 key"
    case twoKey = "2 key"
    case threeKey = "3 key"
    case fourKey = "4 key"
    case fiveKey = "5 key"
    case sixKey = "6 key"
    case sevenKey = "7 key"
    case eightKey = "8 key"
    case nineKey = "9 key"
    case leftMouse = "left mouse button"
    case otherMouse = "center mouse button"
    case rightMouse = "right mouse button"
    case bKey = "b key"
    case cKey = "c key"
    case dKey = "d key"
    case fKey = "f key"
    case lKey = "l key"
    case oKey = "o key"
    case rKey = "r key"
    case sKey = "s key"
    case uKey = "u key"
    case xKey = "x key"
    case yKey = "y key"
    case zKey = "z key"
    case CKey = "C key"
    case DKey = "D key"
    case QKey = "Q key"
    case RKey = "R key"
    case TKey = "T key"
    case asteriskKey = "* key"
}

enum Command: String, CaseIterable {
    case speedZero = "Set speed 0"
    case speedOne = "Set speed 1"
    case speedTwo = "Set speed 2"
    case speedThree = "Set speed 3"
    case speedFour = "Set speed 4"
    case speedFive = "Set speed 5"
    case speedSix = "Set speed 6"
    case speedSeven = "Set speed 7"
    case speedEight = "Set speed 8"
    case speedNine = "Set speed 9"
    case setCourse = "Set course"
    case beamUp = "Beam up armies"
    case beamDown = "Beam down armies"
    case bomb = "Bomb"
    case cloak = "Toggle cloak"
    case coup = "Coup own home planet"
    case detOwn = "Detonate own torpedoes"
    case detEnemy = "Detonate enemy torpedoes"
    case fireTorpedo = "Fire torpedo"
    case firePlasma = "Fire plasma"
    case fireLaser = "Fire laser"
    case lockDestination = "Lock onto Destination"
    case orbit = "Orbit"
    case pressorBeam = "Pressor beam"
    case raiseShields = "Raise shields"
    case refit = "Refit (unused: use launch ship menu)"
    case repair = "Repair"
    case toggleShields = "Toggle shields"
    case tractorBeam = "Tractor beam"
    case quitGame = "Self destruct and quit game"
    case practiceRobot = "Send in practice robot"
}

class KeymapController {
    
    let appDelegate = NSApplication.shared.delegate as! AppDelegate

    var keymap: [Control:Command] = [:]

    init() {
        self.setDefaults()
    }
    
    func setDefaults() {
        keymap = [:]
        keymap = [
            .zeroKey:.speedZero,
            .oneKey:.speedOne,
            .twoKey:.speedTwo,
            .threeKey:.speedThree,
            .fourKey:.speedFour,
            .fiveKey:.speedFive,
            .sixKey:.speedSix,
            .sevenKey:.speedSeven,
            .eightKey:.speedEight,
            .nineKey:.speedNine,
            .bKey:.bomb,
            .cKey:.cloak,
            .dKey:.detEnemy,
            .fKey:.firePlasma,
            .lKey:.lockDestination,
            .oKey:.orbit,
            .rKey:.refit,
            .sKey:.toggleShields,
            .uKey:.raiseShields,
            .xKey:.beamDown,
            .yKey:.pressorBeam,
            .zKey:.beamUp,
            .DKey:.detOwn,
            .QKey:.quitGame,
            .RKey:.repair,
            .TKey:.tractorBeam,
            .leftMouse:.fireTorpedo,
            .otherMouse:.fireLaser,
            .rightMouse:.setCourse,
            .asteriskKey:.practiceRobot,
        ]
    }
    func execute(_ control: Control, location: CGPoint?) {
        if let command = keymap[control] {
            switch command {
                
            case .speedZero:
                self.setSpeed(0)
            case .speedOne:
                self.setSpeed(1)
            case .speedTwo:
                self.setSpeed(2)
            case .speedThree:
                self.setSpeed(3)
            case .speedFour:
                self.setSpeed(4)
            case .speedFive:
                self.setSpeed(5)
            case .speedSix:
                self.setSpeed(6)
            case .speedSeven:
                self.setSpeed(7)
            case .speedEight:
                self.setSpeed(8)
            case .speedNine:
                self.setSpeed(9)
            case .beamUp:
                let cpBeam = MakePacket.cpBeam(state: true)
                appDelegate.reader?.send(content: cpBeam)
            case .beamDown:
                let cpBeam = MakePacket.cpBeam(state: false)
                appDelegate.reader?.send(content: cpBeam)
            case .bomb:
                if let bombState = appDelegate.universe.me?.bomb {
                    let cpBomb = MakePacket.cpRepair(state: !bombState )
                    appDelegate.reader?.send(content: cpBomb)
                }
            case .cloak:
                if let cloakState = appDelegate.universe.me?.cloak {
                    let cpCloak = MakePacket.cpCloak(state: !cloakState )
                    appDelegate.reader?.send(content: cpCloak)
                    appDelegate.soundController.play(sound: .shield, volume: 1.0)
                }

            case .coup:
                let cpCoup = MakePacket.cpCoup()
                appDelegate.reader?.send(content: cpCoup)
                
            case .detEnemy:
                let cpDetTorps = MakePacket.cpDetTorps()
                appDelegate.reader?.send(content: cpDetTorps)
            appDelegate.soundController.play(sound: .detonate, volume: 0.5)

            case .detOwn:
                guard let me = appDelegate.universe.me else { return }
                for count in 0..<8 {
                    let myTorpNum = UInt8(me.playerID * 8 + count)
                    let cpDetMyTorps = MakePacket.cpDetMyTorps(torpNum: myTorpNum)
                    appDelegate.reader?.send(content: cpDetMyTorps)
                }
                appDelegate.soundController.play(sound: .detonate, volume: 0.5)
            case .refit:
                appDelegate.messageViewController?.gotMessage("To refit, orbit home planet and select LAUNCH SHIP menu item")
                break
            case .setCourse:
                guard let location = location else {
                    debugPrint("KeymapController.execute.setCourse location is nil...holding steady")
                    return
                }
                if let me = appDelegate.universe.me {
                    let netrekDirection = NetrekMath.calculateNetrekDirection(mePositionX: Double(me.positionX), mePositionY: Double(me.positionY), destinationX: Double(location.x), destinationY: Double(location.y))
                    if let cpDirection = MakePacket.cpDirection(netrekDirection: netrekDirection) {
                        appDelegate.reader?.send(content: cpDirection)
                    }
                }

            case .toggleShields:
                if let shieldsUp = appDelegate.universe.me?.shieldsUp {
                    if shieldsUp {
                        let cpShield = MakePacket.cpShield(up: false)
                        appDelegate.reader?.send(content: cpShield)
                    } else {
                        let cpShield = MakePacket.cpShield(up: true)
                        appDelegate.reader?.send(content: cpShield)
                    }
                    appDelegate.soundController.play(sound: .shield, volume: 1.0)
                }
            case .tractorBeam:
                debugPrint("TractorBeam location \(String(describing: location))")
                guard let targetLocation = location else {
                    debugPrint("KeymapController.execute.tractorBeam location is nil...cannot lock onto nothing")
                    return
                }
                guard let target = findClosestPlayer(location: targetLocation) else {
                    return
                }
                guard let me = appDelegate.universe.me else { return }
                if target.me == true { return }
                guard target.playerID >= 0 else { return }
                guard target.playerID < 256 else { return }
                let playerID = UInt8(target.playerID)
                let cpTractor = MakePacket.cpTractor(on: !me.tractorFlag, playerID: playerID)
                    appDelegate.reader?.send(content: cpTractor)
            case .pressorBeam:
                debugPrint("PressorBeam location \(String(describing: location))")
                guard let targetLocation = location else {
                    debugPrint("KeymapController.execute.pressorBeam location is nil...cannot lock onto nothing")
                    return
                }
                guard let target = findClosestPlayer(location: targetLocation) else {
                    return
                }
                guard let me = appDelegate.universe.me else { return }
                if target.me == true { return }
                guard target.playerID >= 0 else { return }
                guard target.playerID < 256 else { return }
                let playerID = UInt8(target.playerID)
                let cpPressor = MakePacket.cpPressor(on: !me.pressor, playerID: playerID)
                appDelegate.reader?.send(content: cpPressor)

            case .orbit:
                if let orbitState = appDelegate.universe.me?.orbit {
                    let cpOrbit = MakePacket.cpOrbit(state: !orbitState)
                    appDelegate.reader?.send(content: cpOrbit)

                }
            case .raiseShields:
                let cpShield = MakePacket.cpShield(up: true)
                appDelegate.reader?.send(content: cpShield)
                appDelegate.soundController.play(sound: .shield, volume: 1.0)
            
            case .repair:
                if let repairState = appDelegate.universe.me?.repair {
                    let cpRepair = MakePacket.cpRepair(state: !repairState )
                    appDelegate.reader?.send(content: cpRepair)
                }
            case .fireLaser:
                debugPrint("FireLaser location \(String(describing: location))")
                guard let targetLocation = location else {
                    debugPrint("KeymapController.execute.fireLaser location is nil...holding fire")
                    return
                }
                if let me = appDelegate.universe.me {
                    let netrekDirection = NetrekMath.calculateNetrekDirection(mePositionX: Double(me.positionX), mePositionY: Double(me.positionY), destinationX: Double(targetLocation.x), destinationY: Double(targetLocation.y))
                    let cpLaser = MakePacket.cpLaser(netrekDirection: netrekDirection)
                    appDelegate.reader?.send(content: cpLaser)
                }

            case .fireTorpedo:
                debugPrint("RightMouseDown location \(String(describing: location))")
                guard let targetLocation = location else {
                    debugPrint("KeymapController.execute.fireTorpedo location is nil...holding fire")
                    return
                }
                if let me = appDelegate.universe.me {
                    let netrekDirection = NetrekMath.calculateNetrekDirection(mePositionX: Double(me.positionX), mePositionY: Double(me.positionY), destinationX: Double(targetLocation.x), destinationY: Double(targetLocation.y))
                    let cpTorp = MakePacket.cpTorp(netrekDirection: netrekDirection)
                    appDelegate.reader?.send(content: cpTorp)
                 }
            case .firePlasma:
                debugPrint("firePlasma location \(String(describing: location))")
                guard let targetLocation = location else {
                    debugPrint("KeymapController.execute.firePlasma location is nil...holding fire")
                    return
                }
                if let me = appDelegate.universe.me {
                    let netrekDirection = NetrekMath.calculateNetrekDirection(mePositionX: Double(me.positionX), mePositionY: Double(me.positionY), destinationX: Double(targetLocation.x), destinationY: Double(targetLocation.y))
                    let cpPlasma = MakePacket.cpPlasma(netrekDirection: netrekDirection)
                    appDelegate.reader?.send(content: cpPlasma)
                }
            case .quitGame:
                debugPrint("Quitting game")
                let cpQuit = MakePacket.cpQuit()
                appDelegate.reader?.send(content: cpQuit)
            case .practiceRobot:
                debugPrint("Requesting practice robot")
                let cpPractice = MakePacket.cpPractice()
                appDelegate.reader?.send(content: cpPractice)
            case .lockDestination:
                guard let lockLocation = location else {
                    debugPrint("KeymapController.execute.lockDestination location is nil...awaiting instructions")
                    return
                }
                let lockLocationX = Int(lockLocation.x)
                let lockLocationY = Int(lockLocation.y)
                var closestPlanetDistance = 10000
                var closestPlanet: Planet?
                var closestPlayerDistance = 10000
                var closestPlayer: Player?
                
                for planet in appDelegate.universe.planets.values {
                    let thisPlanetDistance = abs(planet.positionX - lockLocationX) + abs(planet.positionY - lockLocationY)
                    if thisPlanetDistance < closestPlanetDistance {
                        closestPlanetDistance = thisPlanetDistance
                        closestPlanet = planet
                    }
                }
                for player in appDelegate.universe.players.values {
                    if player.me == false {
                        let thisPlayerDistance = abs(player.positionX - lockLocationX) + abs(player.positionY - lockLocationY)
                        if thisPlayerDistance < closestPlayerDistance {
                            closestPlayerDistance = thisPlayerDistance
                            closestPlayer = player
                        }
                    }
                }
                if closestPlayerDistance < closestPlanetDistance {
                    // lock onto player
                    guard let player = closestPlayer else { return }
                    guard player.playerID > 0 && player.playerID < 256 else {
                        debugPrint("keymap.playerlock invalid playerID \(player.playerID)")
                        return
                    }
                    let cpPlayerLock = MakePacket.cpPlayerLock(playerID: UInt8(player.playerID))
                    appDelegate.reader?.send(content: cpPlayerLock)
                } else {
                    guard let planet = closestPlanet else { return }
                    guard planet.planetID > 0 && planet.planetID < 256 else {
                        debugPrint("keymap.planetlock invalid planetID \(planet.planetID)")
                        return
                    }
                    let cpPlanetLock = MakePacket.cpPlanetLock(planetID: UInt8(planet.planetID))
                    appDelegate.reader?.send(content: cpPlanetLock)
                }
            }
        }
    }
    private func findClosestPlayer(location: CGPoint) -> Player? {
        var closestPlayerDistance = 10000
        var closestPlayer: Player?
        for player in appDelegate.universe.players.values {
            if player.me == false {
                let thisPlayerDistance = abs(player.positionX - Int(location.x)) + abs(player.positionY - Int(location.y))
                if thisPlayerDistance < closestPlayerDistance {
                    closestPlayerDistance = thisPlayerDistance
                    closestPlayer = player
                }
            }
        }
        return closestPlayer
    }
    func setSpeed(_ speed: Int) {
        if let cpSpeed = MakePacket.cpSpeed(speed: speed) {
            appDelegate.reader?.send(content: cpSpeed)
        }
    }

}
