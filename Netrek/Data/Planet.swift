//
//  Planet.swift
//  Netrek
//
//  Created by Darrell Root on 3/3/19.
//  Copyright © 2019 Network Mom LLC. All rights reserved.
//

import Foundation

class Planet: CustomStringConvertible {
    var planetID: Int
    var name: String
    var positionX: Int
    var positionY: Int
    
    var description: String {
        get {
            return "planet planetID: \(planetID) name: \(name) position: \(positionX) \(positionY)"
        }
    }
    init(planetID: Int) {
        self.planetID = planetID
        self.name = "unknown"
        self.positionX = 0
        self.positionY = 0
    }
    func update(name: String, positionX: Int, positionY: Int) {
        self.name = name
        self.positionX = positionX
        self.positionY = positionY
    }
}
