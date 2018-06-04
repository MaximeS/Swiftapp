//
//  User.swift
//  TotterIos
//
//  Created by Developer on 18/05/2018.
//  Copyright © 2018 Ynov. All rights reserved.
//

import Foundation

class User {
    let username:String
    let nickname:String
    let firstname:String
    let lastname:String
    
    init(username:String,nickname:String,firstname:String,lastname:String)
    {
        self.username=username
        self.nickname=nickname
        self.firstname=firstname
        self.lastname=lastname
    }
    
}
