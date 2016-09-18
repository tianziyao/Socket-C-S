//
//  ViewController.swift
//  iOSClient
//
//  Created by 田子瑶 on 16/9/16.
//  Copyright © 2016年 田子瑶. All rights reserved.
//

import UIKit

class MainVC: UIViewController {
    
    @IBOutlet weak var nicenameField: UITextField!
    
    var userStates: NSArray!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("wtf")
        MySocket.sharedSocket.receuveUserStates = { arr in
            self.userStates = arr
            let tableVC = TableVC()
            print(self.userStates)
            tableVC.userStates = self.userStates
            dispatch_async(dispatch_get_main_queue(), { 
                self.presentViewController(tableVC, animated: true, completion: nil)
            })
            print("闭包userStates")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }

    @IBAction func submitButtonClicked(sender: AnyObject) {
        
        if nicenameField.text == "" {
            let alert = UIAlertController(title: "提示", message: "请输入昵称", preferredStyle: .Alert)
            let action = UIAlertAction(title: "好的", style: .Default, handler: { (action) in
                print("提示框被点击")
            })
            alert.addAction(action)
            self.presentViewController(alert, animated: true, completion: nil)
        }
        else {
            let socket = MySocket.sharedSocket
            socket.host = "127.0.0.1"
            socket.port = 1234
            socket.connectToServer()
            socket.sendMessage("user:\(nicenameField.text!)".dataUsingEncoding(NSUTF8StringEncoding)!)
        }

    }

}
