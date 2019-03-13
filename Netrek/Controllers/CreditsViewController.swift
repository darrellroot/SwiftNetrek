//
//  CreditsViewController.swift
//  Netrek
//
//  Created by Darrell Root on 3/13/19.
//  Copyright © 2019 Network Mom LLC. All rights reserved.
//

import Foundation
import Cocoa
import WebKit


class CreditsViewController: NSViewController {
    
    @IBOutlet weak var creditsWebView: WKWebView!
    
    override func viewDidLoad() {
        let html = loadHTML("FullCredits")
        creditsWebView.loadHTMLString(html, baseURL: nil)
    }
    
    func loadHTML(_ fileName: String) -> String {
        var html: String
        guard let filePath = Bundle.main.path(forResource: fileName, ofType:"html") else {
            return("Error reading \(fileName).html file")
        }
        let url = URL(fileURLWithPath: filePath)
        do {
            html = try String(contentsOf: url, encoding: .utf8)
        }
        catch {
            return("Error reading \(fileName).html file")
        }
        return(html)
    }

}
