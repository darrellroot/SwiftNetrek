//
//  StrategicView.swift
//  Netrek
//
//  Created by Darrell Root on 3/9/19.
//  Copyright © 2019 Network Mom LLC. All rights reserved.
//

import Cocoa

let strategicFontKey = "strategicFont"

class StrategicView: NSView {
    
    let appDelegate = NSApplication.shared.delegate as! AppDelegate

    var fontSize = 9.0
    var font = NSFont(name: "Courier", size: 9.0)!
    var largeFont = NSFont(name: "Courier", size: 11.0)!
    func setFontSize(newSize: CGFloat) {
        if let font = NSFont(name: "Courier", size: newSize) {
            self.font = font
            appDelegate.defaults.set(Float(newSize), forKey: strategicFontKey)
        }
        if let largeFont = NSFont(name: "Courier-Bold", size: newSize + 2.0) {
            self.largeFont = largeFont
        }
        self.needsLayout = true
        self.needsDisplay = true
    }
    
    override func draw(_ dirtyRect: NSRect) {
        //super.draw(dirtyRect)
        debugPrint("StrategicView.draw)")
        
        let myTeam = appDelegate.universe.me?.team ?? .independent
        NSColor.black.set()
        self.bounds.fill()

        for planet in appDelegate.universe.planets.values {
            if planet.name == "Romulus" {
                let y = 1
            }
            let stratPosition = CGPoint(x: galXstratX(planet.positionX),y: galYstratY(planet.positionY))
            let prefix = String(planet.name.prefix(3))
            var attributes: [NSAttributedString.Key : NSObject]
            if planet.armies > 4 {
                attributes = [NSAttributedString.Key.font: largeFont,NSAttributedString.Key.baselineOffset: NSNumber(value: 4)]
            } else {
                attributes = [NSAttributedString.Key.font: font,NSAttributedString.Key.baselineOffset: NSNumber(value: 4)]
            }
            // select color
            /*if planet.armies > 4 {
                attributes.updateValue(NSNumber(value: -12), forKey: NSAttributedString.Key.strokeWidth  )
            }*/
            let color = NetrekMath.color(team: planet.owner)
            color.set()
            attributes.updateValue(color, forKey: NSAttributedString.Key.foregroundColor)
            prefix.draw(at: stratPosition, withAttributes: attributes)
            let size = prefix.size(withAttributes: attributes)
            let circleBox = NSRect(x: stratPosition.x - 0.25 * size.width, y: stratPosition.y - 0.25 * size.width, width: size.width * 1.5, height: size.width * 1.5)
            let circlePath = NSBezierPath(ovalIn: circleBox)
            circlePath.stroke()
        }
        for player in appDelegate.universe.players.values {
            drawPlayer(player)
        }

        // Drawing code here.
    }
    private func drawPlayer(_ player: Player) {
        let stratPosition = CGPoint(x: galXstratX(player.positionX),y: galYstratY(player.positionY))
        if Int(stratPosition.x) < 0 || Int(stratPosition.y) < 0 || Int(stratPosition.x) > NetrekMath.galacticSize || Int(stratPosition.y) > NetrekMath.galacticSize {
            return
        }
        if player.slotStatus != .alive {
            return
        }
        var attributes = [NSAttributedString.Key.font: font,NSAttributedString.Key.baselineOffset: NSNumber(value: 4)]
        let color: NSColor
        let playerString: String
        if player.cloak == true {
            color = NSColor.gray
            playerString = "??"
        } else {
            color = NetrekMath.color(team: player.team)
            let playerLetter = NetrekMath.playerLetter(playerID: player.playerID)
            let teamLetter = NetrekMath.teamLetter(team: player.team)
            playerString = teamLetter + playerLetter
        }
        attributes.updateValue(color, forKey: NSAttributedString.Key.foregroundColor)
        playerString.draw(at: stratPosition, withAttributes: attributes)
    }
    
    func galXstratX(_ galacticX: Int) -> Int {
        return (galacticX * Int(self.visibleRect.width)) / NetrekMath.galacticSize
    }
    func galYstratY(_ galacticY: Int) -> Int {
        return (galacticY * Int(self.visibleRect.height)) / (NetrekMath.galacticSize + 300)
    }
}
