//
//  Planet.swift
//  Netrek
//
//  Created by Darrell Root on 3/3/19.
//  Copyright © 2019 Network Mom LLC. All rights reserved.
//

import Foundation

class Planet: CustomStringConvertible {
    private(set) var planetID: Int
    private(set) var name: String
    private(set) var positionX: Int
    private(set) var positionY: Int
    private(set) var owner: Team = .nobody
    private(set) var info: Int = 0
    private(set) var flags: Int = 0
    var armies: Int = 0
    
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
    public func update(name: String, positionX: Int, positionY: Int) {
        self.name = name
        self.positionX = positionX
        self.positionY = positionY
    }
    public func setOwner(newOwnerInt: Int) {
        for team in Team.allCases {
            if newOwnerInt == team.rawValue {
                self.owner = team
                return
            }
        }
    }
    public func setInfo(newInfoInt: Int) {
        self.info = newInfoInt
    }
    public func setFlags(newFlagsInt: Int) {
        self.flags = newFlagsInt
    }
}
