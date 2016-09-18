//
//  IOVC.swift
//  iOSClient
//
//  Created by 田子瑶 on 16/9/16.
//  Copyright © 2016年 田子瑶. All rights reserved.
//

import UIKit

class IOVC: UIViewController {
    
    var nickname: String!
    var messageField: UITextField!
    var submitButton: UIButton!
    var receiveView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        installUI(nickname)
        MySocket.sharedSocket.receiveMessage = { receive in
            
            dispatch_async(dispatch_get_main_queue(), { 
                self.receiveView.text = receive
            })
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func submitButtonDidTouch() {
        
        if messageField.text == "" {
            let alert = UIAlertController(title: "提示", message: "发送消息不能为空", preferredStyle: .Alert)
            let action = UIAlertAction(title: "好的", style: .Default, handler: { (action) in
                print("提示框被点击")
            })
            alert.addAction(action)
            self.presentViewController(alert, animated: true, completion: nil)
        }
        else {
            let message = ("\(nickname):"+messageField.text!).dataUsingEncoding(NSUTF8StringEncoding)
            let socket = MySocket.sharedSocket
            socket.sendMessage(message!)
            messageField.text = ""
        }

    }
    
    func installUI(nickname: String) {
        
        self.view.backgroundColor = UIColor(red: 0/255, green: 204/255, blue: 102/255, alpha: 1)
        
        let screenBouns = UIScreen.mainScreen().bounds
        let navigationBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: screenBouns.size.width, height: 64))
        let navigationTitle = UINavigationItem(title: nickname)
        navigationBar.pushNavigationItem(navigationTitle, animated: true)
        navigationBar.barStyle = .Black
        self.view.addSubview(navigationBar)
        
        messageField = UITextField(frame: CGRect(x: 0, y: 0, width: screenBouns.size.width, height: 30))
        messageField.center = self.view.center
        messageField.center.y = messageField.center.y + 30
        messageField.borderStyle = .None
        messageField.textAlignment = .Center
        messageField.font = UIFont.systemFontOfSize(14)
        messageField.textColor = UIColor.whiteColor()
        self.view.addSubview(messageField)
        
        let topCutLine = UIView(frame: CGRect(x: 20, y: 0, width: screenBouns.size.width - 40, height: 1))
        topCutLine.backgroundColor = UIColor.whiteColor()
        topCutLine.center = messageField.center
        topCutLine.center.y = messageField.center.y - 20
        self.view.addSubview(topCutLine)
        
        let bottomCutLine = UIView(frame: CGRect(x: 20, y: 0, width: screenBouns.size.width - 40, height: 1))
        bottomCutLine.backgroundColor = UIColor.whiteColor()
        bottomCutLine.center = messageField.center
        bottomCutLine.center.y = messageField.center.y + 20
        self.view.addSubview(bottomCutLine)
        
        submitButton = UIButton(frame: CGRect(x: 20, y: 0, width: screenBouns.size.width - 40, height: 44))
        submitButton.backgroundColor = UIColor.darkGrayColor()
        submitButton.layer.cornerRadius = 5
        submitButton.setTitle("发送到服务器", forState: .Normal)
        submitButton.titleLabel?.font = UIFont.systemFontOfSize(15)
        submitButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        submitButton.center = self.view.center
        submitButton.center.y = self.view.frame.size.height - 68
        submitButton.addTarget(self, action: #selector(IOVC.submitButtonDidTouch), forControlEvents: .TouchUpInside)
        self.view.addSubview(submitButton)
        
        receiveView = UITextView(frame: CGRect(x: 20, y: 0, width: screenBouns.size.width - 40, height: 88))
        receiveView.textAlignment = .Center
        receiveView.backgroundColor = UIColor.clearColor()
        receiveView.text = "等待回复"
        receiveView.textColor = UIColor.whiteColor()
        receiveView.font = UIFont.systemFontOfSize(14)
        receiveView.center = self.view.center
        receiveView.center.y = 120
        self.view.addSubview(receiveView)
        
    }

}
