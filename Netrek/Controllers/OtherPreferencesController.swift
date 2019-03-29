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
    @IBOutlet weak var basicTipsButton: NSButton!
    @IBOutlet weak var advancedTipsButton: NSButton!
    @IBOutlet weak var playerListFontMenu: NSMenu!
    @IBOutlet weak var strategicMapFontMenu: NSMenu!
    
    let defaults = UserDefaults.standard

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
        if defaults.bool(forKey: DefaultKey.basicTipsDisabled.rawValue) {
            self.basicTipsButton.state = .off
        } else {
            self.basicTipsButton.state = .on
        }
        if defaults.bool(forKey: DefaultKey.advancedTipsDisabled.rawValue) {
            self.advancedTipsButton.state = .off
        } else {
            self.advancedTipsButton.state = .on
        }
        let playerListFontSizeFloat = UserDefaults.standard.float(forKey: playerListFontKey)
        if playerListFontSizeFloat > 1 {
            let playerListFontSizeString = String(Int(playerListFontSizeFloat))
            let playerFontIndex = playerListFontMenu.indexOfItem(withTitle: playerListFontSizeString)
            if playerFontIndex >= 0 {
                playerListFontMenu.performActionForItem(at: playerFontIndex)
            }
        }
        let strategicFontSizeFloat = UserDefaults.standard.float(forKey: strategicFontKey)
        if strategicFontSizeFloat > 1 {
            let strategicFontSizeString = String(Int(strategicFontSizeFloat))
            let strategicFontIndex = strategicMapFontMenu.indexOfItem(withTitle: strategicFontSizeString)
            if strategicFontIndex >= 0 {
                strategicMapFontMenu.performActionForItem(at: strategicFontIndex)
            }
        }

    }
    @IBAction func basicTipsButton(_ sender: NSButton) {
        if sender.state == .on {
            defaults.set(false, forKey: DefaultKey.basicTipsDisabled.rawValue)
        } else {
            defaults.set(true, forKey: DefaultKey.basicTipsDisabled.rawValue)
        }
    }
    @IBAction func advancedTipsButton(_ sender: NSButton) {
        if sender.state == .on {
            defaults.set(false, forKey: DefaultKey.advancedTipsDisabled.rawValue)
        } else {
            defaults.set(true, forKey: DefaultKey.advancedTipsDisabled.rawValue)
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
