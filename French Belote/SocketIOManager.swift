//
//  SocketIOManager.swift
//  French Belote
//
//  Created by Stefan Auvergne on 5/13/17.
//  Copyright © 2017 com.example. All rights reserved.
//

import Foundation
import SocketIO

class SocketIOManager {
    
    static let sharedInstance = SocketIOManager()
    
    var socket: SocketIOClient
    
    init() {
        
    socket = SocketIOClient(socketURL: URL(string: "http://fitchal.website")!, config: [.log(true), .forcePolling(true)])
        
    }
    
    func connectSocket() {
        self.socket.connect()
    }
    func disconnectSocket() {
        self.socket.disconnect()
    }
    func socketStatus() -> SocketIOClientStatus {
        return socket.status
    }
    
}
