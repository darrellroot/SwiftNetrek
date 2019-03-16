//
//  ManualServerController.swift
//  Netrek
//
//  Created by Darrell Root on 3/15/19.
//  Copyright © 2019 Network Mom LLC. All rights reserved.
//

import Cocoa

class ManualServerController: NSWindowController {
    let appDelegate = NSApplication.shared.delegate as! AppDelegate

    override var windowNibName: NSNib.Name? {
        return NSNib.Name("ManualServerController")
    }

    @IBOutlet weak var serverHostnameOutlet: NSTextField!
    @IBOutlet weak var serverPortOutlet: NSTextField!
    
    override func windowDidLoad() {
        super.windowDidLoad()
        serverPortOutlet.stringValue = "2592"
        // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
    }
    
    @IBAction func connectButton(_ sender: NSButton) {
        let hostname = serverHostnameOutlet.stringValue
        let port = Int(serverPortOutlet.intValue)
        guard hostname != "" else { return }
        guard port > 0 && port < 65535 else { return }
        
        appDelegate.connectServer(hostname: hostname, port: port)
        appDelegate.manualServerController = nil
        self.dismissController(nil)
    }
}
