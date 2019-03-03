//
//  packets-extensions.swift
//  Netrek
//
//  Created by Darrell Root on 3/3/19.
//  Copyright © 2019 Network Mom LLC. All rights reserved.
//

import Foundation

extension login_cpacket {
    var size: Int {
        get {
            return 52
        }
    }
}
