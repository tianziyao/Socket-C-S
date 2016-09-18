//
//  MySocket.swift
//  MacServer
//
//  Created by 田子瑶 on 16/9/17.
//  Copyright © 2016年 田子瑶. All rights reserved.
//

import Foundation
import CocoaAsyncSocket

class MySocket: GCDAsyncSocketDelegate {
    
    var isRuning: Bool = false
    var port: UInt16!
    var host: String!
    var currentSocket: GCDAsyncSocket!
    var currentHost: String!
    
    var recivieMessage: (String -> ())!
    
    var connectionSockets: [GCDAsyncSocket] = []
    var userStates: [[String!]] = []
    
    private var listener: GCDAsyncSocket!
    
    static let sharedSocket = MySocket()
    
    private init() {
        let globalQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
        listener = GCDAsyncSocket(delegate: self,delegateQueue: globalQueue)
        listener.delegate = self
    }
    
    func startListen() {
        
        if !isRuning {
            do {
                try listener.acceptOnPort(port)
                print("开始监听 \(host) \(port)")
                //try listener.acceptOnInterface(host, port: port)
                //NSRunLoop.mainRunLoop().run()
                isRuning = true
            }
            catch {
                print("服务开启失败")
            }
        }
        else {
            print("重新监听")
            listener.disconnect()
            for connectionSocket in connectionSockets {
                connectionSocket.disconnect()
            }
            isRuning = false
        }
    }
    
    func sendMessage(message: NSData) {
        currentSocket.writeData(message, withTimeout: -1, tag: 0)
        print("发送消息")
    }
    
    func sendMessages(message: String, sockets: [GCDAsyncSocket]) {
        let msg = message.dataUsingEncoding(NSUTF8StringEncoding)
        for socket in sockets {
            socket.writeData(msg!, withTimeout: -1, tag: 0)
        }
    }
    
    @objc func socket(sock: GCDAsyncSocket, didWriteDataWithTag tag: Int) {
        print("发送消息成功之后回调")
        listener.readDataWithTimeout(-1, tag: tag)
    }
    
    /*读取客户端发送来的信息(收到socket信息时调用)*/
    @objc func socket(sock: GCDAsyncSocket, didReadData data: NSData, withTag tag: Int) {
        
        let msg = String(data: data, encoding: NSUTF8StringEncoding)
        recivieMessage(msg!)
        let tmpMsg = msg?.componentsSeparatedByString(":")
        if tmpMsg?.first == "user" {
            do {
                currentHost = "\(sock.connectedHost!)"
                let tmpArr = [currentHost, "\(tmpMsg![1])", "1"]
                userStates.append(tmpArr)
                let json = try NSJSONSerialization.dataWithJSONObject(userStates, options: .PrettyPrinted)
                sock.writeData(json, withTimeout: -1, tag: 0)
            }
            catch {
                print("传输出错")
            }
            
        }
        //sock.writeData((msg?.dataUsingEncoding(NSUTF8StringEncoding))!, withTimeout: -1, tag: 0)
        sock.readDataWithTimeout(-1, tag: 0)
        currentSocket = sock
    }
    
    @objc func socket(sock: GCDAsyncSocket, didAcceptNewSocket newSocket: GCDAsyncSocket) {
        newSocket.readDataWithTimeout(-1, tag: 0)
        connectionSockets.append(newSocket)
        print("收到新的socket")
        print(sock.userData)
    }
    
    @objc func socketDidDisconnect(sock: GCDAsyncSocket, withError err: NSError?) {
        print("socket连接已经关闭 \(err)")
        
        for i in 0..<userStates.count {
            if userStates[i][0] == currentHost {
                userStates[i][2] = "0"
                let msg = "\(userStates[i][1])已下线"
                sendMessages(msg, sockets: connectionSockets)
            }
        }
        print(userStates)
//        for var userState in userStates {
//            if userState.first! == currentHost {
//                userState[2] = "0"
//                print(userState)
//                let msg = "\(userState[1])已下线"
//                sendMessages(msg, sockets: connectionSockets)
//            }
//        }
//        print(userStates)
    }
    
    /*与服务器建立连接时调用(连接成功)*/
    @objc func socket(sock: GCDAsyncSocket, didConnectToHost host: String, port: UInt16) {
        print("当前连接的客户端是 \(host)")
        //向当前连接服务器的客户端发送连接成功信息
        //        sock.writeData("Welcome".dataUsingEncoding(NSUTF8StringEncoding)!, withTimeout: -1, tag: 0)
        //        listener.writeData("Welcome".dataUsingEncoding(NSUTF8StringEncoding)!, withTimeout: -1, tag: 0)
        //
        //        listener.readDataWithTimeout(-1, tag: 0)
    }
    
    
}
