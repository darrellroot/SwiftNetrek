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
