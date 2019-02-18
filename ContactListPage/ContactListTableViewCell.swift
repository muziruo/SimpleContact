//
//  ContactListTableViewCell.swift
//  SimpleContact
//
//  Created by 李祎喆 on 2018/6/14.
//  Copyright © 2018年 李祎喆. All rights reserved.
//

import UIKit

class ContactListTableViewCell: UITableViewCell {

    @IBOutlet weak var contactpeopleimage: UIImageView!
    @IBOutlet weak var contactname: UILabel!
    @IBOutlet weak var contactphone: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
