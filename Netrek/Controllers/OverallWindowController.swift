//
//  overallWindowController.swift
//  Netrek
//
//  Created by Darrell Root on 3/20/19.
//  Copyright © 2019 Network Mom LLC. All rights reserved.
//

import Cocoa

class OverallWindowController: NSWindowController {

    override func windowDidLoad() {
        super.windowDidLoad()
    
        // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
    }

    override func rightMouseDragged(with event: NSEvent) { print("overall \(#function)") }

}
