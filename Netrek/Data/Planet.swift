//
//  Planet.swift
//  Netrek
//
//  Created by Darrell Root on 3/3/19.
//  Copyright © 2019 Network Mom LLC. All rights reserved.
//

import Foundation
import SpriteKit

class Planet: CustomStringConvertible {
    private(set) var planetID: Int
    private(set) var name: String
    private(set) var positionX: Int
    private(set) var positionY: Int
    private(set) var owner: Team = .nobody
    private(set) var info: Int = 0
    private(set) var flags: Int = 0
    var armies: Int = 0
    var planetTacticalNode = SKSpriteNode(texture: SKTexture(imageNamed: "planet-ind"))
    let planetTacticalLabel = SKLabelNode()
    
    let appDelegate = NSApplication.shared.delegate as! AppDelegate

    var description: String {
        get {
            return "planet planetID: \(planetID) name: \(name) position: \(positionX) \(positionY)"
        }
    }
    init(planetID: Int) {
        self.planetID = planetID
        self.name = "unknown"
        self.positionX = 0
        self.positionY = 0
    }
    private func remakeNode() {
        planetTacticalNode.removeFromParent()
        planetTacticalNode = SKSpriteNode(imageNamed: "planet-ind")
        planetTacticalNode.size = CGSize(width: 1120, height: 1120)
        planetTacticalLabel.fontSize = 800
        planetTacticalLabel.fontName = "Courier"
        planetTacticalLabel.position = CGPoint(x: 0, y: -2000)
        planetTacticalLabel.zPosition = 2
        planetTacticalLabel.fontColor = NSColor.green
        if let hostile = appDelegate.universe.me?.hostile[self.owner] {
            if hostile {
                planetTacticalLabel.fontColor = NSColor.yellow
                return
            }
        }
        if let war = appDelegate.universe.me?.war[self.owner] {
            if war {
                planetTacticalLabel.fontColor = NSColor.red
                return
            }
        }

        planetTacticalNode.position = CGPoint(x: self.positionX, y: self.positionY)

        planetTacticalNode.zPosition = 1
        planetTacticalLabel.text = self.name
        planetTacticalNode.addChild(planetTacticalLabel)
        appDelegate.tacticalViewController?.scene.addChild(planetTacticalNode)
    }
    public func update(name: String, positionX: Int, positionY: Int) {
        self.name = name
        self.positionX = positionX
        self.positionY = positionY
        self.remakeNode()
    }
    public func setOwner(newOwnerInt: Int) {
        for team in Team.allCases {
            if newOwnerInt == team.rawValue {
                self.owner = team
                return
            }
        }
        self.remakeNode()
    }
    public func setInfo(newInfoInt: Int) {
        self.info = newInfoInt
    }
    public func setFlags(newFlagsInt: Int) {
        self.flags = newFlagsInt
    }
}
