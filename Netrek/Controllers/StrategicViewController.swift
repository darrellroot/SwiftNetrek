//
//  StrategicViewController.swift
//  Netrek
//
//  Created by Darrell Root on 3/5/19.
//  Copyright © 2019 Network Mom LLC. All rights reserved.
//

import Cocoa

class StrategicViewController: NSViewController {
    let appDelegate = NSApplication.shared.delegate as! AppDelegate

    @IBOutlet var strategicView: StrategicView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        appDelegate.strategicViewController = self
        // Do view setup here.
        //self.view.wantsLayer = true
        //self.view.layer?.backgroundColor = NSColor.black.cgColor
        let savedFont = appDelegate.defaults.float(forKey: strategicFontKey)
        if savedFont > 1.0 {
            self.strategicView.setFontSize(newSize: CGFloat(savedFont))
        }
    }
    override func rightMouseDragged(with event: NSEvent) { print(#function) }

}
