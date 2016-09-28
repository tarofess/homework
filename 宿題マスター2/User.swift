//
//  User.swift
//  宿題マスター2
//
//  Created by taro on 2015/08/06.
//  Copyright (c) 2015年 taro. All rights reserved.
//

import Foundation
import RealmSwift

class User: Object {
    
    dynamic var id = UUID().uuidString
    dynamic var name: String!
    dynamic var score = 0
    dynamic var characterName = "赤ちゃん"
    
    override class func primaryKey() -> String {
        return "id"
    }
    
}
