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
    
    @IBAction func refreshMetaserverMenu(_ sender: NSMenuItem) {
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
            print("starting game server \(server.description)")
        }
    }
}

