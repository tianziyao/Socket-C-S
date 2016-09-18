//
//  ViewController.swift
//  MacServer
//
//  Created by 田子瑶 on 16/9/17.
//  Copyright © 2016年 田子瑶. All rights reserved.
//

import Cocoa
import CocoaAsyncSocket

class ViewController: NSViewController, GCDAsyncSocketDelegate {
    
    @IBOutlet weak var messageField: NSTextField!
    @IBOutlet weak var receiveField: NSTextField!
    
    var socket: MySocket!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        socket = MySocket.sharedSocket
        socket.port = 1234
        socket.host = "127.0.0.1"
        socket.startListen()
        socket.recivieMessage = { msg in
            self.receiveField.stringValue = msg
            print("闭包")
        }
    }
    
    override var representedObject: AnyObject? {
        didSet {
            // Update the view, if already loaded.
        }
    }
    
    
    @IBAction func sendButtonDidTouch(sender: AnyObject) {
        
        if messageField.stringValue.isEmpty {
            receiveField.stringValue = "请输入消息"
            
        }
        else {
            socket.sendMessage(("msg:" + messageField.stringValue).dataUsingEncoding(NSUTF8StringEncoding)!)
            messageField.stringValue = ""
        }
    }
    
}



