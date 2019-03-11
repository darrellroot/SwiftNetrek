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
    private(set) var owner: Team = .independent
    private(set) var info: Int = 0
    private(set) var flags: Int = 0
    var armies: Int = 0
    var planetTacticalNode = SKSpriteNode(imageNamed: "planet-ind")
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
        // no need to re-add after: scene controller will handle it after any packet arrives
        let teamSuffix: String
        switch self.owner {
        case .federation:
            teamSuffix = "fed"
        case .independent:
            teamSuffix = "ind"
        case .roman:
            teamSuffix = "rom"
        case .kleptocrat:
            teamSuffix = "kle"
        case .orion:
            teamSuffix = "ori"
        case .ogg:
            teamSuffix = "ind"
        }
        let planetImage = "planet-\(teamSuffix)"
        planetTacticalNode = SKSpriteNode(imageNamed: planetImage)
        planetTacticalNode.name = self.name
        planetTacticalNode.size = CGSize(width: NetrekMath.planetDiameter, height: NetrekMath.planetDiameter)
        planetTacticalLabel.fontSize = NetrekMath.planetFontSize
        planetTacticalLabel.fontName = "Courier"
        planetTacticalLabel.position = CGPoint(x: 0, y: -2 * NetrekMath.planetDiameter)
        planetTacticalLabel.zPosition = ZPosition.planet.rawValue
        switch self.owner {
        case .independent:
            planetTacticalLabel.fontColor = NSColor.gray
        case .federation:
            planetTacticalLabel.fontColor = NSColor.yellow
        case .roman:
            planetTacticalLabel.fontColor = NSColor.red
        case .kleptocrat:
            planetTacticalLabel.fontColor = NSColor.green
        case .orion:
            planetTacticalLabel.fontColor = NSColor.blue
        case .ogg:
            planetTacticalLabel.fontColor = NSColor.gray
        }
        planetTacticalNode.position = CGPoint(x: self.positionX, y: self.positionY)

        planetTacticalNode.zPosition = ZPosition.planet.rawValue
        planetTacticalLabel.text = self.name
        planetTacticalNode.addChild(planetTacticalLabel)
        // add child not needed, tactical scene handles that
        // if planet within required distance
        //appDelegate.tacticalViewController?.scene.addChild(planetTacticalNode)
    }
    public func update(name: String, positionX: Int, positionY: Int) {
        self.name = name
        self.positionX = positionX
        self.positionY = positionY
        self.remakeNode()
    }
    public func update(owner: Int, info: Int, flags: UInt16, armies: Int) {
        self.flags = Int(flags)
        self.info = info
        self.armies = armies
        for team in Team.allCases {
            if owner == team.rawValue {
                self.owner = team
                self.remakeNode()
                return
            }
        }
    }
}
