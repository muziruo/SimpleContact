//
//  DetailTableViewCell.swift
//  SimpleContact
//
//  Created by 李祎喆 on 2018/6/15.
//  Copyright © 2018年 李祎喆. All rights reserved.
//

import UIKit

class DetailTableViewCell: UITableViewCell {

    @IBOutlet weak var detailinfo: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
