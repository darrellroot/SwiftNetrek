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

    
    var clientFeatures: [String] = ["FEATURE_PACKETS","SHIP_CAP","SP_GENERIC_32","TIPS"]
    var serverFeatures: [String] = []
    var metaServer: MetaServer?
    var reader: TcpReader?
    var gameState: GameState = .noServerSelected
    let universe = Universe()
    var analyzer: PacketAnalyzer?
    let timerInterval = 10.0 / Double(UPDATE_RATE)
    var timer: Timer?
    var timerCount = 0
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
        timer = Timer(timeInterval: timerInterval , target: self, selector: #selector(timerFired), userInfo: nil, repeats: true)
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
        case .nobody:
            break
        case .ogg:
            break
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
        self.messageViewController?.gotMessage("Game State: moving from self.gameState.rawValue to newState.rawValue\n")
        switch newState {
        case .noServerSelected:
            self.gameState = newState
            self.messageViewController?.gotMessage("AppDelegate GameState \(newState) we may have been ghostbusted!  Resetting.  Try again\n")
            self.reader = nil
            self.refreshMetaserverMenu(self)
            break
            
        case .serverSelected:
            self.gameState = newState
            self.analyzer = PacketAnalyzer()
            // no need to do anything here, handled in the menu function
            break
            
        case .serverConnected:
            self.gameState = newState

            guard let reader = reader else {
                self.newGameState(.noServerSelected)
                return
            }
            let cpSocket = MakePacket.cpSocket()
            DispatchQueue.global(qos: .background).async{
                reader.send(content: cpSocket)
            }
            for feature in clientFeatures {
                let cpFeature: Data
                if feature == "SP_GENERIC_32" {
                    cpFeature = MakePacket.cpFeatures(feature: feature,arg1: 2)
                } else {
                    cpFeature = MakePacket.cpFeatures(feature: feature)
                }
                DispatchQueue.global(qos: .background).asyncAfter(deadline: .now()+0.1) {
                    self.reader?.send(content: cpFeature)
                }
            }
            
        case .serverSlotFound:
            self.gameState = newState
            debugPrint("AppDelegate.newGameState: .serverSlotFound")
            let cpLogin = MakePacket.cpLogin(name: "guest", password: "", login: "")
            if let reader = reader {
                DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + 0.2) {

                    reader.send(content: cpLogin)
                }
            } else {
                self.messageViewController?.gotMessage("ERROR: AppDelegate.newGameState.serverSlot found: no reader")
                self.newGameState(.noServerSelected)
            }
            
        case .loginAccepted:
            self.gameState = newState
            guard let reader = reader else {
                self.messageViewController?.gotMessage("ERROR: AppDelegate.newGameState.serverSlot found: no reader")
                self.newGameState(.noServerSelected)
                return
            }
            let cpUpdates = MakePacket.cpUpdates()
            DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + 0.3) {
                reader.send(content: cpUpdates)
            }
            let cpOutfit = MakePacket.cpOutfit(team: self.preferredTeam, ship: self.preferredShip)
            DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + 0.4) {
                    reader.send(content: cpOutfit)
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
        timerCount = timerCount + 1
        //debugPrint("AppDelegate.timerFired \(Date())")
        switch self.gameState {
            
        case .noServerSelected:
            break
        case .serverSelected:
            break
        case .serverConnected:
            break
        case .serverSlotFound:
            break
        case .loginAccepted:
            break
        case .outfitAccepted:
            //TODO send ping every x timer counts
            //WHEN do we go to game active
            break
        case .gameActive:
            //TODO send ping every x timer counts
            break
        }
    }
}

extension AppDelegate: NetworkDelegate {
    func gotData(data: Data, from: String, port: Int) {
        //debugPrint("appdelegate got data \(data.count) bytes")
        if data.count > 0 {
            analyzer?.analyze(incomingData: data)
        }
        //debugPrint(String(data: data, encoding: .utf8))
    }
}

