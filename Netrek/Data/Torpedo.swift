//
//  Torpedo.swift
//  Netrek
//
//  Created by Darrell Root on 3/5/19.
//  Copyright © 2019 Network Mom LLC. All rights reserved.
//

import Foundation
class Torpedo {
    var torpedoNumber: Int = 0
    var status: UInt8 = 0
    var war: UInt8 = 0
    var directionNetrek: Int = 0  // netrek format direction for now
    var direction: Double = 0.0 // in radians
    var positionX: Int = 0
    var positionY: Int = 0
    
    func update(war: UInt8, status: UInt8) {
        self.war = war
        self.status = status
    }
    func update(directionNetrek: Int, positionX: Int, positionY: Int) {
        self.positionX = positionX
        self.positionY = positionY
        self.directionNetrek = directionNetrek
        self.direction = ( Double.pi * 2 ) * Double(directionNetrek) / 256.0
    }
}
