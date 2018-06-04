
//
//  Message.swift
//  TotterIos
//
//  Created by Developer on 18/05/2018.
//  Copyright © 2018 Ynov. All rights reserved.
//

import Foundation

class Message{
    let message:String
    let user:User
    let creationDate:String
    
    init(message:String,user:User,creationDate:String)
    {
        self.message=message
        self.user=user
        self.creationDate=creationDate
    }
}
