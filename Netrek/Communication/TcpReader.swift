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
    //var timer: Timer?
    let appDelegate = NSApplication.shared.delegate as! AppDelegate
    let hostname: String
    let port: Int
    let connection: NWConnection
    var delegate: NetworkDelegate
    let queue: DispatchQueue
    var receiving: Bool = false // primitive lock on receiving
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
        //var options = NWProtocolTCP.Options()
        //options.noDelay = true

        //var parameters = NWParameters()
        //parameters.
        //let ipOptions = NWParameters().defaultProtocolStack.transportProtocol as? NWProtocolTCP.Options
        //ipOptions?.noDelay = true

        connection = NWConnection(host: serverEndpoint, port: portEndpoint, using: .tcp)
        //let connection2 = NWConnection(host: serverEndpoint, port: portEndpoint, using: ipOptions!)
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
        let interval = 1.0 / Double(UPDATE_RATE)
        //timer = Timer.scheduledTimer(timeInterval: interval, target: self, selector: #selector(receive), userInfo: nil, repeats: true)
        //timer!.tolerance = interval / 10.0
        
        //if let timer = timer {
        //    timer.tolerance = interval / 10.0
        //    RunLoop.current.add(timer, forMode: .common)
        //}
        
        
        /*connection.receiveMessage { (content, context, isComplete, error) in
            debugPrint("\(Date()) TcpReader: got a message \(String(describing: content?.count)) bytes")
            if let content = content {
                self.delegate.gotData(data: content, from: self.hostname, port: self.port)
            }
        }*/
        /*connection.receive(minimumIncompleteLength: 8, maximumLength: 15000) { (content, context, isComplete, error) in
            debugPrint("\(Date()) TcpReader: got a message \(String(describing: content?.count)) bytes")
            if let content = content {
                self.delegate.gotData(data: content, from: self.hostname, port: self.port)
            }
        }*/
        connection.start(queue: queue)
    }
    @objc func receive() {  // called by timer
        if receiving { return }
        self.receiving = true
        /*
        connection.receiveMessage { (content, context, isComplete, error) in
            debugPrint("\(Date()) TcpReader: got a message \(String(describing: content?.count)) bytes")
            if let content = content {
                self.delegate.gotData(data: content, from: self.hostname, port: self.port)
            }
        }
        */
        //debugPrint("trying to receive data")
        connection.receive(minimumIncompleteLength: 1, maximumLength: 8192) { (content, context, isComplete, error) in
            if (content?.count ?? 0) > 0 {
                debugPrint("\(Date()) TcpReader: got a message \(String(describing: content?.count)) bytes")
            }
            if let content = content {
                self.delegate.gotData(data: content, from: self.hostname, port: self.port)
            }
        }
        self.receiving = false
        //debugPrint("returning from trying to receive data")
    }
    
    func send(content: Data) {
        debugPrint("\(Date()) TcpReader.sending data \(content.count) bytes")
        connection.send(content: content, completion: .contentProcessed({ (error) in
            if let error = error {
                print("send error: \(error)")
            }
        }))
    }
}
