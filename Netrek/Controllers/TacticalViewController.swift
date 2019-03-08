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
    var scene = TacticalScene(size:CGSize(width: 100000, height: 100000))
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
        defaultCamera.xScale = 0.2
        defaultCamera.yScale = 0.2
        scene.delegate = self
        scene.addChild(defaultCamera)
        scene.camera = defaultCamera
        defaultCamera.position = CGPoint(x: 2000, y: 2000)
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
