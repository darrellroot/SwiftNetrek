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
    
    // The following are initialized by the child controllers via the appdelegate
    var messageViewController: MessageViewController?
    
    @IBOutlet weak var serverMenu: NSMenu!
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        metaServer = MetaServer(hostname: "metaserver.netrek.org", port: 3521)
        if let metaServer = metaServer {
            metaServer.update()
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
            // no need to do anything here, handled in the menu function
            break
        case .serverConnected:
            guard let reader = reader else {
                self.newGameState(.noServerSelected)
                return
            }
            let cpPacket = MakePacket.cpPacket()
            reader.send(content: cpPacket)
            break
        case .serverSlotFound:
            break
        case .loginAccepted:
            break
        case .outfitAccepted:
            break
        case .gameActive:
            break
        }
    }
}

extension AppDelegate: NetworkDelegate {
    func gotData(data: Data, from: String, port: Int) {
        PacketAnalyzer.analyze(data: data)
        //debugPrint(String(data: data, encoding: .utf8))
    }
}

