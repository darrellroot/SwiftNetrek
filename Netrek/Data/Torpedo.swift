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
    }
    func update(directionNetrek: Int, positionX: Int, positionY: Int) {
        if self.status == 0 {
            return
        }
        self.positionX = positionX
        self.positionY = positionY
    }
}
