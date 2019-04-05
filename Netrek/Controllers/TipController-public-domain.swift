//
//  TipController.swift
//  Netrek
//
//  Created by Darrell Root on 3/30/19.
//  Copyright © 2019 Network Mom LLC. All rights reserved.
//

import Cocoa
//import StoreKit

enum productIdentifiers: String {
    case tip5 = "net.networkmom.netrek.tip5"
}
class TipController: NSViewController {
    
    @IBOutlet weak var tipButtonOutlet: NSButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        tipButtonOutlet.title = "Tipping not supported in public domain version"
    }
    
    @IBAction func restoreButton(_ sender: NSButton) {
        tipButtonOutlet.title = "Restoring tips not supported in public domain version"
    }
    
    @IBAction func tipButton(_ sender: NSButton) {
        debugPrint("Tip button pressed")
        tipButtonOutlet.title = "Tips not supported in public domain version -- but thank you!"
    }
    


}
