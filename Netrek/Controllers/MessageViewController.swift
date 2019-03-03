//
//  MessageViewController.swift
//  Netrek
//
//  Created by Darrell Root on 3/2/19.
//  Copyright © 2019 Network Mom LLC. All rights reserved.
//

import Cocoa

class MessageViewController: NSViewController {
    
    let appDelegate = NSApplication.shared.delegate as! AppDelegate

    @IBOutlet weak var messagesLabel: NSTextField!
    
    var messages: [String] = []
    let maxMessages = 20

    override func viewDidLoad() {
        super.viewDidLoad()
        appDelegate.messageViewController = self
        for _ in 0 ..< maxMessages {
            self.gotMessage(message: "\n")
        }
    }

    public func gotMessage(message:String) {
        messages.append(message)
        if messages.count > maxMessages {
            messages.remove(at: 0)
        }
        self.update()
    }
    
    func update() {
        var totalMessage: String = ""
        for message in messages {
            totalMessage.append(message)
            DispatchQueue.main.async {
                self.messagesLabel.stringValue = totalMessage
            }
        }
    }
    
}
