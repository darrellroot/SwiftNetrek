//
//  HUDView.swift
//  Netrek
//
//  Created by Darrell Root on 3/9/19.
//  Copyright © 2019 Network Mom LLC. All rights reserved.
//

import Cocoa

class HUDView: NSView {
    
    let appDelegate = NSApplication.shared.delegate as! AppDelegate

    let attributes = [NSAttributedString.Key.font: NSFont(name: "Courier", size: 12.0)!,NSAttributedString.Key.foregroundColor: NSColor.white]
    
    override var isFlipped: Bool {
        return true
    }
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        NSColor.black.set()
        self.bounds.fill()
        
        guard let me = appDelegate.universe.me else {
            return
        }
        guard let myShipType = me.ship else {
            return
        }
        guard let myShipInfo = appDelegate.universe.shipInfo[myShipType] else {
            return
        }
        NSColor.white.set()
        let columns = 6
        let rows = 2
                
        for column in 0..<columns {
            for row in 0..<rows {
                let xPosition = (Int(self.bounds.width) / columns) * column + 5
                let yPosition = (Int(self.bounds.height) / rows) * row + 5
                switch (column,row) {
                case (0,0):
                    String("Speed \(me.speed)").draw(at: CGPoint(x: xPosition, y: yPosition), withAttributes: attributes)
                case (0,1):
                    String("MaxSpd \(myShipInfo.maxSpeed)").draw(at: CGPoint(x: xPosition, y: yPosition), withAttributes: attributes)
                case (1,0):
                    String("Fuel: \(me.fuel)").draw(at: CGPoint(x: xPosition, y: yPosition), withAttributes: attributes)
                case (1,1):
                    String("MaxFuel: \(myShipInfo.maxFuel)").draw(at: CGPoint(x: xPosition, y: yPosition), withAttributes: attributes)
                case (2,0):
                    String("Shield \(me.shieldStrength)").draw(at: CGPoint(x: xPosition, y: yPosition), withAttributes: attributes)
                case (2,1):
                    String("MaxShld \(myShipInfo.maxShield)").draw(at: CGPoint(x: xPosition, y: yPosition), withAttributes: attributes)
                case (3,0):
                    String("Damage \(me.damage)").draw(at: CGPoint(x: xPosition, y: yPosition), withAttributes: attributes)
                case (3,1):
                    String("MaxDmg \(myShipInfo.maxDamage)").draw(at: CGPoint(x: xPosition, y: yPosition), withAttributes: attributes)
                case (4,0):
                    String("EngTmp \(me.engineTemp)").draw(at: CGPoint(x: xPosition, y: yPosition), withAttributes: attributes)
                case (4,1):
                    String("MaxETmp \(myShipInfo.maxEngTmp)").draw(at: CGPoint(x: xPosition, y: yPosition), withAttributes: attributes)
                case (5,0):
                    String("WpnTemp \(me.weaponsTemp)").draw(at: CGPoint(x: xPosition, y: yPosition), withAttributes: attributes)
                case (5,1):
                    String("MaxWTmp \(myShipInfo.maxWpnTmp)").draw(at: CGPoint(x: xPosition, y: yPosition), withAttributes: attributes)
                default:
                    break
                }
            }
        }
        
    }
    
}
