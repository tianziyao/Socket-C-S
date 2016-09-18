//
//  Socket.swift
//  iOSClient
//
//  Created by 田子瑶 on 16/9/16.
//  Copyright © 2016年 田子瑶. All rights reserved.
//

import Foundation
//import CocoaAsyncSocket

class MySocket: GCDAsyncSocketDelegate {
    
    var port: UInt16!
    var host: String!
    
    private var listener: GCDAsyncSocket!
    static let sharedSocket = MySocket()
    var receiveMessage: (String -> ())!
    var receuveUserStates: (NSArray -> Void)!
    
    private init() {
        let globalQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
        listener = GCDAsyncSocket(delegate: self,delegateQueue: globalQueue)
    }
    
    func connectToServer() {
        do {
            try listener.connectToHost(host, onPort: port)
        }
        catch {
            print("连接服务器出错")
        }
    }
    
    func sendMessage(message: NSData) {
        listener.writeData(message, withTimeout: -1, tag: 0)
        //print("发送消息")
    }
    
    @objc func socket(sock: GCDAsyncSocket, didWriteDataWithTag tag: Int) {
        print("发送消息成功之后回调")
        listener.readDataWithTimeout(-1, tag: tag)
    }
    
    @objc func socket(sock: GCDAsyncSocket, didReadData data: NSData, withTag tag: Int) {
        
        let receive = String(data: data, encoding: NSUTF8StringEncoding)
        let tmpMsg = receive?.componentsSeparatedByString(":")
        
        if tmpMsg?.first == "msg" {
            receiveMessage(receive!)
        }
        else {
            do {
                let receive = try NSJSONSerialization.JSONObjectWithData(data, options: .MutableLeaves) as! NSArray
                //print(receive)
                receuveUserStates(receive)
            }
            catch {
                print("读取Json出错")
            }
        }

        
        sock.readDataWithTimeout(-1, tag: 0)
    }

    @objc func socketDidSecure(sock: GCDAsyncSocket) {
        print("didSecure:YES")
    }

    @objc func socketDidDisconnect(sock: GCDAsyncSocket, withError err: NSError?) {
        print("socketDidDisconnect  \(err)")
    }
    
    @objc func socket(sock: GCDAsyncSocket, didConnectToHost host: String, port: UInt16) {
        print("连接服务器成功 \(host) \(port)")
    }

    
}

