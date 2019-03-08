//
//  NetrekMath.swift
//  Netrek
//
//  Created by Darrell Root on 3/7/19.
//  Copyright © 2019 Network Mom LLC. All rights reserved.
//

import Foundation
class NetrekMath {
    
    static let galacticSize = 10000
    static let actionThreshold = 100
    static let planetDiameter = 112
    static let planetFontSize: CGFloat = 80.0
    static let playerSize = 80
    static let torpedoSize = 10
    
    static func directionNetrek2radian(_ directionNetrek: UInt8) -> Double {
        let answer = Double.pi * ((Double(directionNetrek) / -128.0) + 0.5)
        if answer > 0 {
            return answer
        } else {
            return answer - 2.0 * Double.pi
        }
    }
    static func directionNetrek2radian(_ directionNetrek: UInt8) -> CGFloat {
        let answer = CGFloat(Double.pi * ((Double(directionNetrek) / -128.0) + 0.5))
        if answer > 0 {
            return answer
        } else {
            return answer - 2.0 * CGFloat.pi
        }
    }

    static func netrekY2GameY(_ netrekY: Int) -> Int {
        return ( 100000 - netrekY) / 10
    }
    static func netrekX2GameX(_ netrekX: Int) -> Int {
        return netrekX / 10
    }
    static func calculateNetrekDirection(mePositionX: Double, mePositionY: Double, destinationX: Double, destinationY: Double) -> UInt8 {
        let deltaX = Double(destinationX - mePositionX)
        let deltaY = Double(destinationY - mePositionY)
        var angleRadians = atan2(deltaY,deltaX)
        if angleRadians < 0 { angleRadians = angleRadians + Double.pi + Double.pi }
        let netrekDirection = Int(64.0 - 128.0 * angleRadians / Double.pi)
        if netrekDirection >= 0 {
            return(UInt8(netrekDirection))
        } else {
            return(UInt8(netrekDirection + 256))
        }
    }
}
