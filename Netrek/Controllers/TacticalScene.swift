//
//  TacticalScene.swift
//  Netrek
//
//  Created by Darrell Root on 3/6/19.
//  Copyright © 2019 Network Mom LLC. All rights reserved.
//

import Cocoa
import SpriteKit

class TacticalScene: SKScene {
    let appDelegate = NSApplication.shared.delegate as! AppDelegate
    let sceneType: SceneType = .tactical
    //var window: NSWindow?
    var keymapController: KeymapController!
    var lastRightMouseDraggedTime = Date()
    var lastLeftMouseDraggedTime = Date()
    var lastOtherMouseDraggedTime = Date()
    
    override func sceneDidLoad() {
        //self.window = self.view?.window
        self.keymapController = appDelegate.keymapController
        let border = SKShapeNode(rect: CGRect(x: 0, y: 0, width: NetrekMath.galacticSize, height: NetrekMath.galacticSize))
        border.lineWidth = 10
        border.strokeColor = NSColor.white
        self.addChild(border)
        debugPrint("tactical scene is user interaction enabled \(isUserInteractionEnabled)")
        debugPrint("border is user interaction enabled \(border.isUserInteractionEnabled)")


    }
    func explosion() -> SKEmitterNode {
        let emitter = SKEmitterNode()
        let particleTexture = SKTexture(imageNamed: "spark")
        let emitterAction = SKAction.sequence([SKAction.wait(forDuration: 1.0),SKAction.removeFromParent()])
        emitter.zPosition = ZPosition.explosion.rawValue
        emitter.particleTexture = particleTexture
        emitter.particleBirthRate = 1000
        emitter.numParticlesToEmit = 200
        emitter.particleLifetime = 1.0
        emitter.particleLifetimeRange = 1.0
        emitter.emissionAngle = 0.0
        emitter.emissionAngleRange = 360.0
        emitter.particleSpeed = 200
        emitter.particleSpeedRange = 50
        emitter.particleAlpha = 1.0
        emitter.particleAlphaRange = 0.0
        emitter.particleAlphaSpeed = -1.0
        emitter.particleScale = 0.2
        emitter.particleScaleRange = 0.1
        emitter.particleScaleSpeed = 0.0
        emitter.particleColor = SKColor.white
        emitter.particleColorBlendFactor = 1
        emitter.particleBlendMode = .add
        emitter.run(emitterAction)
        return emitter
    }
    func packetUpdate() {
        for player in appDelegate.universe.players.values {
            updatePlayer(player)
        }
        for torpedo in appDelegate.universe.torpedoes.values {
            updateTorpedo(torpedo)
        }
        for planet in appDelegate.universe.planets.values {
            updatePlanet(planet)
        }
        for plasma in appDelegate.universe.plasmas.values {
            updatePlasma(plasma)
        }
    }
    func updatePlanet(_ planet: Planet) {
        guard let me = appDelegate.universe.me else { return }
        //let taxiDistance = abs(me.positionX - planet.positionX) + abs(me.positionY - planet.positionY)
        let taxiDistance = abs(me.lastAlivePositionX - planet.positionX) + abs(me.lastAlivePositionY - planet.positionY)
        guard taxiDistance < NetrekMath.displayDistance else {
            if planet.planetTacticalNode.parent != nil {
                planet.planetTacticalNode.removeFromParent()
            }
            return
        }
        if planet.planetTacticalNode.parent == nil {
            self.addChild(planet.planetTacticalNode)
        }
    }
    func updatePlayer(_ player: Player) {
        guard let me = appDelegate.universe.me else { return }
        //let taxiDistance = abs(me.lastPositionX - player.positionX) + abs(me.lastPositionY - player.positionY)
        let taxiDistance = abs(me.lastAlivePositionX - player.positionX) + abs(me.lastAlivePositionY - player.positionY)

        guard taxiDistance < NetrekMath.displayDistance else {
            if player.playerTacticalNode.parent != nil {
                player.playerTacticalNode.removeAllActions()
                player.playerTacticalNode.removeFromParent()
            }
            return
        }
        switch player.slotStatus {
        case .free, .outfit, .observe:
            if player.playerTacticalNode.parent != nil {
                player.playerTacticalNode.removeAllActions()
                player.playerTacticalNode.removeFromParent()
            }
            return
        case .explode, .dead:
            if player.detonated {
                return
            } else {
                detonate(player: player)
                let volume = 1 - (Float(taxiDistance) / NetrekMath.displayDistanceFloat)
                appDelegate.soundController?.play(sound: .explosion, volume: volume)

            player.playerTacticalNode.removeFromParent()
                return
            }
        case .alive:
            if player.playerTacticalNode.parent == nil {
                player.remakeNode()
                self.addChild(player.playerTacticalNode)
            }
        }
    }
    func detonate(player: Player) {
        debugPrint("DETONATING player \(player.playerID) at positionX \(player.positionX) positionY \(player.positionY)")
        let emitterNode = explosion()
        emitterNode.position = player.playerTacticalNode.position
        self.addChild(emitterNode)
        player.detonated = true
        return
    }
    func updatePlasma(_ plasma: Plasma) {
        guard let me = appDelegate.universe.me else { return }
        guard plasma.status == 1 else {
            if plasma.plasmaNode.parent != nil {
                plasma.plasmaNode.removeFromParent()
            }
            return
        }
        let taxiDistance = abs(me.lastAlivePositionX - plasma.positionX) + abs(me.lastAlivePositionY - plasma.positionY)
        guard taxiDistance < NetrekMath.displayDistance else {
            if plasma.plasmaNode.parent != nil {
                plasma.plasmaNode.removeFromParent()
            }
            return
        }
        let plasmaCorrectColor: NSColor
        if (plasma.war[me.team] ?? false) {
            plasmaCorrectColor = NSColor.red
        } else {
            plasmaCorrectColor = NSColor.green
        }
        if plasma.plasmaNode.color != plasmaCorrectColor {
            // remake node
            plasma.plasmaNode.removeAllActions()
            plasma.plasmaNode.removeFromParent()
            plasma.plasmaNode = SKSpriteNode(color: plasmaCorrectColor,
                                               size: CGSize(width: NetrekMath.torpedoSize * 2, height: NetrekMath.torpedoSize * 2))
        }
        plasma.plasmaNode.position = CGPoint(x: plasma.positionX, y: plasma.positionY)
        if plasma.plasmaNode.parent == nil {
            self.scene?.addChild(plasma.plasmaNode)
        }
    }
    func updateTorpedo(_ torpedo: Torpedo) {
        // status 0==free 1==live 2==hit 3==?
        guard let me = appDelegate.universe.me else { return }
        if torpedo.status != 1 && torpedo.torpedoNode.parent == nil {
            return
        } else if torpedo.status != 1 {
            torpedo.torpedoNode.removeAllActions()
            torpedo.torpedoNode.removeFromParent()
            return
        }
        // torpedo status is 1
        let taxiDistance = abs(me.lastAlivePositionX - torpedo.positionX) + abs(me.lastAlivePositionY - torpedo.positionY)
        //let taxiDistance = abs(me.positionX - torpedo.positionX) + abs(me.positionY - torpedo.positionY)
        guard taxiDistance < NetrekMath.displayDistance else {
            if torpedo.torpedoNode.parent != nil {
                torpedo.torpedoNode.removeAllActions()
                torpedo.torpedoNode.removeFromParent()
            }
            return
        }
        var torpedoCorrectColor: NSColor
        if let suspectedTorpOwner = appDelegate.universe.players[torpedo.torpedoNumber / 8] {
            torpedoCorrectColor = NetrekMath.color(team: suspectedTorpOwner.team)
        } else {
            if (torpedo.war[me.team] ?? false) {
                torpedoCorrectColor = NSColor.red
            } else {
                torpedoCorrectColor = NSColor.green
            }
        }
        if torpedo.torpedoNode.color != torpedoCorrectColor {
            // remake node
            torpedo.torpedoNode.removeAllActions()
            torpedo.torpedoNode.removeFromParent()
            torpedo.torpedoNode = SKSpriteNode(color: torpedoCorrectColor,
                                               size: CGSize(width: NetrekMath.torpedoSize, height: NetrekMath.torpedoSize))
        }
        torpedo.torpedoNode.position = CGPoint(x: torpedo.positionX, y: torpedo.positionY)
        if torpedo.torpedoNode.parent == nil {
            self.scene?.addChild(torpedo.torpedoNode)
        }
    }
    override func rightMouseDragged(with event: NSEvent) {
        self.rightMouseDown(with: event)
    }
    //override func rightMouseDragged(with event: NSEvent) { print(#function) }

    /*override func rightMouseDragged(with event: NSEvent) {
        debugPrint("scene controller right mouse dragged")
        guard Date().timeIntervalSince(self.lastRightMouseDraggedTime) > 0.1 else {
            return
        }
        self.lastRightMouseDraggedTime = Date()
        let location = event.location(in: self)
        debugPrint("RightMouseDragged location \(location)")
        appDelegate.keymapController.execute(.rightMouse, location: location)
    }*/
    override func otherMouseDragged(with event: NSEvent) {
        debugPrint("scene controller other mouse dragged")
        guard Date().timeIntervalSince(self.lastOtherMouseDraggedTime) > 0.1 else {
            return
        }
        self.lastOtherMouseDraggedTime = Date()
        let location = event.location(in: self)
        debugPrint("OtherMouseDragged location \(location)")
        appDelegate.keymapController.execute(.otherMouse, location: location)
    }

    override func mouseDragged(with event: NSEvent) {
        debugPrint("scene controller left mouse dragged")
        guard Date().timeIntervalSince(lastLeftMouseDraggedTime) > 0.1 else {
            return
        }
        self.lastLeftMouseDraggedTime = Date()
        let location = event.location(in: self)
        debugPrint("LeftMouseDragged location \(location)")
        appDelegate.keymapController.execute(.leftMouse, location: location)
    }

    override func rightMouseDown(with event: NSEvent) {
        let location = event.location(in: self)
        debugPrint("RightMouseDown location \(location)")
        appDelegate.keymapController.execute(.rightMouse, location: location)
    }
    override func otherMouseDown(with event: NSEvent) {
        debugPrint(#function)
        // had to catch event in tacticalViewController
        let location = event.location(in: self)
        debugPrint("OtherMouseDown location \(location)")
        appDelegate.keymapController.execute(.otherMouse, location: location)
    }
    
    override func mouseDown(with event: NSEvent) {
        debugPrint(#function)
        let modifiers = event.modifierFlags
        if modifiers.contains(.control) {
            self.rightMouseDown(with: event)
            return
        }
        switch event.type {
        case .leftMouseDown:
            let location = event.location(in: self)
            debugPrint("LeftMouseDown location \(location)")
            appDelegate.keymapController.execute(.leftMouse, location: location)
        case .otherMouseDown: // does not work
            break
        case .rightMouseDragged:
            // does not work
            print(#function)
        case .rightMouseDown:
            // does not work alternative implementation above
            break
        default:
            break
        }
    }
    
    override func keyDown(with event: NSEvent) {
        debugPrint("TacticalScene.keyDown characters \(String(describing: event.characters))")
        guard let keymap = appDelegate.keymapController else {
            debugPrint("TacticalScene.keyDown unable to find keymapController")
            return
        }
        var location: CGPoint? = nil
        if let windowLocation = self.view?.window?.mouseLocationOutsideOfEventStream {
            if let viewLocation = self.view?.convert(windowLocation, from: self.view?.window?.contentView) {
                location = self.scene?.convertPoint(fromView: viewLocation)
            }
        }
        
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
            debugPrint("TacticalScene.keyDown unknown key \(String(describing: event.characters))")
        }
    }
    
}
