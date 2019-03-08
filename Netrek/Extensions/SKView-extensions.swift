//
//  SKView-extensions.swift
//  Netrek
//
//  Created by Darrell Root on 3/7/19.
//  Copyright © 2019 Network Mom LLC. All rights reserved.
//

import Foundation
import SpriteKit
extension SKView {
    open override func rightMouseDown(with event: NSEvent) {
        self.scene?.rightMouseDown(with: event)
    }
}
