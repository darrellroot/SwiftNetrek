//
//  TcpReader.swift
//  Netrek
//
//  Created by Darrell Root on 3/1/19.
//  Copyright © 2019 Network Mom LLC. All rights reserved.
//

import Foundation
import AppKit
import Network

class TcpReader {
    let appDelegate = NSApplication.shared.delegate as! AppDelegate
    let hostname: String
    let port: Int
    let connection: NWConnection
    var delegate: NetworkDelegate
    let queue: DispatchQueue
    init?(hostname: String, port: Int, delegate: NetworkDelegate) {
        self.hostname = hostname
        self.port = port
        self.delegate = delegate
        let serverEndpoint = NWEndpoint.Host(hostname)
        guard port <= UInt16.max else { return nil }
        guard port > 0 else { return nil }
        let port = UInt16(port)
        queue = DispatchQueue(label: "hostname", attributes: .concurrent)
        guard let portEndpoint = NWEndpoint.Port(rawValue: port) else { return nil }
        connection = NWConnection(host: serverEndpoint, port: portEndpoint, using: .tcp)
        connection.stateUpdateHandler = { [weak self] (newState) in
            switch newState {
            case .ready:
                debugPrint("TcpReader.ready to send")
                self?.appDelegate.newGameState(.serverConnected)
            case .failed(let error):
                debugPrint("TcpReader.client failed with error \(error)")
                self?.appDelegate.newGameState(.noServerSelected)
            case .setup:
                debugPrint("TcpReader.setup")
            case .waiting(_):
                debugPrint("TcpReader.waiting")
            case .preparing:
                debugPrint("TcpReader.preparing")
            case .cancelled:
                debugPrint("TcpReader.cancelled")
                self?.appDelegate.newGameState(.noServerSelected)
            }
        }
        /*connection.receiveMessage { (content, context, isComplete, error) in
            debugPrint("\(Date()) TcpReader: got a message \(String(describing: content?.count)) bytes")
            if let content = content {
                self.delegate.gotData(data: content, from: self.hostname, port: self.port)
            }
        }*/
        connection.receive(minimumIncompleteLength: 8, maximumLength: 15000) { (content, context, isComplete, error) in
            debugPrint("\(Date()) TcpReader: got a message \(String(describing: content?.count)) bytes")
            if let content = content {
                self.delegate.gotData(data: content, from: self.hostname, port: self.port)
            }
        }
        connection.start(queue: queue)
    }
    func send(content: Data) {
        debugPrint("\(Date()) TcpReader.sending data")
        connection.send(content: content, completion: .contentProcessed({ (error) in
            if let error = error {
                print("send error: \(error)")
            }
        }))
    }
}
