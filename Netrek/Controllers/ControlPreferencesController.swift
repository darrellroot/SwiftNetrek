//
//  ControlPreferencesController.swift
//  Netrek
//
//  Created by Darrell Root on 3/13/19.
//  Copyright © 2019 Network Mom LLC. All rights reserved.
//

import Cocoa

class ControlPreferencesController: NSViewController {
    let appDelegate = NSApplication.shared.delegate as! AppDelegate

    @IBOutlet weak var scrollView: FlipScrollView!
    
    let leftPosition = 20
    let rightPosition = 120
    let verticalSpacing = 20
    let horizontalSpacing = 100
    let verticalOffset = 60
    var commandStringArray: [String] = []
    var controlArray: [Control] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        //scrollView.bounds. = verticalSpacing * Control.allCases.count
        let width = view.bounds.width
        scrollView.documentView?.frame = NSRect(x: 0, y: 0, width: width, height: CGFloat(verticalSpacing * Control.allCases.count))
        
        for command in Command.allCases {
            commandStringArray.append(command.rawValue)
        }
        controlArray = Control.allCases

        self.setupControls()
    }
    private func setupControls() {
        for view in scrollView.documentView?.subviews ?? [] {
            view.removeFromSuperview()
        }
        let resetButton = NSButton()
        resetButton.frame = NSRect(x: 100, y: verticalSpacing, width: 200, height: verticalSpacing)
        resetButton.bezelStyle = .rounded
        resetButton.title = "Reset All To Defaults"
        resetButton.action = #selector(resetAll)
        scrollView.documentView?.addSubview(resetButton)
        
        for (index,control) in Control.allCases.enumerated() {
            
            let label = Label()
            label.stringValue = control.rawValue
            label.bounds = NSRect(x: 0, y: 0, width: horizontalSpacing, height: verticalSpacing)
            label.frame = NSRect(x: leftPosition, y: index * verticalSpacing + verticalOffset, width:  horizontalSpacing, height: verticalSpacing)
            scrollView.documentView?.addSubview(label)
            
            let button = NSPopUpButton()
            button.frame = NSRect(x: rightPosition, y: index * verticalSpacing + verticalOffset, width: horizontalSpacing * 3, height: verticalSpacing)
            button.addItems(withTitles: commandStringArray)
            button.tag = index
            button.action = #selector(popupSelected)
            if let selectedCommand = appDelegate.keymapController.keymap[control] {
                button.selectItem(withTitle: selectedCommand.rawValue)
            }
            scrollView.documentView?.addSubview(button)
        }

    }
    @objc func popupSelected(sender: NSPopUpButton) {
        //if let commandString = sender.titleOfSelectedItem {
        if let control = controlArray[safe: sender.tag] {
            for command in Command.allCases {
                if command.rawValue == sender.titleOfSelectedItem {
                    appDelegate.keymapController.setKeymap(control: control, command: command)
                    //appDelegate.keymapController.keymap[control] = command
                    debugPrint("setting control \(control.rawValue) to command \(command.rawValue)")
                }
            }
        }
    }
    @objc func resetAll(sender: NSButton) {
        appDelegate.keymapController.resetKeymaps()
        self.setupControls()
    }
}
