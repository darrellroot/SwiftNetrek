//
//  Laser.swift
//  Netrek
//
//  Created by Darrell Root on 3/5/19.
//  Copyright © 2019 Network Mom LLC. All rights reserved.
//

import Foundation
import SpriteKit

class Laser {
    let appDelegate = NSApplication.shared.delegate as! AppDelegate

    private(set) var status = 0
    private(set) var directionNetrek: UInt8 = 0 // 256= full circle
    private(set) var direction = 0.0 //radians
    private(set) var positionX = 0
    private(set) var positionY = 0
    private(set) var target = 0
    var laserNode = SKShapeNode()
    //let waitAction = SKAction.wait(forDuration: 1.0)
    //let removeAction = SKAction.removeFromParent()
    let laserAction = SKAction.sequence([SKAction.wait(forDuration: 1.0),SKAction.removeFromParent()])
    let laserRange = 600.0 // game units
    
    
    public func update(status: Int, directionNetrek: UInt8, positionX: Int, positionY: Int, target: Int) {
        self.status = status
        self.directionNetrek = directionNetrek
        self.direction = 2.0 * Double.pi * Double(directionNetrek) / 256.0
        self.positionX = positionX
        self.positionY = positionY
        self.target = target
        if self.status != 0 {
            self.displayLaser()
        }
    }
    public func displayLaser() {
        let point1 = CGPoint(x: self.positionX, y: self.positionY)
        switch self.status{
            
        /*case 1: // hit
            if let target = appDelegate.universe.players[target] {
                let point2 = CGPoint(x: target.positionX, y: target.positionY)
            var points = [point1, point2]
            laserNode = SKShapeNode(points: &points, count: 2)
            laserNode.strokeColor = .red
            laserNode.lineWidth = 10
                DispatchQueue.main.async {
                    self.appDelegate.tacticalViewController?.scene.addChild(self.laserNode)
                    self.laserNode.run(self.laserAction)
                }
            }*/
        case 1,2,4: // miss
            self.direction = NetrekMath.directionNetrek2radian(self.directionNetrek)
            let targetX = Double(self.positionX) - cos(self.direction) * laserRange
            let targetY = Double(self.positionY) - sin(self.direction) * laserRange
            let point2 = CGPoint(x: targetX, y: targetY)
            var points = [point1, point2]
            laserNode = SKShapeNode(points: &points, count: 2)
            laserNode.strokeColor = .red
            laserNode.lineWidth = 10
            DispatchQueue.main.async {
                debugPrint("displaying laser positionX \(self.positionX) positionY \(self.positionY) targetX \(targetX) targetY \(targetY)")
                self.appDelegate.tacticalViewController?.scene.addChild(self.laserNode)
                self.laserNode.run(self.laserAction)
            }
        /*case 4: // hit plasma
            break*/

        default: // should not get here
            debugPrint("Laser.displayLaser invalid status \(status)")
        }
    }
    
}
