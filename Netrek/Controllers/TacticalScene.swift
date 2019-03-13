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
    
    
    override func sceneDidLoad() {
        //self.window = self.view?.window
        self.keymapController = appDelegate.keymapController
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
        let torpedoCorrectColor: NSColor
        if (torpedo.war[me.team] ?? false) {
            torpedoCorrectColor = NSColor.red
        } else {
            torpedoCorrectColor = NSColor.green
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
        
        
    override func rightMouseDown(with event: NSEvent) {
        let location = event.location(in: self)
        debugPrint("RightMouseDown location \(location)")
        appDelegate.keymapController.execute(.rightMouse, location: location)
    }
    override func otherMouseDown(with event: NSEvent) {
        // had to catch event in tacticalViewController
        let location = event.location(in: self)
        debugPrint("OtherMouseDown location \(location)")
        appDelegate.keymapController.execute(.otherMouse, location: location)
    }
    
    override func mouseDown(with event: NSEvent) {
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
        case "b":
            keymap.execute(.bKey, location: location)
        case "c":
            keymap.execute(.cKey, location: location)
        case "d":
            keymap.execute(.dKey, location: location)
        case "f":
            keymap.execute(.fKey, location: location)
        case "l":
            keymap.execute(.lKey, location: location)
        case "o":
            keymap.execute(.oKey, location: location)
        case "r":
            keymap.execute(.rKey, location: location)
        case "s":
            keymap.execute(.sKey, location: location)
        case "u":
            keymap.execute(.uKey, location: location)
        case "x":
            keymap.execute(.xKey, location: location)
        case "y":
            keymap.execute(.yKey, location: location)
        case "z":
            keymap.execute(.zKey, location: location)
        case "C":
            keymap.execute(.CKey, location: location)
        case "D":
            keymap.execute(.DKey, location: location)
        case "Q":
            keymap.execute(.QKey, location: location)
        case "R":
            keymap.execute(.RKey, location: location)
        case "T":
            keymap.execute(.TKey, location: location)
        case "*":
            keymap.execute(.asteriskKey, location: location)
        default:
            debugPrint("TacticalScene.keyDown unknown key \(String(describing: event.characters))")
        }
    }
    
}
