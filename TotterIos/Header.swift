//
//  Header.swift
//  TotterIos
//
//  Created by Developer on 18/05/2018.
//  Copyright © 2018 Ynov. All rights reserved.
//

import Foundation

class baseHeaders{
    static var headers:[String:String]=["":""]
    static func setHeaders(headers:[String:String])
    {
        self.headers=headers
    }
    static func getHeaders()->[String:String]
    {
        return self.headers
    }
}
