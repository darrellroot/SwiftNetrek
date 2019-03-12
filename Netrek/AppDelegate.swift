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
    private(set) var gameState: GameState = .noServerSelected
    let universe = Universe()
    var analyzer: PacketAnalyzer?
    let timerInterval = 1.0 / Double(UPDATE_RATE)
    var timer: Timer?
    var timerCount = 0
    // The following are initialized by the child controllers via the appdelegate
    var messageViewController: MessageViewController?
    
    var preferredTeam: Team = .independent
    var preferredShip: ShipType = .cruiser
    var keymapController: KeymapController!

    var tacticalViewController: TacticalViewController?   // the child view controller sets this up in viewdidload
    var strategicViewController: StrategicViewController?
    var playerListViewController: PlayerListViewController?
    var hudViewController: HUDViewController?
    var sendMessageViewController: SendMessageViewController?
    var clientTypeSent = false
    
    @IBOutlet weak var serverMenu: NSMenu!
    
    @IBOutlet weak var selectTeamAny: NSMenuItem!
    @IBOutlet weak var selectTeamFederation: NSMenuItem!
    @IBOutlet weak var selectTeamRoman: NSMenuItem!
    @IBOutlet weak var selectTeamKleptocrat: NSMenuItem!
    @IBOutlet weak var selectTeamOrion: NSMenuItem!
    
    
    
    @IBOutlet weak var selectShipAny: NSMenuItem!
    @IBOutlet weak var selectShipScout: NSMenuItem!
    @IBOutlet weak var selectShipDestroyer: NSMenuItem!
    @IBOutlet weak var selectShipCruiser: NSMenuItem!
    @IBOutlet weak var selectShipBattleship: NSMenuItem!
    @IBOutlet weak var selectShipAssault: NSMenuItem!
    @IBOutlet weak var selectShipStarbase: NSMenuItem!
    @IBOutlet weak var selectShipBattlecruiser: NSMenuItem!
    @IBOutlet weak var selectShipAttackCruiser: NSMenuItem!
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        keymapController = KeymapController()
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
        self.updateTeamMenu()
        self.disableShipMenu()
    }
    
    private func updateTeamMenu() {
        selectTeamAny.state = .off
        selectTeamFederation.state = .off
        selectTeamFederation.state = .off
        selectTeamRoman.state = .off
        selectTeamKleptocrat.state = .off
        selectTeamOrion.state = .off
        switch preferredTeam {
        case .federation:
            selectTeamFederation.state = .on
        case .roman:
            selectTeamRoman.state = .on
        case .kleptocrat:
            selectTeamKleptocrat.state = .on
        case .orion:
            selectTeamOrion.state = .on
        case .independent:
            selectTeamAny.state = .on
        case .ogg:
            break
        }
    }


    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    func refreshMetaserver() {
        if let metaServer = metaServer {
            metaServer.update()
        }
    }
    @IBAction func refreshMetaserverNetrekOrg(_ sender: NSMenuItem) {
        metaServer = MetaServer(hostname: "metaserver.netrek.org", port: 3521)
        if let metaServer = metaServer {
            metaServer.update()
        }
    }
    @IBAction func refreshMetaserverEuNetrekOrg(_ sender: NSMenuItem) {
        metaServer = MetaServer(hostname: "metaserver.eu.netrek.org", port: 3521)
        if let metaServer = metaServer {
            metaServer.update()
        }
    }
    
    public func metaserverUpdated() {
        debugPrint("AppDelegate.metaserverUpdated")
        if let metaServer = metaServer {
            messageViewController?.gotMessage("Server list updated from metaserver")
            serverMenu.removeAllItems()
            for (index,server) in metaServer.servers.enumerated() {
                let newItem = NSMenuItem(title: server.description, action: #selector(self.selectServer), keyEquivalent: "")
                newItem.tag = index
                
                serverMenu.addItem(newItem)
            }
        }
    }
    @objc func selectServer(sender: NSMenuItem) {
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
        self.messageViewController?.gotMessage("Game State: moving from \(self.gameState.rawValue) to \(newState.rawValue)\n")
        debugPrint("Game State: moving from \(self.gameState.rawValue) to \(newState.rawValue)\n")
        switch newState {
        case .noServerSelected:
            enableServerMenu()
            disableShipMenu()
            self.gameState = newState
            self.messageViewController?.gotMessage("AppDelegate GameState \(newState) we may have been ghostbusted!  Resetting.  Try again\n")
            self.reader = nil
            self.refreshMetaserver()
            break
            
        case .serverSelected:
            disableShipMenu()
            self.gameState = newState
            self.analyzer = PacketAnalyzer()
            // no need to do anything here, handled in the menu function
            break
            
        case .serverConnected:
            disableShipMenu()
            self.clientTypeSent = false
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
            disableShipMenu()
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
            enableShipMenu()
            if self.gameState == .serverSlotFound {
            }
            DispatchQueue.main.async {
                self.playerListViewController?.view.needsDisplay = true
            }
            /*if self.gameState == .serverSlotFound {
                tacticalViewController?.presentScene(delay: 1.0)
            }*/
            self.gameState = newState
            
        case .gameActive:
            DispatchQueue.main.async {
                self.playerListViewController?.view.needsDisplay = true
            }
            self.gameState = newState
            disableShipMenu()
            disableServerMenu()
            if !clientTypeSent {
                if let letter = universe.me?.team.letter, let playerID = universe.me?.playerID {
                    let hexNumber = NetrekMath.playerLetter(playerID: playerID)
                    let data = MakePacket.cpMessage(message: "I am using the Swift Netrek Client v0.1 on MacOS", team: .ogg, individual: 0)
                    clientTypeSent = true
                    self.reader?.send(content: data)
                }
            }
        }
    }
    private func disableServerMenu() {
        debugPrint("disable server menu")
        for menuItem in self.serverMenu.items {
            debugPrint("disabling server menu \(menuItem.title)")
            menuItem.isEnabled = false
        }
    }
    private func enableServerMenu() {
        debugPrint("enable server menu")
        for menuItem in self.serverMenu.items {
            menuItem.isEnabled = true
        }
    }

    private func disableShipMenu() {
        debugPrint("disable ship menu")
        selectShipAny.isEnabled = false
        selectShipScout.isEnabled = false
        selectShipDestroyer.isEnabled = false
        selectShipCruiser.isEnabled = false
        selectShipBattleship.isEnabled = false
        selectShipAssault.isEnabled = false
        selectShipStarbase.isEnabled = false
        selectShipBattlecruiser.isEnabled = false
    }
    private func enableShipMenu() {
        debugPrint("enable ship menu")
        selectShipAny.isEnabled = true
        selectShipScout.isEnabled = true
        selectShipDestroyer.isEnabled = true
        selectShipCruiser.isEnabled = true
        selectShipBattleship.isEnabled = true
        selectShipAssault.isEnabled = true
        selectShipStarbase.isEnabled = true
        selectShipBattlecruiser.isEnabled = true
    }
    @IBAction func selectTeam(_ sender: NSMenuItem) {
        let tag = sender.tag
        for team in Team.allCases {
            if tag == team.rawValue {
                self.preferredTeam = team
                self.updateTeamMenu()
            }
        }
    }
    @IBAction func selectShip(_ sender: NSMenuItem) {
        let tag = sender.tag
        for ship in ShipType.allCases {
            if tag == ship.rawValue {
                self.preferredShip = ship
            }
        }
        if self.gameState == .loginAccepted {
            if let reader = self.reader {
                let cpUpdates = MakePacket.cpUpdates()
                    reader.send(content: cpUpdates)
                let cpOutfit = MakePacket.cpOutfit(team: self.preferredTeam, ship: self.preferredShip)
                reader.send(content: cpOutfit)
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
        case .gameActive:
            if (timerCount % 200) == 0 {
                debugPrint("AppDelegate.timer.gameActive: updating sendMessageViewController")
                DispatchQueue.main.async {
                    self.sendMessageViewController?.updateMenu()
                }
            }
            if (timerCount % 100) == 0 {
                debugPrint("Setting needs display for playerListViewController")
                DispatchQueue.main.async {
                    self.playerListViewController?.view.needsDisplay = true
                }
            }
            if (timerCount % 10) == 0 {
                DispatchQueue.main.async {
                    self.strategicViewController?.view.needsDisplay = true
                    self.hudViewController?.view.needsDisplay = true
                }
            }
            //TODO send ping every x timer counts
            break
        }
    }
}

extension AppDelegate: NetworkDelegate {
    func gotData(data: Data, from: String, port: Int) {
        debugPrint("appdelegate got data \(data.count) bytes")
        //debugPrint("appdelegate data index \(data.startIndex) \(data.endIndex)")
        if data.count > 0 {
            analyzer?.analyze(incomingData: data)
        }
        //debugPrint(String(data: data, encoding: .utf8))
    }
}

