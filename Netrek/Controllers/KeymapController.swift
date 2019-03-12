//
//  KeymapController.swift
//  Netrek
//
//  Created by Darrell Root on 3/8/19.
//  Copyright © 2019 Network Mom LLC. All rights reserved.
//

import Foundation
import AppKit

enum Control: String {
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
    case otherMouse = "other mouse button (center)"
    case rightMouse = "right mouse button and control-click"
    case fKey = "f key"
    case lKey = "l key"
    case sKey = "s key"
    case uKey = "u key"
    case QKey = "Q key"
    case asteriskKey = "* key"
}

enum Command: String {
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
    case fireTorpedo = "Fire torpedo"
    case firePlasma = "Fire plasma"
    case fireLaser = "Fire laser"
    case lockDestination = "Lock onto Destination"
    case toggleShields = "Toggle shields"
    case raiseShields = "Raise shields"
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
            .fKey:.firePlasma,
            .lKey:.lockDestination,
            .sKey:.toggleShields,
            .uKey:.raiseShields,
            .QKey:.quitGame,
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
                }

            case .raiseShields:
                let cpShield = MakePacket.cpShield(up: true)
                appDelegate.reader?.send(content: cpShield)
            
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
    func setSpeed(_ speed: Int) {
        if let cpSpeed = MakePacket.cpSpeed(speed: speed) {
            appDelegate.reader?.send(content: cpSpeed)
        }
    }

}
