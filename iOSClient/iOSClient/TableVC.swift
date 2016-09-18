//
//  TableVC.swift
//  iOSClient
//
//  Created by 田子瑶 on 16/9/16.
//  Copyright © 2016年 田子瑶. All rights reserved.
//

import UIKit

class TableVC: UITableViewController {
    
    var nickname: String!
    var myNavigationBar: UINavigationBar!
    
    var userStates: NSArray!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        installUI()
        print(userStates)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 44
    }
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return userStates.count
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print(indexPath.row)
        let ioVC = IOVC()
        let tmpArr = userStates[indexPath.row] as! NSArray
        ioVC.nickname = tmpArr[1] as! String
        self.presentViewController(ioVC, animated: true, completion: nil)
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("TableCell", forIndexPath: indexPath) as! TableCell
        let tmpArr = userStates[indexPath.row] as! NSArray
        cell.nicknameLabel.text = (tmpArr[1] as? String)!
        print(tmpArr[1] as? String)
        if tmpArr[2] as! String == "1" {
            cell.stateView.backgroundColor = UIColor.greenColor()
        }
        return cell
    }
    
    func installUI() {
        
        let nib = UINib(nibName: "TableCell", bundle: nil)
        self.tableView.registerNib(nib, forCellReuseIdentifier: "TableCell")
        
        let screenRect = UIScreen.mainScreen().bounds
        myNavigationBar = UINavigationBar(frame: CGRectMake(0, 0, screenRect.size.width, 64))
        myNavigationBar.tintColor = UIColor.redColor()
        let navigationTitleItem = UINavigationItem(title: "当前在线")
        myNavigationBar.pushNavigationItem(navigationTitleItem, animated: true)
        myNavigationBar.barStyle = .Black
        self.tableView.tableHeaderView = myNavigationBar
    }

}
