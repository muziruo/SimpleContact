//
//  EditTableViewCell.swift
//  SimpleContact
//
//  Created by 李祎喆 on 2018/6/26.
//  Copyright © 2018年 李祎喆. All rights reserved.
//

import UIKit

class EditTableViewCell: UITableViewCell {

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var edit: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
