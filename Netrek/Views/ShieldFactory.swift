//
//  ShieldFactory.swift
//  Netrek
//
//  Created by Darrell Root on 3/12/19.
//  Copyright © 2019 Network Mom LLC. All rights reserved.
//

import Cocoa
import SpriteKit

class ShieldFactory: SKView {

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        // Drawing code here.
    }
    func shieldTexture() -> SKTexture? {
        let shieldNode = SKShapeNode(circleOfRadius: CGFloat(NetrekMath.playerSize)/1.8)
        shieldNode.lineWidth = CGFloat(NetrekMath.playerSize) / 10.0
        //shieldNode.lineWidth = CGFloat(NetrekMath.playerSize)
        shieldNode.strokeColor = .white
        let shieldTexture = self.texture(from: shieldNode)

        return shieldTexture
    }
    
}
