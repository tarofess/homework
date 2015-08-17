//
//  User.swift
//  宿題マスター2
//
//  Created by taro on 2015/08/06.
//  Copyright (c) 2015年 taro. All rights reserved.
//

import Foundation

class User: RLMObject {
    dynamic var id = 0
    dynamic var userName = ""
    dynamic var score = 0
    dynamic var characterName = ""
    
    override class func primaryKey() -> String? {
        return "id"
    }
}
