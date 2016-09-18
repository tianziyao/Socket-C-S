//
//  TableCell.swift
//  iOSClient
//
//  Created by 田子瑶 on 16/9/17.
//  Copyright © 2016年 田子瑶. All rights reserved.
//

import UIKit

class TableCell: UITableViewCell {

    @IBOutlet weak var nicknameLabel: UILabel!
    @IBOutlet weak var stateView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
