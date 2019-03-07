//
//  Player.swift
//  Netrek
//
//  Created by Darrell Root on 3/2/19.
//  Copyright © 2019 Network Mom LLC. All rights reserved.
//

import Foundation
import SpriteKit

class Player: CustomStringConvertible {
    
    let appDelegate = NSApplication.shared.delegate as! AppDelegate

    private(set) var playerID: Int?
    //private(set) var hostile = 0
    private(set) var hostile: [Team:Bool] = [:]
    private(set) var war: [Team:Bool] = [:]
    private(set) var armies = 0
    private(set) var tractor = 0
    private(set) var flags: UInt32 = 0
    private(set) var damage = 0
    private(set) var shieldStrength = 100
    private(set) var fuel = 10000
    private(set) var engineTemp = 0
    private(set) var weaponsTemp = 0
    private(set) var whyDead: Int?
    private(set) var whoDead: Int?
    
    private(set) var playing = false
    private(set) var team: Team = .independent
    private(set) var ship: ShipType?
    private(set) var positionX: Int = 0
    private(set) var positionY: Int = 0
    private(set) var me: Bool = false
    private(set) var name: String = "nobody"
    //
    // from packet type 24
    private(set) var rank = 0
    private(set) var login = "unknown"
    // from packet type 3
    private(set) var kills = 0.0
    private(set) var slotStatus: SlotStatus = .free //free=0 outfit=1 alive=2 explode=3 dead=4 observe=5
    // from packet type 4
    private(set) var lastSlotStatus: SlotStatus = .free //free=0 outfit=1 alive=2 explode=3 dead=4 observe=5

    private(set) var direction: CGFloat = 0.0 // 2 * Double.pi = 360 degrees
    private(set) var speed = 0
    var playerTacticalNode = SKSpriteNode()
    
    init(playerID: Int) {
        self.playerID = playerID
        self.remakeNode()
    }
    public var description: String {
        get {
            return "Player \(String(describing: playerID)) name \(name) armies \(armies) damage \(damage) shield \(shieldStrength) fuel \(fuel) eTmp \(engineTemp) ship \(String(describing: ship)) team \(String(describing: team)) wTmp \(weaponsTemp) playing \(playing) positionX \(positionX) positionY \(positionY) login \(login) rank \(rank)"
        }
    }
    
    private func remakeNode() {
        //private(set) var status = 0  //free=0 outfit=1 alive=2 explode=3 dead=4 observe=5
        if self.playerTacticalNode.parent != nil {
            self.playerTacticalNode.removeFromParent()
        }
        self.playerTacticalNode = SKSpriteNode(imageNamed: "ori-ca")
        self.playerTacticalNode.zPosition = ZPosition.ship.rawValue
        self.playerTacticalNode.zRotation = self.direction
        self.playerTacticalNode.size = CGSize(width: 800, height: 800)
        self.updateNode()
    appDelegate.tacticalViewController?.scene.addChild(self.playerTacticalNode)
    }
    private func updateNode() {
        //    private(set) var status = 0  //free=0 outfit=1 alive=2 explode=3 dead=4 observe=5
        if self.slotStatus != self.lastSlotStatus {
            self.lastSlotStatus = self.slotStatus
        switch self.slotStatus {
            case .free:
                self.playerTacticalNode.isHidden = true
            case .outfit:
                self.playerTacticalNode.isHidden = true
            case .alive:
                self.playerTacticalNode.isHidden = false
            case .explode:
                self.playerTacticalNode.isHidden = true
            case .dead:
                self.playerTacticalNode.isHidden = true
            case .observe:
                self.playerTacticalNode.isHidden = true
            }
        }
        if self.slotStatus == .alive && self.positionX > 0 && self.positionX < 100000 && self.positionY > 0 && self.positionY < 100000 {
                self.playerTacticalNode.position = CGPoint(x: positionX, y: positionY)
                self.playerTacticalNode.zRotation = self.direction
                if self.me {
                    if let defaultCamera = appDelegate.tacticalViewController?.defaultCamera {
                        defaultCamera.position = CGPoint(x: self.positionX, y: self.positionY)
                    }
            }
        }
    }
    
    public func updateMe(myPlayerID: Int, hostile: UInt32, war: UInt32, armies: Int, tractor: Int, flags: UInt32, damage: Int, shieldStrength: Int, fuel: Int, engineTemp: Int, weaponsTemp: Int, whyDead: Int, whoDead: Int) {
        if self.playerID != myPlayerID && self.playerID != nil  {
            debugPrint("Player.updateMe: ERROR: inconsistent player ID \(myPlayerID) versus \(String(describing: self.playerID))")
        }
        self.me = true
        //self.hostile = hostile //TODO break this up
        for team in Team.allCases {
            if UInt32(team.rawValue) & hostile != 0 {
                self.hostile[team] = true
            } else {
                self.hostile[team] = false
            }
        }
        //self.war = war // TODO break this up
        for team in Team.allCases {
            if UInt32(team.rawValue) & war != 0 {
                self.war[team] = true
            } else {
                self.war[team] = false
            }
        }
        self.armies = armies
        self.tractor = tractor
        self.flags = flags
        self.damage = damage
        self.shieldStrength = shieldStrength
        self.fuel = fuel
        self.engineTemp = engineTemp
        self.weaponsTemp = weaponsTemp
        self.whyDead = whyDead
        self.whoDead = whoDead
    }
    public func update(shipType: Int) {
        for shipCase in ShipType.allCases {
            if shipCase.rawValue == shipType {
                self.ship = shipCase
                return
            }
        }
        debugPrint("Player.update invalid shipType \(shipType)")
    }
    public func update(team: Int) {
        for teamCase in Team.allCases {
            if teamCase.rawValue == team {
                self.team = teamCase
                return
            }
        }
        debugPrint("Player.update invalid team \(team)")
    }
    public func update(kills: Double) {
        self.kills = kills
    }
    // from SP_PLAYER 4
    public func update(directionNetrek: Int, speed: Int, positionX: Int, positionY: Int) {
        self.direction = CGFloat(direction) * 2 * CGFloat.pi / 256.0
        self.speed = speed
        self.positionX = positionX
        self.positionY = positionY
        self.updateNode()
    }
    // from SP_FLAGS_18
    public func update(tractor: Int, flags: UInt32) {
        self.tractor = tractor
        self.flags = flags
    }
    // from SP_PSTATUS_20
    public func update(sp_pstatus: Int) {
        switch sp_pstatus {
        case 0:
            self.slotStatus = .free
        case 1:
            self.slotStatus = .outfit
        case 2:
            self.slotStatus = .alive
            self.updateNode()
        case 3:
            self.slotStatus = .explode
            self.updateNode()
        case 4:
            self.slotStatus = .dead
        case 5:
            self.slotStatus = .observe
        default:
            debugPrint("Player.update.SP_PSTATUS invalid slot status \(sp_pstatus)")
        }
    }

    // from SP_HOSTILE_22
    public func update(war: UInt32, hostile: UInt32) {
        for team in Team.allCases {
            if UInt32(team.rawValue) & hostile != 0 {
                self.hostile[team] = true
            } else {
                self.hostile[team] = false
            }
        }
        //self.war = war // TODO break this up
        for team in Team.allCases {
            if UInt32(team.rawValue) & war != 0 {
                self.war[team] = true
            } else {
                self.war[team] = false
            }
        }
        /*for team in Team.allCases {
            debugPrint("player \(String(describing: playerID)) is on team \(self.team) and is hostile:\(self.hostile) with team \(team)" )
            debugPrint("player \(String(describing: playerID)) is on team \(self.team) and is war:\(self.war) with team \(team)" )
        }*/
    }
    public func update(rank: Int, name: String, login: String) {
        self.rank = rank
        self.name = name
        self.login = login
    }
}

