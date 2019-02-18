//
//  ContactPeople.swift
//  SimpleContact
//
//  Created by 李祎喆 on 2018/6/14.
//  Copyright © 2018年 李祎喆. All rights reserved.
//

import Foundation

struct ContactPeople {
    var name:String
    var phonenumber:String
    var address:String
    var company:String
    var emailaddress:String
    var imageurl:String
    

    init(name:String,phonenumber:String,address:String,company:String,emailaddress:String,imageurl:String) {
        self.name = name
        self.phonenumber = phonenumber
        self.address = address
        self.company = company
        self.emailaddress = emailaddress
        self.imageurl = imageurl
    }
    
    init() {
        self.name = ""
        self.phonenumber = ""
        self.address = ""
        self.company = ""
        self.imageurl = ""
        self.emailaddress = ""
    }
}
