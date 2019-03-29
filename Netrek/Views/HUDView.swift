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
        let columns = 5
        let rows = 2
                
        for column in 0..<columns {
            for row in 0..<rows {
                let xPosition = (Int(self.bounds.width) / columns) * column + 5
                let yPosition = (Int(self.bounds.height) / rows) * row + 5
                switch (column,row) {
                case (0,0):
                    String("Speed \(me.speed)/\(myShipInfo.maxSpeed)").draw(at: CGPoint(x: xPosition, y: yPosition), withAttributes: attributes)
                case (0,1):
                    String("Armies \(me.armies)").draw(at: CGPoint(x: xPosition, y: yPosition), withAttributes: attributes)
                case (1,0):
                    String("Fuel: \(me.fuel)").draw(at: CGPoint(x: xPosition, y: yPosition), withAttributes: attributes)
                case (1,1):
                    var specialStatus: String?
                    if me.tractorFlag {
                        specialStatus = "Tractor activated"
                    }
                    if me.pressor {
                        specialStatus = "Pressor Activated"
                    }
                    if me.enginesOverheated {
                        specialStatus = "Engines Out"
                    }
                    if me.repair {
                        specialStatus = "Repairing"
                    }
                    if me.bomb {
                        specialStatus = "Bombing"
                    }
                    if me.beamUp {
                        specialStatus = "Beaming Up"
                    }
                    if me.beamDown {
                        specialStatus = "Beaming Down"
                    }
                    if me.weaponsOverheated {
                        specialStatus = "Weapons Down"
                    }
                    if let specialStatus = specialStatus {
                        debugPrint("SpecialStatus \(specialStatus)")
                        specialStatus.draw(at: CGPoint(x: xPosition, y: yPosition), withAttributes: attributes)
                    }
                case (2,0):
                    String("Shield \(me.shieldStrength)").draw(at: CGPoint(x: xPosition, y: yPosition), withAttributes: attributes)
                case (2,1):
                    switch me.alertCondition {
                    case .green:
                        "Scan Clear".draw(at: CGPoint(x: xPosition, y: yPosition), withAttributes: attributes)
                    case .yellow:
                        "EnemyDetected".draw(at: CGPoint(x: xPosition, y: yPosition), withAttributes: attributes)
                    case .red:
                        "BattleStations".draw(at: CGPoint(x: xPosition, y: yPosition), withAttributes: attributes)
                    }
                case (3,0):
                    String("Damage \(me.damage)/\(myShipInfo.maxDamage)").draw(at: CGPoint(x: xPosition, y: yPosition), withAttributes: attributes)
                case (3,1):
                    "Kills: \(me.kills)".draw(at: CGPoint(x: xPosition, y: yPosition), withAttributes: attributes)
                case (4,0):
                    String("EngTmp \(me.engineTemp)/\(myShipInfo.maxEngTmp)").draw(at: CGPoint(x: xPosition, y: yPosition), withAttributes: attributes)
                case (4,1):
                    String("WpnTemp \(me.weaponsTemp)/\(myShipInfo.maxWpnTmp)").draw(at: CGPoint(x: xPosition, y: yPosition), withAttributes: attributes)
                case (5,0):
                    // not used, see # columns above
                    break
                case (5,1):
                    // not used, see # columns above
                    break
                    //String("MaxWTmp \(myShipInfo.maxWpnTmp)").draw(at: CGPoint(x: xPosition, y: yPosition), withAttributes: attributes)
                default:
                    break
                }
            }
        }
        
    }
    
}
