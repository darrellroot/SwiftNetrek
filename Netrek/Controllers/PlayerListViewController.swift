//
//  PlayerListViewController.swift
//  Netrek
//
//  Created by Darrell Root on 3/8/19.
//  Copyright © 2019 Network Mom LLC. All rights reserved.
//

import Cocoa

class PlayerListViewController: NSViewController {
    
    let appDelegate = NSApplication.shared.delegate as! AppDelegate

    override func viewDidLoad() {
        super.viewDidLoad()
        appDelegate.playerListViewController = self
        // Do view setup here.
    }
    
    
}
