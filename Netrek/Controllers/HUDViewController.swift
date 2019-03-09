//
//  HUDViewController.swift
//  Netrek
//
//  Created by Darrell Root on 3/9/19.
//  Copyright © 2019 Network Mom LLC. All rights reserved.
//

import Cocoa

class HUDViewController: NSViewController {
    let appDelegate = NSApplication.shared.delegate as! AppDelegate

    override func viewDidLoad() {
        super.viewDidLoad()
        appDelegate.hudViewController = self
        // Do view setup here.
    }
    
}
