//
//  Label.swift
//  Netrek
//
//  Created by Darrell Root on 3/13/19.
//  Copyright © 2019 Network Mom LLC. All rights reserved.
//

import Cocoa

class Label: NSTextField {

    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        self.isBezeled = false
        self.drawsBackground = false
        self.isEditable = false
        self.isSelectable = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        // Drawing code here.
    }
    
}
