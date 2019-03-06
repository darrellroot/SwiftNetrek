//
//  Laser.swift
//  Netrek
//
//  Created by Darrell Root on 3/5/19.
//  Copyright © 2019 Network Mom LLC. All rights reserved.
//

import Foundation

class Laser {
    private(set) var status = 0
    private(set) var directionNetrek = 0 // 256= full circle
    private(set) var direction = 0.0 //radians
    private(set) var positionX = 0
    private(set) var positionY = 0
    private(set) var target = 0
    
    public func update(status: Int, directionNetrek: Int, positionX: Int, positionY: Int, target: Int) {
        self.status = status
        self.directionNetrek = directionNetrek
        self.direction = 2.0 * Double.pi * Double(directionNetrek) / 256.0
        self.positionX = positionX
        self.positionY = positionY
        self.target = target
    }
}
