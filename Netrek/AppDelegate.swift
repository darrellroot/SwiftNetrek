//
//  AppDelegate.swift
//  Netrek
//
//  Created by Darrell Root on 3/1/19.
//  Copyright © 2019 Network Mom LLC. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    
    var metaServer: MetaServer?
    var reader: TcpReader?
    var gameState: GameState = .noServerSelected
    let universe = Universe()
    var analyzer: PacketAnalyzer?
    let timerInterval = 10.0 / Double(UPDATE_RATE)
    var timer: Timer?
    // The following are initialized by the child controllers via the appdelegate
    var messageViewController: MessageViewController?
    
    var preferredTeam: Team = .federation
    var preferredShip: ShipType = .cruiser
    
    @IBOutlet weak var serverMenu: NSMenu!
    @IBOutlet weak var selectTeamFederation: NSMenuItem!
    @IBOutlet weak var selectTeamRomulan: NSMenuItem!
    @IBOutlet weak var selectTeamKlingon: NSMenuItem!
    @IBOutlet weak var selectTeamOrion: NSMenuItem!
    
    @IBOutlet weak var selectShipScout: NSMenuItem!
    @IBOutlet weak var selectShipDestroyer: NSMenuItem!
    @IBOutlet weak var selectShipCruiser: NSMenuItem!
    @IBOutlet weak var selectShipBattleship: NSMenuItem!
    @IBOutlet weak var selectShipAssault: NSMenuItem!
    @IBOutlet weak var selectShipStarbase: NSMenuItem!
    @IBOutlet weak var selectShipGalaxy: NSMenuItem!
    @IBOutlet weak var selectShipAttackCruiser: NSMenuItem!
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        metaServer = MetaServer(hostname: "metaserver.netrek.org", port: 3521)
        if let metaServer = metaServer {
            metaServer.update()
        }
        timer = Timer(timeInterval: 1.0 / Double(UPDATE_RATE) , target: self, selector: #selector(timerFired), userInfo: nil, repeats: true)
        timer?.tolerance = timerInterval / 10.0
        if let timer = timer {
            RunLoop.current.add(timer, forMode: RunLoop.Mode.common)
        }
        self.updateMenu()
    }
    
    func updateMenu() {
        selectTeamFederation.state = .off
        selectTeamRomulan.state = .off
        selectTeamKlingon.state = .off
        selectTeamOrion.state = .off
        switch preferredTeam {
        case .federation:
            selectTeamFederation.state = .on
        case .romulan:
            selectTeamRomulan.state = .on
        case .klingon:
            selectTeamKlingon.state = .on
        case .orion:
            selectTeamOrion.state = .on
        }
        
        selectShipScout.state = .off
        selectShipDestroyer.state = .off
        selectShipCruiser.state = .off
        selectShipBattleship.state = .off
        selectShipAssault.state = .off
        selectShipStarbase.state = .off
        selectShipGalaxy.state = .off
        selectShipAttackCruiser.state = .off
        switch preferredShip {
        case .scout:
            selectShipScout.state = .on
        case .destroyer:
            selectShipDestroyer.state = .on
        case .cruiser:
            selectShipCruiser.state = .on
        case .battleship:
            selectShipBattleship.state = .on
        case .assault:
            selectShipAssault.state = .on
        case .starbase:
            selectShipStarbase.state = .on
        case .sgalaxy:
            selectShipGalaxy.state = .on
        case .att:
            selectShipAttackCruiser.state = .on
        }
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    @IBAction func refreshMetaserverMenu(_ sender: Any) {
        metaServer?.update()
    }
    public func metaserverUpdated() {
        debugPrint("AppDelegate.metaserverUpdated")
        if let metaServer = metaServer {
            messageViewController?.gotMessage("Server list updated from metaserver")
            serverMenu.removeAllItems()
            for (index,server) in metaServer.servers.enumerated() {
                let newItem = NSMenuItem(title: server.description, action: #selector(self.startGame), keyEquivalent: "")
                newItem.tag = index
                
                serverMenu.addItem(newItem)
            }
        }
    }
    @objc func startGame(sender: NSMenuItem) {
        let tag = sender.tag
        if let server = metaServer?.servers[safe: tag] {
            print("starting game server \(server.description)")
            //if let reader = TcpReader(hostname: "metaserver.netrek.org", port: 3521, delegate: self) {
            if let reader = TcpReader(hostname: server.hostname, port: server.port, delegate: self) {
                self.reader = reader
                self.newGameState(.serverSelected)
            } else {
                debugPrint("AppDelegate failed to start reader")
            }
        }
    }
    public func newGameState(_ newState: GameState ) {
        switch newState {
        case .noServerSelected:
            self.gameState = newState
            self.messageViewController?.gotMessage("Game State: \(self.gameState.rawValue)\n")
            debugPrint("AppDelegate GameState \(newState) we may have been ghostbusted!  Resetting.  Try again")
            self.reader = nil
            self.refreshMetaserverMenu(self)
            break
        case .serverSelected:
            self.gameState = newState
            self.messageViewController?.gotMessage("Game State: \(self.gameState.rawValue)\n")
            self.analyzer = PacketAnalyzer()
            // no need to do anything here, handled in the menu function
            break
        case .serverConnected:
            self.gameState = newState
            self.messageViewController?.gotMessage("Game State: \(self.gameState.rawValue)\n")

            debugPrint("AppDelegate.newGameState: .serverConnected")

            guard let reader = reader else {
                self.newGameState(.noServerSelected)
                return
            }
            let cpPacket = MakePacket.cpPacket()
            DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + 1.0) {
                reader.send(content: cpPacket)
            }
            break
        case .serverSlotFound:
            self.gameState = newState
            self.messageViewController?.gotMessage("Game State: \(self.gameState.rawValue)\n")

            debugPrint("AppDelegate.newGameState: .serverSlotFound")
            let cpLogin = MakePacket.cpLogin(name: "guest", password: "", login: "")
            if let reader = reader {
                DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + 1.0) {

                    reader.send(content: cpLogin)
                }
            } else {
                self.messageViewController?.gotMessage("ERROR: AppDelegate.newGameState.serverSlot found: no reader")
                self.newGameState(.noServerSelected)
            }
        case .loginAccepted:
            self.messageViewController?.gotMessage("Game State: \(self.gameState.rawValue)\n")

            self.gameState = newState
            let cpOutfit = MakePacket.cpOutfit(team: self.preferredTeam, ship: self.preferredShip)
            if let reader = reader {
            DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + 1.0) {

                    reader.send(content: cpOutfit)
                }
            } else {
                self.messageViewController?.gotMessage("ERROR: AppDelegate.newGameState.serverSlot found: no reader")
                self.newGameState(.noServerSelected)
            }
        case .outfitAccepted:
            self.gameState = newState
        case .gameActive:
            self.gameState = newState
        }
    }
    @IBAction func selectTeam(_ sender: NSMenuItem) {
        let tag = sender.tag
        for team in Team.allCases {
            if tag == team.rawValue {
                self.preferredTeam = team
                self.updateMenu()
            }
        }
    }
    @IBAction func selectShip(_ sender: NSMenuItem) {
        let tag = sender.tag
        for ship in ShipType.allCases {
            if tag == ship.rawValue {
                self.preferredShip = ship
                self.updateMenu()
            }
        }
    }
    
    
    @objc func timerFired() {
        //debugPrint("AppDelegate.timerFired \(Date())")
        switch self.gameState {
            
        case .noServerSelected:
            break
        case .serverSelected:
            reader?.receive()
        case .serverConnected:
            reader?.receive()
        case .serverSlotFound:
            reader?.receive()
        case .loginAccepted:
            reader?.receive()
        case .outfitAccepted:
            reader?.receive()
        case .gameActive:
            reader?.receive()
        }
    }
}

extension AppDelegate: NetworkDelegate {
    func gotData(data: Data, from: String, port: Int) {
        debugPrint("appdelegate got data \(data.count) bytes")
        if data.count > 0 {
            analyzer?.analyze(incomingData: data)
        }
        //debugPrint(String(data: data, encoding: .utf8))
    }
}

