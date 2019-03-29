//
//  TacticalViewController.swift
//  Netrek
//
//  Created by Darrell Root on 3/5/19.
//  Copyright © 2019 Network Mom LLC. All rights reserved.
//

import Cocoa
import SpriteKit

class TacticalViewController: NSViewController, SKSceneDelegate {

    var defaultCamera = SKCameraNode()
    var scene = TacticalScene(size:CGSize(width: NetrekMath.galacticSize, height: NetrekMath.galacticSize))
    let appDelegate = NSApplication.shared.delegate as! AppDelegate
    let basicHintNode = SKLabelNode()
    var basicHintCount = 0
    var basicHints = [
        "To start game, select a server, then launch ship -> cruiser",
        "It may be necessary to select a different preferred team",
        "Left mouse button fires torpedoes",
        "Right mouse button sets direction",
        "Number keys set speed",
        "Middle mouse button fires laser",
        "s raises or lowers your shields",
    ]
    let advancedHintNode = SKLabelNode()
    var advancedHints = [
        "l locks your destination onto a planet or ship",
        "b bombs an enemy planet you are orbiting",
        "R stops and repairs your ship",
        "Enemy planets damage you when you are close",
        "You can carry 2 armies for each kill with your current ship",
        "There are 40 planets in the universe",
        "There are 2 active species in the game",
        "There are 2 inactive species in the game",
        "Each species starts with 10 planets",
        "Tournament mode will start when sufficient humans  play",
        "Tournament stats and ranks are only earned in tournament mode",
        "Work with your team to capture planets",
        "c activates your cloaking device",
        "Controls can be customized in the preferences",
        ]

    
    var setupComplete = false

    override func viewDidLoad() {
        super.viewDidLoad()
        appDelegate.tacticalViewController = self
        let skView = self.view as! SKView
        skView.showsFPS = true
        skView.showsNodeCount = true
        skView.showsDrawCount = true
        skView.showsQuadCount = true
        skView.ignoresSiblingOrder = true
        skView.preferredFramesPerSecond = 30
        defaultCamera.xScale = 0.23
        defaultCamera.yScale = 0.23
        scene.delegate = self
        scene.addChild(defaultCamera)
        scene.camera = defaultCamera
        debugPrint("camera user interaction \(defaultCamera.isUserInteractionEnabled)")

        //scene.window = self.view.window
        defaultCamera.position = CGPoint(x: 2000, y: 5000)
        skView.presentScene(self.scene)
        debugPrint("scene user interaction \(self.scene.isUserInteractionEnabled)")

        basicHintNode.position = CGPoint(x: 0 , y: 700)
        basicHintNode.fontSize = NetrekMath.hintFontSize
        basicHintNode.fontName = "Courier"
        basicHintNode.zPosition = ZPosition.hint.rawValue
        basicHintNode.fontColor = NSColor.green
        defaultCamera.addChild(basicHintNode)
        
        advancedHintNode.position = CGPoint(x: 0 , y: -700)
        advancedHintNode.fontSize = NetrekMath.hintFontSize
        advancedHintNode.fontName = "Courier"
        advancedHintNode.zPosition = ZPosition.hint.rawValue
        advancedHintNode.fontColor = NSColor.red
        defaultCamera.addChild(advancedHintNode)

        updateHint()

    }
    func updateHint() {
        debugPrint("Updating hint")
        if appDelegate.gameState == .gameActive {
            basicHintNode.isHidden = true
            advancedHintNode.isHidden = true
        } else {
            basicHintNode.isHidden = false
            advancedHintNode.isHidden = false
            self.basicHintCount = self.basicHintCount + 1
            if self.basicHintCount >= self.basicHints.count {
                self.basicHintCount = 0
            }
            if let basicHintText = basicHints[safe: basicHintCount] {
                basicHintNode.text = basicHintText
            }
            advancedHintNode.text = advancedHints.randomElement()
        }
    }

    /*public func presentScene(delay: Double) {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            if let skView = self.view as? SKView {
                skView.presentScene(self.scene)
            }
        }
    }*/
    public func hideScene() {
        if let skView = self.view as? SKView {
            skView.scene?.removeFromParent()
        }
    }
    override func otherMouseDown(with event: NSEvent) {
        //let location = event.location(in: self)
        debugPrint("TacticalViewController: OtherMouseDown location ")
        self.scene.otherMouseDown(with: event)
        //appDelegate.keymapController.execute(.otherMouse, location: location)
    }
    override func otherMouseDragged(with event: NSEvent) {
        debugPrint("tactical view controller other mouse dragged")
        if event.type == .otherMouseDragged {
            self.scene.otherMouseDragged(with: event)
        }
    }
    override func rightMouseDragged(with event: NSEvent) { print(#function) }

    /*override func rightMouseDragged(with event: NSEvent) {
        debugPrint("tactical view controller right mouse dragged")
        self.scene.rightMouseDragged(with: event)
    }*/
    /*override func mouseDragged(with event: NSEvent) {
        debugPrint("tactical view controller mouse dragged")
        self.scene.mouseDragged(with: event)
    }*/
}
