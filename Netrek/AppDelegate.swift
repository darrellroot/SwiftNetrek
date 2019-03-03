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
    let timerInterval = 1.0 / Double(UPDATE_RATE)
    var timer: Timer?
    // The following are initialized by the child controllers via the appdelegate
    var messageViewController: MessageViewController?
    
    @IBOutlet weak var serverMenu: NSMenu!
    
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
            self.newGameState(.serverSelected)
            print("starting game server \(server.description)")
            //if let reader = TcpReader(hostname: "metaserver.netrek.org", port: 3521, delegate: self) {
            if let reader = TcpReader(hostname: server.hostname, port: server.port, delegate: self) {
                self.reader = reader
            } else {
                debugPrint("AppDelegate failed to start reader")
            }
        }
    }
    public func newGameState(_ newState: GameState ) {
        switch newState {
        case .noServerSelected:
            debugPrint("AppDelegate GameState \(newState) we may have been ghostbusted!  Resetting.  Try again")
            reader = nil
            self.refreshMetaserverMenu(self)
            break
        case .serverSelected:
            self.analyzer = PacketAnalyzer()
            // no need to do anything here, handled in the menu function
            break
        case .serverConnected:
            debugPrint("AppDelegate.newGameState: .serverConnected")

            guard let reader = reader else {
                self.newGameState(.noServerSelected)
                return
            }
            let cpPacket = MakePacket.cpPacket()
            reader.send(content: cpPacket)
            break
        case .serverSlotFound:
            debugPrint("AppDelegate.newGameState: .serverSlotFound")
            let cpLogin = MakePacket.cpLogin(name: "guest", password: "", login: "")
            if let reader = reader {
                DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + 10.0) {
                    reader.send(content: cpLogin)
                }
            } else {
                debugPrint("ERROR: AppDelegate.newGameState.serverSlot found: no reader")
            }
            //TODO what do we do if we cant find reader
            break
        case .loginAccepted:
            break
        case .outfitAccepted:
            break
        case .gameActive:
            break
        }
    }
    @objc func timerFired() {
        //debugPrint("AppDelegate.timerFired \(Date())")
        reader?.receive()
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

