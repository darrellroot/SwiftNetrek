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
    
    override func sceneDidLoad() {
        self.window = self.view?.window
        self.keymapController = appDelegate.keymapController
    }
    override func rightMouseDown(with event: NSEvent) {
        let location = event.location(in: self)
        debugPrint("RightMouseDown location \(location)")
        appDelegate.keymapController.execute(.rightMouse, location: location)
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
        case .otherMouseDown:
            let location = event.location(in: self)
            debugPrint("CenterMouseDown location \(location)")
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
