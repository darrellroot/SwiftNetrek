//
//  SendMessageViewController.swift
//  Netrek
//
//  Created by Darrell Root on 3/9/19.
//  Copyright © 2019 Network Mom LLC. All rights reserved.
//

import Foundation
import AppKit

class SendMessageViewController: NSViewController {
    
    let appDelegate = NSApplication.shared.delegate as! AppDelegate

    @IBOutlet weak var sendMessageTeamOutlet: NSPopUpButton!
    
    @IBOutlet weak var messageOutlet: NSTextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        appDelegate.sendMessageViewController = self
        updateMenu()
    }
    
    public func updateMenu() {
        sendMessageTeamOutlet.menu?.removeAllItems()
        do {
            let newItem = NSMenuItem(title: "Send Message to All", action: nil, keyEquivalent: "")
            newItem.tag = 100
            sendMessageTeamOutlet.menu?.addItem(newItem)
        }
        for team in Team.allCases {
            
            if team != .ogg && team != .independent {
                let newItem = NSMenuItem(title: "Send Message to \(team.description)", action: nil, keyEquivalent: "")
                newItem.tag = 100 + team.rawValue
                sendMessageTeamOutlet.menu?.addItem(newItem)
                
            }
        }
        for player in appDelegate.universe.players.values.sorted(by: { $0.playerID < $1.playerID}) {
            if player.slotStatus != .free {
                let teamLetter = NetrekMath.teamLetter(team: player.team)
                let playerLetter = NetrekMath.playerLetter(playerID: player.playerID)
                let newItem = NSMenuItem(title: "Send Message to \(teamLetter)\(playerLetter) \(player.name)", action: nil, keyEquivalent: "")
                newItem.tag = player.playerID
                sendMessageTeamOutlet.menu?.addItem(newItem)
            }
        }
    }

    private func findClosestPlanet(location: CGPoint) -> (planet: Planet?,distance: Int) {
        var closestPlanetDistance = 10000
        var closestPlanet: Planet?
        for planet in appDelegate.universe.planets.values {
            let thisPlanetDistance = abs(planet.positionX - Int(location.x)) + abs(planet.positionY - Int(location.y))
            if thisPlanetDistance < closestPlanetDistance {
                closestPlanetDistance = thisPlanetDistance
                closestPlanet = planet
            }
        }
        return (closestPlanet,closestPlanetDistance)
    }

    @IBAction func sendMayday(_ sender: NSButton) {
        debugPrint("SendMessageController.sendMayday")
        guard appDelegate.gameState == .gameActive else { return }
        guard let me = appDelegate.universe.me else { return }
        let (planetOptional,_) = findClosestPlanet(location: CGPoint(x: me.positionX,y: me.positionY))
        guard let planet = planetOptional else { return }
        
        let message = "MAYDAY near \(planet.name) shields \(me.shieldStrength) damage \(me.damage) armies \(me.armies)"
        let data: Data
        switch me.team {
        case .independent:
            return
        case .federation:
            data = MakePacket.cpMessage(message: message, team: .federation, individual: 0)
        case .roman:
            data = MakePacket.cpMessage(message: message, team: .roman, individual: 0)
        case .kazari:
            data = MakePacket.cpMessage(message: message, team: .kazari, individual: 0)
        case .orion:
            data = MakePacket.cpMessage(message: message, team: .orion, individual: 0)
        case .ogg:
            return
        }
        self.appDelegate.reader?.send(content: data)
    }
    
    @IBAction func requestEscort(_ sender: NSButton) {
        debugPrint("SendMessageController.requestEscort")
        guard appDelegate.gameState == .gameActive else { return }
        guard let me = appDelegate.universe.me else { return }
        let (planetOptional,_) = findClosestPlanet(location: CGPoint(x: me.positionX,y: me.positionY))
        guard let planet = planetOptional else { return }
        
        let message = "REQEST ESCORT near \(planet.name) shields \(me.shieldStrength) damage \(me.damage) armies \(me.armies)"
        let data: Data
        switch me.team {
        case .independent:
            return
        case .federation:
            data = MakePacket.cpMessage(message: message, team: .federation, individual: 0)
        case .roman:
            data = MakePacket.cpMessage(message: message, team: .roman, individual: 0)
        case .kazari:
            data = MakePacket.cpMessage(message: message, team: .kazari, individual: 0)
        case .orion:
            data = MakePacket.cpMessage(message: message, team: .orion, individual: 0)
        case .ogg:
            return
        }
        self.appDelegate.reader?.send(content: data)

    }
    @IBAction func sendMessageTextAction(_ sender: NSTextField) {
        let tag = sendMessageTeamOutlet.selectedTag()
        let message = sender.stringValue
        let myTeam = appDelegate.universe.me?.team ?? .independent
        let myNumber = appDelegate.universe.me?.playerID ?? -1
        sender.stringValue = ""
        DispatchQueue.global(qos: .background).async {
            switch tag {
            case 100:  // all
                let data = MakePacket.cpMessage(message: message, team: .ogg, individual: 0)
                self.appDelegate.reader?.send(content: data)
            case 101: // fed
                let data = MakePacket.cpMessage(message: message, team: .federation, individual: 0)
                self.appDelegate.reader?.send(content: data)
                if myTeam != .federation {
                    self.appDelegate.messageViewController?.gotMessage(" \(myTeam.letter)\(NetrekMath.playerLetter(playerID: myNumber)) -> FED \(message)")
                }
            case 102: // roman
                let data = MakePacket.cpMessage(message: message, team: .roman, individual: 0)
                self.appDelegate.reader?.send(content: data)
                if myTeam != .roman {
                    self.appDelegate.messageViewController?.gotMessage(" \(myTeam.letter)\(NetrekMath.playerLetter(playerID: myNumber)) -> ROM \(message)")
                }
            case 104: // Kazari
                let data = MakePacket.cpMessage(message: message, team: .kazari, individual: 0)
                self.appDelegate.reader?.send(content: data)
                if myTeam != .kazari {
                    self.appDelegate.messageViewController?.gotMessage(" \(myTeam.letter)\(NetrekMath.playerLetter(playerID: myNumber)) -> KAZ \(message)")
                }
            case 108: // orion
                let data = MakePacket.cpMessage(message: message, team: .orion, individual: 0)
                self.appDelegate.reader?.send(content: data)
                if myTeam != .orion {
                    self.appDelegate.messageViewController?.gotMessage(" \(myTeam.letter)\(NetrekMath.playerLetter(playerID: myNumber)) -> ORI \(message)")
                }
            case 0..<32: // individual
                let tag = UInt8(tag)
                let data = MakePacket.cpMessage(message: message, team: nil, individual: tag)
                self.appDelegate.reader?.send(content: data)
                if myNumber != tag {
                    self.appDelegate.messageViewController?.gotMessage(" \(myTeam.letter)\(NetrekMath.playerLetter(playerID: myNumber)) -> player \(tag): \(message)")
                }
            default:
                debugPrint("ERROR SendMessageViewController.sendMessageAction invalid tag \(tag)")
            }
        }
    }
}
