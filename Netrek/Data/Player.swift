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

    private(set) var playerID: Int = 0
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
    private(set) var lastPositionX: Int = 0
    private(set) var lastPositionY: Int = 0
    private(set) var lastUpdateTime = Date()
    private(set) var updateTime = Date()
    // from flags
    private(set) var shieldsUp = false
    //
    // from packet type 24
    private(set) var rank: Rank = .ensign
    private(set) var login = "unknown"
    // from packet type 3
    private(set) var kills = 0.0
    private(set) var slotStatus: SlotStatus = .free //free=0 outfit=1 alive=2 explode=3 dead=4 observe=5
    // from packet type 4
    private(set) var lastSlotStatus: SlotStatus = .free //free=0 outfit=1 alive=2 explode=3 dead=4 observe=5

    private(set) var direction: CGFloat = 0.0 // 2 * Double.pi = 360 degrees
    private(set) var speed = 0
    var playerTacticalNode = SKSpriteNode()
    var shieldNode = SKShapeNode(circleOfRadius: CGFloat(NetrekMath.playerSize))
    
    init(playerID: Int) {
        self.playerID = playerID
        self.remakeNode()
        shieldNode.lineWidth = CGFloat(NetrekMath.playerSize) / 10.0
        shieldNode.strokeColor = .green
    }
    public var description: String {
        get {
            return "Player \(String(describing: playerID)) name \(name) armies \(armies) damage \(damage) shield \(shieldStrength) fuel \(fuel) eTmp \(engineTemp) ship \(String(describing: ship)) team \(String(describing: team)) wTmp \(weaponsTemp) playing \(playing) positionX \(positionX) positionY \(positionY) login \(login) rank \(rank)"
        }
    }
    
    private func remakeNode() {
        //private(set) var status = 0  //free=0 outfit=1 alive=2 explode=3 dead=4 observe=5
        if self.shieldNode.parent != nil {
            self.shieldNode.removeFromParent()
        }
        if self.playerTacticalNode.parent != nil {
            self.playerTacticalNode.removeFromParent()
        }
        let teamPrefix: String
        switch self.team {
        case .federation:
            teamPrefix = "fed"
        case .independent:
            teamPrefix = "ind"
        case .roman:
            teamPrefix = "rom"
        case .kleptocrat:
            teamPrefix = "kle"
        case .orion:
            teamPrefix = "ori"
        case .ogg:
            teamPrefix = "ind"
        }
        let shipSuffix: String
        if let ship = self.ship {
            switch ship {
                
            case .scout:
                shipSuffix = "sc"
            case .destroyer:
                shipSuffix = "dd"
            case .cruiser:
                shipSuffix = "ca"
            case .battleship:
                shipSuffix = "bb"
            case .assault:
                shipSuffix = "as"
            case .starbase:
                shipSuffix = "sb"
            case .battlecruiser:
                debugPrint("Player.remakeNode need galaxy")
                shipSuffix = "ca"
            }
        } else {
            shipSuffix = "dd"
        }

        self.playerTacticalNode = SKSpriteNode(imageNamed: "\(teamPrefix)-\(shipSuffix)")
        self.playerTacticalNode.zPosition = ZPosition.ship.rawValue
        self.playerTacticalNode.zRotation = self.direction
        self.playerTacticalNode.size = CGSize(width: NetrekMath.playerSize, height: NetrekMath.playerSize)
        self.playerTacticalNode.addChild(self.shieldNode)
        self.updateNode()
    appDelegate.tacticalViewController?.scene.addChild(self.playerTacticalNode)
    }
    private func updateNode() {
        //    private(set) var status = 0  //free=0 outfit=1 alive=2 explode=3 dead=4 observe=5
        if self.slotStatus != self.lastSlotStatus {
        switch self.slotStatus {
            case .free:
                self.playerTacticalNode.isHidden = true
            case .outfit:
                self.playerTacticalNode.isHidden = true
            case .alive:
                self.playerTacticalNode.isHidden = false
            case .explode:
                self.playerTacticalNode.isHidden = true
                if me && self.lastSlotStatus == .alive {
                    appDelegate.newGameState(.loginAccepted)
            }
            case .dead:
                self.playerTacticalNode.isHidden = true
                if me && self.lastSlotStatus == .alive {
                    appDelegate.newGameState(.loginAccepted)
            }
            case .observe:
                self.playerTacticalNode.isHidden = true
            }
            self.lastSlotStatus = self.slotStatus
        }
        if shieldsUp {
            self.shieldNode.isHidden = false
        } else {
            self.shieldNode.isHidden = true
        }
        if self.slotStatus == .alive && self.positionX > 0 && self.positionX < NetrekMath.galacticSize && self.positionY > 0 && self.positionY < NetrekMath.galacticSize {
            self.playerTacticalNode.position = CGPoint(x: positionX, y: positionY)
            self.playerTacticalNode.zRotation = self.direction
            let deltaX = self.positionX - self.lastPositionX
            let deltaY = self.positionY - self.lastPositionY
            let deltaTime = self.updateTime.timeIntervalSince(self.lastUpdateTime)
            if deltaX < NetrekMath.actionThreshold && deltaY < NetrekMath.actionThreshold && deltaTime < 2.0 && deltaTime > 0.04 {
                let action = SKAction.moveBy(x: CGFloat(deltaX), y: CGFloat(deltaY), duration: deltaTime)
                DispatchQueue.main.async {
                    self.playerTacticalNode.removeAllActions()
                    self.playerTacticalNode.run(action)
                }
                debugPrint("running action player \(playerID) deltaX \(deltaX) deltaY \(deltaY) deltaTime \(deltaTime)")
            } else {
                debugPrint("Player.update.noAction playerID \(String(describing: playerID)) deltaX \(deltaX) deltaY \(deltaY) deltaT \(deltaTime)")
            }
            if self.me {
                if let defaultCamera = appDelegate.tacticalViewController?.defaultCamera {
                    defaultCamera.position = CGPoint(x: self.positionX, y: self.positionY)
                    let action = SKAction.moveBy(x: CGFloat(deltaX), y: CGFloat(deltaY), duration: deltaTime)
                    DispatchQueue.main.async {
                        defaultCamera.removeAllActions()
                        defaultCamera.run(action)
                    }
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
        if flags & PlayerStatus.shield.rawValue != 0 {
            self.shieldsUp = true
            self.shieldNode.isHidden = false
        } else {
            self.shieldsUp = false
            self.shieldNode.isHidden = true
        }
        self.updateNode()
    }
    public func update(shipType: Int) {
        for shipCase in ShipType.allCases {
            if shipCase.rawValue == shipType {
                if shipCase != self.ship {
                    self.ship = shipCase
                    self.remakeNode()
                }
                return
            }
        }
        debugPrint("Player.update invalid shipType \(shipType)")
    }
    public func update(team: Int) {
        for teamCase in Team.allCases {
            if teamCase.rawValue == team {
                if self.team != teamCase {
                    self.team = teamCase
                    self.remakeNode()
                }
                return
            }
        }
        debugPrint("Player.update invalid team \(team)")
    }
    public func update(kills: Double) {
        self.kills = kills
    }
    // from SP_PLAYER 4
    public func update(directionNetrek: UInt8, speed: Int, positionX: Int, positionY: Int) {
        self.direction = NetrekMath.directionNetrek2radian(UInt8(directionNetrek))
        self.speed = speed
        self.lastPositionX = positionX
        self.lastPositionY = positionY
        self.lastUpdateTime = self.updateTime
        self.updateTime = Date()
        self.positionX = positionX
        self.positionY = positionY
        self.updateNode()
        /* for debugging only
         if me && self.direction < CGFloat.pi {
            // do nothing
            debugPrint("self.direction \(self.direction)")
        }*/
    }
    // from SP_FLAGS_18
    public func update(tractor: Int, flags: UInt32) {
        self.tractor = tractor
        self.flags = flags
        if flags & PlayerStatus.shield.rawValue != 0 {
            self.shieldsUp = true
            self.shieldNode.isHidden = false
        } else {
            self.shieldsUp = false
            self.shieldNode.isHidden = true
        }
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
        for netrekRank in Rank.allCases {
            if netrekRank.rawValue == rank {
                self.rank = netrekRank
            }
        }
        self.name = name
        self.login = login
    }
}

