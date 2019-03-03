//
//  Tuple16.swift
//  Netrek
//
//  Created by Darrell Root on 3/3/19.
//  Copyright © 2019 Network Mom LLC. All rights reserved.
//

import Foundation
struct Tuple16 {
    var information: (x: UInt8,UInt8,UInt8,UInt8,UInt8,UInt8,UInt8,UInt8,UInt8,UInt8,UInt8,UInt8,UInt8,UInt8,UInt8,UInt8)
    
    init(string: String) {
        var temp: [UInt8] = []
        for _ in 0..<16 {
            temp.append(0)
        }
        for (index,char) in string.utf8.enumerated() {
            if index < 15 {
                // leaving last position with null
                temp[index] = char
            }
        }
        information = (temp[0],temp[1],temp[2],temp[3],temp[4],temp[5],temp[6],temp[7],temp[8],temp[9],temp[10],temp[11],temp[12],temp[13],temp[14],temp[15])
    }
    
}
