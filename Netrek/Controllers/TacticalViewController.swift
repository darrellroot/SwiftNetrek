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
        defaultCamera.position = CGPoint(x: 1000, y: 1000)
        //skView.presentScene(self.scene)
    }
    public func presentScene(delay: Double) {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            if let skView = self.view as? SKView {
                skView.presentScene(self.scene)
            }
        }
    }
    public func hideScene() {
        if let skView = self.view as? SKView {
            skView.scene?.removeFromParent()
        }
    }
}
