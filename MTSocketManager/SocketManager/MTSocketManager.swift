//
//  MTSocketManager.swift
//  MTSocketManager
//
//  Created by 李宁 on 2018/12/4.
//  Copyright © 2018 李宁. All rights reserved.
//

import Foundation
import SocketIO

let kMTSocketManagerBaseURL: String = "http://47.99.85.87:3000"

class MTSocketManager {
    
    /// 单例
    static let manager: MTSocketManager = MTSocketManager()
    private init() {
        self.socketManager = SocketManager(socketURL: URL(string: kMTSocketManagerBaseURL)!, config: [.log(true), .forceWebsockets(true)])
        self.mapSocket = socketManager.socket(forNamespace: "/map")
    }
    
    fileprivate let socketManager: SocketManager
    fileprivate let mapSocket: SocketIOClient
    
}

// MARK: - Api
extension MTSocketManager {
    open func start() {
        self.connectMapSocket()
    }
    
}

// MARK: - mapHandle
extension MTSocketManager {
    fileprivate func connectMapSocket() {
        self.addMapHandle()
        self.mapSocket.connect()
    }
    
    fileprivate func addMapHandle() {
        self.mapSocket.onAny({ (event) in
            debugPrint("map 任意事件: \(event)")
        })
        self.mapSocket.on(clientEvent: SocketClientEvent.connect, callback: { [weak self] (data, ack) in
            debugPrint("map Socket连接成功: data === \(data);  ack ==== \(ack)")
            self?.authenticate()
        })
        self.mapSocket.on(clientEvent: SocketClientEvent.error, callback: { (data, ack) in
            debugPrint("map Socket连接出错：data === \(data);  ack ==== \(ack)")
        })
        self.mapSocket.on(clientEvent: SocketClientEvent.pong, callback: { (data, ack) in
            debugPrint("map Socket pong：data === \(data);  ack ==== \(ack)")
        })
        self.mapSocket.on(clientEvent: .ping, callback: { (data, ack) in
            debugPrint("map Socket ping：data === \(data);  ack ==== \(ack)")
        })
        self.mapSocket.on(clientEvent: SocketClientEvent.reconnect, callback: { (data, ack) in
            debugPrint("map Socket 重新连接：data === \(data);  ack ==== \(ack)")
        })
        self.mapSocket.on(clientEvent: .reconnectAttempt, callback: { (data, ack) in
            debugPrint("map Socket 尝试重新连接：data === \(data);  ack ==== \(ack)")
        })
        self.mapSocket.on(clientEvent: .disconnect, callback: { (data, ack) in
            debugPrint("map Socket 断开连接：data === \(data);  ack ==== \(ack)")
        })
        self.mapSocket.on(clientEvent: .websocketUpgrade, callback: { (data, ack) in
            debugPrint("map Socket websocketUpgrade：data === \(data);  ack ==== \(ack)")
        })
        self.mapSocket.on("authenticated", callback: { (data, ack) in
            debugPrint("map 我来了：data === \(data);  ack ==== \(ack)")
        })
        self.mapSocket.on("unauthenticated", callback: { (data, ack) in
            debugPrint("map 我进不去：data === \(data);  ack ==== \(ack)")
        })
    }
    
    private func authenticate() {
        self.mapSocket.emit("authenticate", ["userId" : 116, "token" : "n4MOAy4s"])
    }
}
