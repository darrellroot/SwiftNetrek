//
//  FlipScrollView.swift
//  Netrek
//
//  Created by Darrell Root on 3/13/19.
//  Copyright © 2019 Network Mom LLC. All rights reserved.
//

import Cocoa

class FlipScrollView: NSScrollView {

    override var isFlipped: Bool {
        return true
    }
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        // Drawing code here.
    }
    
}
