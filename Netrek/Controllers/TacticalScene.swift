//
//  TacticalScene.swift
//  Netrek
//
//  Created by Darrell Root on 3/6/19.
//  Copyright © 2019 Network Mom LLC. All rights reserved.
//

import Cocoa
import SpriteKit

class TacticalScene: SKScene {
    let appDelegate = NSApplication.shared.delegate as! AppDelegate

    override func mouseDown(with event: NSEvent) {
        

        switch event.type {
        case .leftMouseDown:
            let location = event.location(in: self)
            debugPrint("LeftMouseDown location \(location)")
            if let me = appDelegate.universe.me {
                let netrekDirection = NetrekMath.calculateNetrekDirection(mePositionX: Double(me.positionX), mePositionY: Double(me.positionY), destinationX: Double(location.x), destinationY: Double(location.y))
                if let cpDirection = MakePacket.cpDirection(netrekDirection: netrekDirection) {
                    appDelegate.reader?.send(content: cpDirection)
                }
            }

        case .otherMouseDown:
            let location = event.location(in: self)
            debugPrint("CenterMouseDown location \(location)")
        case .rightMouseDown:
            let location = event.location(in: self)
            debugPrint("RightMouseDown location \(location)")
        default:
            break
        }
    }
    
    override func keyDown(with event: NSEvent) {
        debugPrint("TacticalScene.keyDown characters \(String(describing: event.characters))")
        switch event.characters?.first {
        case "0":
            setSpeed(0)
        case "1":
            setSpeed(1)
        case "2":
            setSpeed(2)
        case "3":
            setSpeed(3)
        case "4":
            setSpeed(4)
        case "5":
            setSpeed(5)
        case "6":
            setSpeed(6)
        case "7":
            setSpeed(7)
        case "8":
            setSpeed(8)
        case "9":
            setSpeed(9)
        case "s":
            if let shieldsUp = appDelegate.universe.me?.shieldsUp {
                if shieldsUp {
                    let cpShield = MakePacket.cpShield(up: false)
                    appDelegate.reader?.send(content: cpShield)
                } else {
                    let cpShield = MakePacket.cpShield(up: true)
                    appDelegate.reader?.send(content: cpShield)
                }
            }
        case "u":
            let cpShield = MakePacket.cpShield(up: true)
            appDelegate.reader?.send(content: cpShield)
        default:
            debugPrint("TacticalScene.keyDown unknown key \(String(describing: event.characters))")
        }
    }
    func setSpeed(_ speed: Int) {
        if let cpSpeed = MakePacket.cpSpeed(speed: speed) {
            appDelegate.reader?.send(content: cpSpeed)
        }
    }
    
}
