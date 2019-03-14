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

    @IBOutlet var playerView: PlayerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        appDelegate.playerListViewController = self
        
        self.view.wantsLayer = true
        self.view.layer?.backgroundColor = NSColor.black.cgColor
        
        let savedFont = appDelegate.defaults.float(forKey: playerListFontKey)
        if savedFont > 1.0 {
            self.playerView.setFontSize(newSize: CGFloat(savedFont))
        }

    }
    
    
}
