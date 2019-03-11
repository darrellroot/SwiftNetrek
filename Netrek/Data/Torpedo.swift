//
//  Torpedo.swift
//  Netrek
//
//  Created by Darrell Root on 3/5/19.
//  Copyright © 2019 Network Mom LLC. All rights reserved.
//

import Foundation
import SpriteKit

class Torpedo {
    
    let appDelegate = NSApplication.shared.delegate as! AppDelegate

    var torpedoNumber: Int = 0
    var status: UInt8 = 0
    //public var displayed: Bool = false
    private(set) var war: [Team:Bool] = [:]
    var directionNetrek: Int = 0  // netrek format direction for now
    var direction: Double = 0.0 // in radians
    var positionX: Int = 0
    var positionY: Int = 0
    private(set) var lastPositionX: Int = 0
    private(set) var lastPositionY: Int = 0
    private(set) var lastUpdateTime = Date()
    private(set) var updateTime = Date()
    var torpedoNode = SKSpriteNode(color: .red,
                                   size: CGSize(width: NetrekMath.torpedoSize, height: NetrekMath.torpedoSize))

    
    func update(war: UInt8, status: UInt8) {
        for team in Team.allCases {
            if UInt8(team.rawValue) & war != 0 {
                self.war[team] = true
            } else {
                self.war[team] = false
            }
        }

        self.status = status
/*        switch status {
        case 0:
            self.torpedoNode.removeFromParent()
        case 1:
            if torpedoNode.parent == nil {
                // initialize torpedo
                var torpedoColor = NSColor.red
                if let me = appDelegate.universe.me {
                    let myTeam = me.team
                    if let warWithMe = self.war[myTeam] {
                        if !warWithMe {
                            torpedoColor = NSColor.green
                        }
                    }
                }
                self.torpedoNode = SKSpriteNode(color: torpedoColor, size: CGSize(width: NetrekMath.torpedoSize, height: NetrekMath.torpedoSize))
                torpedoNode.zPosition = ZPosition.torpedo.rawValue
            appDelegate.tacticalViewController?.scene.addChild(torpedoNode)
            }
        case 2:
            debugPrint("torpedo status 2") // it hit someone
        default:
            debugPrint("torpedo status unknown \(status)")
        }
 */
    }
    func update(directionNetrek: Int, positionX: Int, positionY: Int) {
        if self.status == 0 {
            return
        }
        self.lastPositionX = self.positionX
        self.lastPositionY = self.positionY
        self.lastUpdateTime = self.updateTime
        self.updateTime = Date()
        self.positionX = positionX
        self.positionY = positionY
/*
        self.directionNetrek = directionNetrek
        self.direction = ( Double.pi * 2 ) * Double(directionNetrek) / 256.0
        self.torpedoNode.position = CGPoint(x: self.positionX, y: self.positionY)
        
        if self.positionX > 0 && self.positionX < NetrekMath.galacticSize && self.positionY > 0 && self.positionY < NetrekMath.galacticSize {
            let deltaX = self.positionX - self.lastPositionX
            let deltaY = self.positionY - self.lastPositionY
            let deltaTime = self.updateTime.timeIntervalSince(self.lastUpdateTime)
            if deltaX < NetrekMath.actionThreshold && deltaY < NetrekMath.actionThreshold && deltaTime < 2.0 && deltaTime > 0.04 {
                let action = SKAction.moveBy(x: CGFloat(deltaX), y: CGFloat(deltaY), duration: deltaTime)
                if self.torpedoNode.hasActions() {
                    self.torpedoNode.removeAllActions()
                }
                self.torpedoNode.run(action)
            }
        }*/
    }
}
