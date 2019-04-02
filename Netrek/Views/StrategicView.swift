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
    var lastRightMouseDraggedTime = Date()
    var lastLeftMouseDraggedTime = Date()
    var lastOtherMouseDraggedTime = Date()

    override var acceptsFirstResponder: Bool {
        return true
    }
    override func acceptsFirstMouse(for event: NSEvent?) -> Bool {
        return true
    }
    override func otherMouseDown(with event: NSEvent) {
        let viewLocation = self.convert(event.locationInWindow, to: self)
        let galacticLocation = view2Galactic(location: viewLocation)
        debugPrint("StrategicView: OtherMouseDown location \(galacticLocation)")
        appDelegate.keymapController.execute(.otherMouse, location: galacticLocation)
    }
    override func otherMouseDragged(with event: NSEvent) {
        guard Date().timeIntervalSince(self.lastOtherMouseDraggedTime) > 0.1 else {
            return
        }
        self.lastOtherMouseDraggedTime = Date()

        guard let contentView = self.window?.contentView else { return }
        let viewLocation = self.convert(event.locationInWindow, from: contentView)
        let galacticLocation = view2Galactic(location: viewLocation)

        debugPrint("StrategicView: other mouse dragged location \(galacticLocation)")
        appDelegate.keymapController.execute(.otherMouse, location: galacticLocation)

    }
    override func rightMouseDragged(with event: NSEvent) {
        guard Date().timeIntervalSince(self.lastRightMouseDraggedTime) > 0.1 else {
            return
        }
        self.lastRightMouseDraggedTime = Date()

        guard let contentView = self.window?.contentView else { return }
        let viewLocation = self.convert(event.locationInWindow, from: contentView)
        let galacticLocation = view2Galactic(location: viewLocation)

        debugPrint("StrategicView: right mouse dragged location \(galacticLocation)")
        appDelegate.keymapController.execute(.rightMouse, location: galacticLocation)

    }
    override func rightMouseDown(with event: NSEvent) {
        guard let contentView = self.window?.contentView else { return }
        let viewLocation = self.convert(event.locationInWindow, from: contentView)
        let galacticLocation = view2Galactic(location: viewLocation)

        debugPrint("StrategicView: right mouse down location \(galacticLocation)")
        appDelegate.keymapController.execute(.rightMouse, location: galacticLocation)

    }
    override func mouseDown(with event: NSEvent) {
        guard let contentView = self.window?.contentView else { return }
        let viewLocation = self.convert(event.locationInWindow, from: contentView)
        let galacticLocation = view2Galactic(location: viewLocation)

        debugPrint("StrategicView: mouse down location \(galacticLocation)")
        appDelegate.keymapController.execute(.leftMouse, location: galacticLocation)

    }
    override func mouseDragged(with event: NSEvent) {
        guard Date().timeIntervalSince(self.lastLeftMouseDraggedTime) > 0.1 else {
            return
        }
        self.lastLeftMouseDraggedTime = Date()

        guard let contentView = self.window?.contentView else { return }
        let viewLocation = self.convert(event.locationInWindow, from: contentView)
        let galacticLocation = view2Galactic(location: viewLocation)

        debugPrint("StrategicView: mouse dragged down location \(galacticLocation)")
        appDelegate.keymapController.execute(.leftMouse, location: galacticLocation)

    }
    override func keyDown(with event: NSEvent) {
        guard let contentView = self.window?.contentView else { return }
        guard let keymap = appDelegate.keymapController else {
            debugPrint("GalacticView.keyDown unable to find keymapController")
            return
        }
        let viewLocation = self.convert(event.locationInWindow, from: contentView)
        let location = view2Galactic(location: viewLocation)

        debugPrint("StrategicView.keyDown characters \(String(describing: event.characters)) location \(location)")
        switch event.characters?.first {
        case "0":
            keymap.execute(.zeroKey, location: location)
        case "1":
            keymap.execute(.oneKey, location: location)
        case "2":
            keymap.execute(.twoKey, location: location)
        case "3":
            keymap.execute(.threeKey, location: location)
        case "4":
            keymap.execute(.fourKey, location: location)
        case "5":
            keymap.execute(.fiveKey, location: location)
        case "6":
            keymap.execute(.sixKey, location: location)
        case "7":
            keymap.execute(.sevenKey, location: location)
        case "8":
            keymap.execute(.eightKey, location: location)
        case "9":
            keymap.execute(.nineKey, location: location)
        case ")":
            keymap.execute(.rightParenKey, location: location)
        case "!": keymap.execute(.exclamationMarkKey, location: location)
        case "@": keymap.execute(.atKey, location: location)
        case "%": keymap.execute(.percentKey,location: location)
        case "#": keymap.execute(.poundKey,location: location)
        case "<":
            keymap.execute(.lessThanKey,location: location)
        case ">":
            keymap.execute(.greaterThanKey,location: location)
        case "]":
            keymap.execute(.rightBracketKey,location: location)
        case "[":
            keymap.execute(.leftBracketKey, location: location)
        case "{":
            keymap.execute(.leftCurly, location: location)
        case "}":
            keymap.execute(.rightCurly, location: location)
        case "_":
            keymap.execute(.underscore, location: location)
        case "^":
            keymap.execute(.carrot, location: location)
        case "$":
            keymap.execute(.dollar, location: location)
        case ";":
            keymap.execute(.semicolon, location: location)
        case "a":
            keymap.execute(.aKey, location: location)
        case "b":
            keymap.execute(.bKey, location: location)
        case "c":
            keymap.execute(.cKey, location: location)
        case "d":
            keymap.execute(.dKey, location: location)
        case "e":
            keymap.execute(.eKey, location: location)
        case "f":
            keymap.execute(.fKey, location: location)
        case "g":
            keymap.execute(.gKey, location: location)
        case "h":
            keymap.execute(.hKey, location: location)
        case "i":
            keymap.execute(.iKey, location: location)
        case "j":
            keymap.execute(.jKey, location: location)
        case "k":
            keymap.execute(.kKey, location: location)
        case "l":
            keymap.execute(.lKey, location: location)
        case "m":
            keymap.execute(.mKey, location: location)
        case "n":
            keymap.execute(.nKey, location: location)
        case "o":
            keymap.execute(.oKey, location: location)
        case "p":
            keymap.execute(.pKey, location: location)
        case "q":
            keymap.execute(.qKey, location: location)
        case "r":
            keymap.execute(.rKey, location: location)
        case "s":
            keymap.execute(.sKey, location: location)
        case "t":
            keymap.execute(.tKey, location: location)
        case "u":
            keymap.execute(.uKey, location: location)
        case "v":
            keymap.execute(.vKey, location: location)
        case "w":
            keymap.execute(.wKey, location: location)
        case "x":
            keymap.execute(.xKey, location: location)
        case "y":
            keymap.execute(.yKey, location: location)
        case "z":
            keymap.execute(.zKey, location: location)
        case "A":
            keymap.execute(.AKey, location: location)
        case "B":
            keymap.execute(.BKey, location: location)
        case "C":
            keymap.execute(.CKey, location: location)
        case "D":
            keymap.execute(.DKey, location: location)
        case "E":
            keymap.execute(.EKey, location: location)
        case "F":
            keymap.execute(.FKey, location: location)
        case "G":
            keymap.execute(.GKey, location: location)
        case "H":
            keymap.execute(.HKey, location: location)
        case "I":
            keymap.execute(.IKey, location: location)
        case "J":
            keymap.execute(.JKey, location: location)
        case "K":
            keymap.execute(.KKey, location: location)
        case "L":
            keymap.execute(.LKey, location: location)
        case "M":
            keymap.execute(.MKey, location: location)
        case "N":
            keymap.execute(.NKey, location: location)
        case "O":
            keymap.execute(.OKey, location: location)
        case "P":
            keymap.execute(.PKey, location: location)
        case "Q":
            keymap.execute(.QKey, location: location)
        case "R":
            keymap.execute(.RKey, location: location)
        case "S":
            keymap.execute(.SKey, location: location)
        case "T":
            keymap.execute(.TKey, location: location)
        case "U":
            keymap.execute(.UKey, location: location)
        case "V":
            keymap.execute(.VKey, location: location)
        case "W":
            keymap.execute(.WKey, location: location)
        case "X":
            keymap.execute(.XKey, location: location)
        case "Y":
            keymap.execute(.YKey, location: location)
        case "Z":
            keymap.execute(.ZKey, location: location)
        case "*":
            keymap.execute(.asteriskKey, location: location)
        default:
            debugPrint("GalacticView.keyDown unknown key \(String(describing: event.characters))")
        }
    }

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
        
        //let myTeam = appDelegate.universe.me?.team ?? .independent
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
    func view2Galactic(location: CGPoint) -> CGPoint {
        let galacticX = location.x / self.bounds.width * CGFloat(NetrekMath.galacticSize)
        let galacticY = location.y / self.bounds.height * CGFloat(NetrekMath.galacticSize)
        return CGPoint(x: galacticX, y: galacticY)
    }
}
