//
//  playerView.swift
//  Netrek
//
//  Created by Darrell Root on 3/8/19.
//  Copyright © 2019 Network Mom LLC. All rights reserved.
//

import Cocoa

class PlayerView: NSScrollView {
    
    let appDelegate = NSApplication.shared.delegate as! AppDelegate


    let rows = 33
    //let columns = 2  two columns hardcoded in logic
    //let inset = 4
    
    
    //let columnWidth = [3,3,10,13,5] //characters in each column
    let totalCharacterWidth = 70

    override var isFlipped: Bool {
        return true
    }
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        self.needsDisplay = false
        debugPrint("PlayerView.draw")
        var fedPlayer: [Player] = []
        var oriPlayer: [Player] = []
        var romPlayer: [Player] = []
        var klePlayer: [Player] = []
        var indPlayer: [Player] = []

        let players = appDelegate.universe.players.values
        
        for player in players.sorted (by: { $0.playerID < $1.playerID }) {
        
            if player.slotStatus != .free && player.slotStatus != .observe {
                switch player.team {

                case .independent:
                    indPlayer.append(player)
                case .federation:
                    fedPlayer.append(player)
                case .roman:
                    romPlayer.append(player)
                case .kleptocrat:
                    klePlayer.append(player)
                case .orion:
                    oriPlayer.append(player)
                case .ogg:
                    indPlayer.append(player)
                }
            }
        }
        let column1Player = romPlayer + fedPlayer + klePlayer + oriPlayer + indPlayer
        displayHeader(inset: 4)
        displayColumn(players: column1Player, inset: 4)
    
    }
    private func displayHeader(inset: Int) {
        let verticalPosition = 0
        let horizontalInterval = Int(self.bounds.width) / totalCharacterWidth

        let attribute: [NSAttributedString.Key: Any]? = [ NSAttributedString.Key.foregroundColor: NSColor.white, NSAttributedString.Key.font: NSFont(name: "Courier",size: 10.0) as Any]

        var attString = NSAttributedString(string: "Team", attributes: attribute)
        var point = CGPoint(x: inset + 3 * horizontalInterval, y: verticalPosition)
        attString.draw(at: point)
        
        point = CGPoint(x: (inset + 6 * horizontalInterval), y: verticalPosition)
        attString = NSAttributedString(string: "Ship", attributes: attribute)
        attString.draw(at: point)
        
        point = CGPoint(x: (inset + 9 * horizontalInterval), y: verticalPosition)
        attString = NSAttributedString(string: "Rank", attributes: attribute)
        attString.draw(at: point)
        
        point = CGPoint(x: (inset + 19 * horizontalInterval), y: verticalPosition)
        attString = NSAttributedString(string: "Player Name", attributes: attribute)
        attString.draw(at: point)
        
        point = CGPoint(x: (inset + 32 * horizontalInterval), y: verticalPosition)
        attString = NSAttributedString(string: "Kills", attributes: attribute)
        attString.draw(at: point)

    }
    private func displayColumn(players: [Player], inset: Int) {
        for (index,player) in players.enumerated() {
            let verticalInterval = (Int(self.bounds.height) / (players.count + 1)) - 1
            debugPrint("playerView.displayColumn verticalInterval \(verticalInterval)")
            let horizontalInterval = Int(self.bounds.width) / totalCharacterWidth
            let playerColor = NetrekMath.color(team: player.team)
            let attribute: [NSAttributedString.Key: Any]? = [ NSAttributedString.Key.foregroundColor: playerColor, NSAttributedString.Key.font: NSFont(name: "Courier",size: 10.0) as Any]

            // player code
            let verticalPosition = (index + 1) * verticalInterval
            debugPrint("playerView.displayColumn index \(index) verticalPosition \(verticalPosition)")

            let teamLetter = NetrekMath.teamLetter(team: player.team)
            let playerLetter: String
            /*if let playerID = player.playerID {
                playerLetter = NetrekMath.playerLetter(playerID: playerID)
            } else {
                playerLetter = "?"
            }*/
            playerLetter = NetrekMath.playerLetter(playerID: player.playerID)

            var attString = NSAttributedString(string: "\(teamLetter)\(playerLetter)", attributes: attribute)
            var point = CGPoint(x: inset + 3 * horizontalInterval, y: verticalPosition)
            attString.draw(at: point)
            
            let type = player.ship?.description ?? "??"
            point = CGPoint(x: (inset + 6 * horizontalInterval), y: verticalPosition)
            attString = NSAttributedString(string: type, attributes: attribute)
            attString.draw(at: point)
            
            let rank = player.rank.description
            point = CGPoint(x: (inset + 9 * horizontalInterval), y: verticalPosition)
            attString = NSAttributedString(string: rank, attributes: attribute)
            attString.draw(at: point)
            
            point = CGPoint(x: (inset + 19 * horizontalInterval), y: verticalPosition)
            attString = NSAttributedString(string: player.name, attributes: attribute)
            attString.draw(at: point)
            
            var kills: String
            if player.kills != nil {
                kills = String(player.kills)
            } else {
                kills = "??.??"
            }
            point = CGPoint(x: (inset + 32 * horizontalInterval), y: verticalPosition)
            attString = NSAttributedString(string: kills, attributes: attribute)
            attString.draw(at: point)
        }
    }
}

   /*
    func updateData() {
        for (playerID,player) in appDelegate.universe.players.sorted(by: { $0.key < $1.key }) {
            let teamLetter = NetrekMath.teamLetter(team: player.team)
            let playerLetter = NetrekMath.playerLetter(playerID: playerID)
            let type = player.ship?.description ?? "??"
            let rank = player.rank.description
            let name = player.name
            let kills = String(format: "%2.2",player.kills)
            let playerString = String(format: "%1@%1@ %2@ %9@ %12@ %5@",teamLetter, playerLetter, type, rank, name, kills)
            switch player.team {
                
            case .independent:
                indString.append(playerString)
            case .federation:
                fedString.append(playerString)
            case .roman:
                romString.append(playerString)
            case .kleptocrat:
                kleString.append(playerString)
            case .orion:
                oriString.append(playerString)
            case .ogg:
                indString.append(playerString)
            }
        }
    }
}*/
