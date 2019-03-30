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
    let advancedHintNode = SKLabelNode()

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
        if appDelegate.gameState == .gameActive {
            basicHintNode.isHidden = true
            advancedHintNode.isHidden = true
        } else {
            if UserDefaults.standard.bool(forKey: DefaultKey.basicTipsDisabled.rawValue) {
                basicHintNode.isHidden = true
            } else {
                basicHintNode.isHidden = false
            }
            if UserDefaults.standard.bool(forKey: DefaultKey.advancedTipsDisabled.rawValue) {
                advancedHintNode.isHidden = true
            } else {
                advancedHintNode.isHidden = false
            }
            self.basicHintCount = self.basicHintCount + 1
            if self.basicHintCount >= BasicHints.count {
                self.basicHintCount = 0
            }
            if let basicHintText = BasicHints[safe: basicHintCount] {
                basicHintNode.text = basicHintText
            }
            if let advancedHint = AdvancedHints.randomElement() {
                debugPrint(advancedHint)
                advancedHintNode.text = advancedHint
            }
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
