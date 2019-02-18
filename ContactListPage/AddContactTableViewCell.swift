//
//  AddContactTableViewCell.swift
//  SimpleContact
//
//  Created by 李祎喆 on 2018/6/22.
//  Copyright © 2018年 李祎喆. All rights reserved.
//

import UIKit

class AddContactTableViewCell: UITableViewCell {

    @IBOutlet weak var infotitle: UILabel!
    @IBOutlet weak var infoinput: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
