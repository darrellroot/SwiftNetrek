//
//  OtherPreferencesController.swift
//  Netrek
//
//  Created by Darrell Root on 3/13/19.
//  Copyright © 2019 Network Mom LLC. All rights reserved.
//

import Cocoa

class OtherPreferencesController: NSViewController {
    let appDelegate = NSApplication.shared.delegate as! AppDelegate

    @IBOutlet weak var enableSoundButton: NSButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        if let soundDisabled = appDelegate.soundController?.soundDisabled {
            if soundDisabled {
                self.enableSoundButton.state = .off
            } else {
                self.enableSoundButton.state = .on
            }
        }
    }
    
    @IBAction func playerListFontSelected(_ sender: NSPopUpButton) {
        if let fontString = sender.titleOfSelectedItem {
            if let fontFloat = Float(fontString) {
                let font = CGFloat(fontFloat)
                debugPrint("player font \(font) selected")
                appDelegate.playerListViewController?.playerView.setFontSize(newSize: font)

            }
        }
    }
    
    @IBAction func strategicMapFontSelected(_ sender: NSPopUpButton) {
        if let fontString = sender.titleOfSelectedItem {
            if let fontFloat = Float(fontString) {
                let font = CGFloat(fontFloat)
                debugPrint("strategic font \(font) selected")
                appDelegate.strategicViewController?.strategicView?.setFontSize(newSize: font)

            }
        }
    }
    @IBAction func enableSoundAction(_ sender: NSButton) {
        if sender.state == .on {
            appDelegate.soundController?.enableSound()
        } else if sender.state == .off {
            appDelegate.soundController?.disableSound()
        }
    }
    
}
