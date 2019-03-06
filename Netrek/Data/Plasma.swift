//
//  Plasma.swift
//  Netrek
//
//  Created by Darrell Root on 3/5/19.
//  Copyright © 2019 Network Mom LLC. All rights reserved.
//

import Foundation
class Plasma {
    private(set) var status = 0
    private(set) var war = 0
    private(set) var directionNetrek = 0
    private(set) var direction = 0.0
    private(set) var positionX = 0
    private(set) var positionY = 0
    
    //from SP_PLASMA_INFO 8
    public func update(war: Int, status: Int) {
        self.war = war
        self.status = status
    }
    // from SP_PLASMA 9
    public func update(positionX: Int, positionY: Int) {
        self.positionX = positionX
        self.positionY = positionY
    }
}
