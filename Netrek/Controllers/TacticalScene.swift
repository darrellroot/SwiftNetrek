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
    var window: NSWindow?
    var keymapController: KeymapController!
    
    let displayDistance = 3000  // display units
    
    override func sceneDidLoad() {
        self.window = self.view?.window
        self.keymapController = appDelegate.keymapController
    }
    
    func packetUpdate() {
        for torpedo in appDelegate.universe.torpedoes.values {
            updateTorpedo(torpedo)
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
        let taxiDistance = abs(me.positionX - torpedo.positionX) + abs(me.positionY - torpedo.positionY)
        if taxiDistance > displayDistance {
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
        if let windowLocation = window?.mouseLocationOutsideOfEventStream {
            if let viewLocation = self.view?.convert(windowLocation, from: window?.contentView) {
                location = convert(viewLocation, to: self)
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
        case "s":
            keymap.execute(.sKey, location: location)
        case "u":
            keymap.execute(.uKey, location: location)
        default:
            debugPrint("TacticalScene.keyDown unknown key \(String(describing: event.characters))")
        }
    }
    
}
