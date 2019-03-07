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

    var camera = SKCameraNode()
    var scene = SKScene(size:CGSize(width: 100000, height: 100000))
    let appDelegate = NSApplication.shared.delegate as! AppDelegate
    
    var playerNodes: [Int:SKSpriteNode] = [:]
    var planetNodes: [Int:SKSpriteNode] = [:]
    var torpedoNodes: [Int: SKSpriteNode] = [:]
    //var lasers: [Int: ] = [:]
    var plasmaNodes: [Int: SKSpriteNode] = [:]
    var setupComplete = false

    override func viewDidLoad() {
        super.viewDidLoad()
        appDelegate.tacticalViewController = self
        // Do view setup here.
        let skView = self.view as! SKView
        skView.showsFPS = true
        skView.showsNodeCount = true
        skView.ignoresSiblingOrder = true
        
        scene.delegate = self
        //scene.scaleMode = .resizeFill
        scene.addChild(camera)
        scene.camera = camera
        camera.position = CGPoint(x: 1000, y: 1000)
        camera.xScale = 0.2
        camera.yScale = 0.2
        //let cruiser = SKSpriteNode(imageNamed: "ori-ca")
        //cruiser.position =  CGPoint(x: 1000, y: 1000)
        //scene.addChild(cruiser)
        skView.presentScene(scene)
    }
    
    public func setup() {
        /*
        for planet in appDelegate.universe.planets.values {
                scene.addChild(planet.planetTacticalNode)
        }
            let planetNode = SKSpriteNode(imageNamed: "planet-ind")
            planetNode.position = CGPoint(x: planet.positionX, y: planet.positionY)
            planetNode.size = CGSize(width: 1120, height: 1120)
            scene.addChild(planetNode)
            planetNodes[index] = planetNode
            let planetTextNode = SKLabelNode(text: planet.name)
            planetTextNode.position = CGPoint(x: 0, y: -2000)
            planetNode.addChild(planetTextNode)
            planetTextNode.color = NSColor.orange
            planetTextNode.fontName = "Courier"
            planetTextNode.fontColor = NSColor.white
            planetTextNode.fontSize = 800
 */
        setupComplete = true
    }
    public func update() {  // this gets called 10 times a second so its gotta be fast
        if !setupComplete {
            return
        }
        for (index,player) in appDelegate.universe.players {
            if playerNodes[index] == nil {
                let newPlayerNode = SKSpriteNode(imageNamed: "ori-ca")
                newPlayerNode.position = CGPoint(x: player.positionX, y: player.positionY)
                newPlayerNode.zPosition = 3
                newPlayerNode.size = CGSize(width: 800, height: 800)
                scene.addChild(newPlayerNode)
                playerNodes[index] = newPlayerNode
            }
            playerNodes[index]?.position = CGPoint(x: player.positionX, y: player.positionY)
            if let me = appDelegate.universe.me {
                camera.position = CGPoint(x: me.positionX, y: me.positionY)
            }
        }
    }
}
