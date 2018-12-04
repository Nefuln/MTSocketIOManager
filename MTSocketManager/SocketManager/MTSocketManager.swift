//
//  MTSocketManager.swift
//  MTSocketManager
//
//  Created by 李宁 on 2018/12/4.
//  Copyright © 2018 李宁. All rights reserved.
//

import Foundation
import SocketIO

class MTSocketManager: NSObject {
    
    /// 单例
    static let manager: MTSocketManager = MTSocketManager()
    private override init() {
        super.init()
    }
    
    deinit {
        debugPrint("被释放了")
    }
    
    fileprivate(set) var socket: SocketIOClient?
    fileprivate(set) var socketManager: SocketManager?
 
    var baseURL: String? {
        didSet {
            assert(baseURL != nil, "baseURL为空")
            let realURL =  URL(string: baseURL!)
            assert(realURL != nil, "URL不合法")
            socketManager = SocketManager(socketURL: realURL!, config: [.log(true), .compress])
            socket = socketManager?.defaultSocket
        }
    }
    
}

// MARK: - Api
extension MTSocketManager {
    open func connect() {
        assert(socket != nil, "无效的socket连接")
        addHandle()
        socket?.connect()
    }
}

// MARK: - Handle
extension MTSocketManager {
    fileprivate func addHandle() {
        socket?.onAny({ (event) in
            debugPrint("任意事件: \(event)")
        })
        socket?.on(clientEvent: SocketClientEvent.connect, callback: { [weak self] (data, ack) in
            debugPrint("Socket连接成功: data === \(data);  ack ==== \(ack)")
            self?.authenticate()
        })
        socket?.on(clientEvent: SocketClientEvent.error, callback: { (data, ack) in
            debugPrint("Socket连接出错：data === \(data);  ack ==== \(ack)")
        })
        socket?.on(clientEvent: SocketClientEvent.pong, callback: { (data, ack) in
            debugPrint("Socket pong：data === \(data);  ack ==== \(ack)")
        })
        socket?.on(clientEvent: .ping, callback: { (data, ack) in
            debugPrint("Socket ping：data === \(data);  ack ==== \(ack)")
        })
        socket?.on(clientEvent: SocketClientEvent.reconnect, callback: { (data, ack) in
            debugPrint("Socket 重新连接：data === \(data);  ack ==== \(ack)")
        })
        socket?.on(clientEvent: .reconnectAttempt, callback: { (data, ack) in
            debugPrint("Socket 尝试重新连接：data === \(data);  ack ==== \(ack)")
        })
        socket?.on(clientEvent: .disconnect, callback: { (data, ack) in
            debugPrint("Socket 断开连接：data === \(data);  ack ==== \(ack)")
        })
        socket?.on(clientEvent: .websocketUpgrade, callback: { (data, ack) in
            debugPrint("Socket websocketUpgrade：data === \(data);  ack ==== \(ack)")
        })
        socket?.on("authenticate", callback: { (data, ack) in
            debugPrint("我来了：data === \(data);  ack ==== \(ack)")
        })
        socket?.on("unauthenticated", callback: { (data, ack) in
            debugPrint("我进不去：data === \(data);  ack ==== \(ack)")
        })
    }
    
    private func authenticate() {
        socket?.emit("authenticate", with: [["userId" : 116, "token" : "n4MOAy4s"]])
    }
}
