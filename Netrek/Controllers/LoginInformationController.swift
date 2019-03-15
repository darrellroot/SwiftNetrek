//
//  LoginInformationController.swift
//  Netrek
//
//  Created by Darrell Root on 3/14/19.
//  Copyright © 2019 Network Mom LLC. All rights reserved.
//

import Cocoa

enum LoginDefault: String {
    case loginName = "loginName"
    case loginUserName = "loginUserName"
}
class LoginInformationController: NSViewController {

    let appDelegate = NSApplication.shared.delegate as! AppDelegate
    let defaults = UserDefaults.standard

    @IBOutlet weak var nameOutlet: NSTextField!
    
    @IBOutlet weak var userNameOutlet: NSTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        if let name = appDelegate.loginName {
            nameOutlet.stringValue = name
        }
        if let userName = appDelegate.loginUserName {
            userNameOutlet.stringValue = userName
        }
    }
    
    @IBAction func segmentedControlSelected(_ sender: NSSegmentedControl) {
        if sender.selectedSegment == 0 {
            appDelegate.playAsGuest = true
        }
        if sender.selectedSegment == 1 {
            appDelegate.playAsGuest = false
        }
    }
    @IBAction func nameTextFieldAction(_ sender: NSTextField) {
        if sender.stringValue != "" {
            appDelegate.loginName = sender.stringValue
            defaults.setString(string: sender.stringValue, forKey: LoginDefault.loginName.rawValue)
        } else {
            appDelegate.loginName = nil
            defaults.removeObject(forKey: LoginDefault.loginName.rawValue)
        }
    }
    @IBAction func passwordTextFieldAction(_ sender: NSSecureTextField) {
        if sender.stringValue != "" {
            appDelegate.loginPassword = sender.stringValue
        } else {
            appDelegate.loginPassword = nil
        }
    }
    @IBAction func usernameTextFieldAction(_ sender: NSTextField) {
        if sender.stringValue != "" {
            appDelegate.loginUserName = sender.stringValue
            defaults.setString(string: sender.stringValue, forKey: LoginDefault.loginUserName.rawValue)
        } else {
            appDelegate.loginPassword = nil
            defaults.removeObject(forKey: LoginDefault.loginUserName.rawValue)
        }
    }
    
}
